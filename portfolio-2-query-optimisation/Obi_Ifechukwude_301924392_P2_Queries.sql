-- Show related stock_lot, product, supplier records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find stock_lot records where expiry_date matches "2027-01-15" (up to 20).
SELECT * FROM portfolio."stock_lot"
WHERE "expiry_date" IS NOT DISTINCT FROM '2027-01-15'
ORDER BY "lot_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."stock_lot"
WHERE "expiry_date" IS NOT DISTINCT FROM '2027-01-15'
ORDER BY "lot_id"
LIMIT 20;

-- Count stock_lot records for each product_id (up to 20 groups).
SELECT "product_id", count(*) AS record_count
FROM portfolio."stock_lot"
GROUP BY "product_id"
ORDER BY record_count DESC, "product_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "product_id", count(*) AS record_count
FROM portfolio."stock_lot"
GROUP BY "product_id"
ORDER BY record_count DESC, "product_id" NULLS LAST
LIMIT 20;
