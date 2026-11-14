# Pharmacy / Drug Inventory System — SQL queries

## 1. Show related stock_lot, product, supplier records (up to 20).

```sql
SELECT t0."lot_id" AS "stock_lot_lot_id",
       t0."lot_code" AS "stock_lot_lot_code",
       t1."product_id" AS "product_product_id",
       t1."sku" AS "product_sku",
       t2."supplier_id" AS "supplier_supplier_id",
       t2."supplier_name" AS "supplier_supplier_name"
FROM portfolio."stock_lot" t0
JOIN portfolio."product" t1 ON t0."product_id" = t1."product_id"
JOIN portfolio."supplier" t2 ON t0."supplier_id" = t2."supplier_id"
ORDER BY t0."lot_id", t1."product_id", t2."supplier_id"
LIMIT 20;
```

| stock_lot_lot_id | stock_lot_lot_code | product_product_id | product_sku | supplier_supplier_id | supplier_supplier_name |
| --- | --- | --- | --- | --- | --- |
| 3001 | AMX-26-A | 1001 | RX-1001 | 2001 | Northstar Medical Supply |
| 3002 | LOR-26-B | 1002 | RX-1002 | 2002 | Cedar Valley Pharmaceuticals |

## 2. Find stock_lot records where expiry_date matches "2027-01-15" (up to 20).

```sql
SELECT * FROM portfolio."stock_lot"
WHERE "expiry_date" IS NOT DISTINCT FROM '2027-01-15'
ORDER BY "lot_id"
LIMIT 20;
```

| lot_id | product_id | supplier_id | lot_code | received_date | expiry_date | quantity_on_hand | unit_cost |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | AMX-26-A | 2026-01-15 | 2027-01-15 | 120 | 0.24 |

## 3. Count stock_lot records for each product_id (up to 20 groups).

```sql
SELECT "product_id", count(*) AS record_count
FROM portfolio."stock_lot"
GROUP BY "product_id"
ORDER BY record_count DESC, "product_id" NULLS LAST
LIMIT 20;
```

| product_id | record_count |
| --- | --- |
| 1001 | 1 |
| 1002 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.952 | 1.314, 0.952, 0.846 | Sort → Seq Scan | 112 |
| After index | 0.205 | 0.187, 0.245, 0.205 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.952 ms to 0.205 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.273..1.276 rows=20 loops=1)
  Seq Scan on stock_lot (actual time=0.021..1.226 rows=20 loops=1)
Planning Time: 0.453 ms
Execution Time: 1.314 ms
```

### Before index, run 2

```text
Sort (actual time=0.923..0.925 rows=20 loops=1)
  Seq Scan on stock_lot (actual time=0.024..0.888 rows=20 loops=1)
Planning Time: 0.386 ms
Execution Time: 0.952 ms
```

### Before index, run 3

```text
Sort (actual time=0.818..0.82 rows=20 loops=1)
  Seq Scan on stock_lot (actual time=0.017..0.784 rows=20 loops=1)
Planning Time: 0.363 ms
Execution Time: 0.846 ms
```

### After index, run 1

```text
Sort (actual time=0.13..0.132 rows=20 loops=1)
  Bitmap Heap Scan on stock_lot (actual time=0.028..0.093 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.547 ms
Execution Time: 0.187 ms
```

### After index, run 2

```text
Sort (actual time=0.17..0.172 rows=20 loops=1)
  Bitmap Heap Scan on stock_lot (actual time=0.038..0.118 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.018..0.019 rows=20 loops=1)
Planning Time: 1.801 ms
Execution Time: 0.245 ms
```

### After index, run 3

```text
Sort (actual time=0.138..0.14 rows=20 loops=1)
  Bitmap Heap Scan on stock_lot (actual time=0.03..0.094 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.625 ms
Execution Time: 0.205 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Obi_Ifechukwude_301924392_P2_Queries.sql, then Obi_Ifechukwude_301924392_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Obi_Ifechukwude_301924392_P2_QueryResults.png) · [Index comparison](screenshots/Obi_Ifechukwude_301924392_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

