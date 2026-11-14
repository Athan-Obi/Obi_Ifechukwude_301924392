# Pharmacy / Drug Inventory System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| product_id | stock_lot records (list) |
| --- | --- |
| 1001 | [3001] |
| 1002 | [3002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| stock_lot.lot_id | stock_lot.product_id | stock_lot.supplier_id | stock_lot.lot_code | product.product_id | product.sku | supplier.supplier_id | supplier.supplier_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | AMX-26-A | 1001 | RX-1001 | 2001 | Northstar Medical Supply |
| 3002 | 1002 | 2002 | LOR-26-B | 1002 | RX-1002 | 2002 | Cedar Valley Pharmaceuticals |

Key: lot_id.

## 2NF: depend on the whole key

stock_lot: product_id is a proper part of candidate key (product_id, lot_code), and determines product details.

## product_example

| product.product_id | product.sku |
| --- | --- |
| 1001 | RX-1001 |
| 1002 | RX-1002 |

## stock_lot_example

| stock_lot.lot_id | stock_lot.product_id | stock_lot.supplier_id | stock_lot.lot_code | supplier.supplier_id | supplier.supplier_name |
| --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | AMX-26-A | 2001 | Northstar Medical Supply |
| 3002 | 1002 | 2002 | LOR-26-B | 2002 | Cedar Valley Pharmaceuticals |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## product

| product_id | sku | generic_name | dosage_form | strength | active |
| --- | --- | --- | --- | --- | --- |
| 1001 | RX-1001 | amoxicillin | capsule | 500 mg | true |
| 1002 | RX-1002 | loratadine | tablet | 10 mg | true |

## supplier

| supplier_id | supplier_name | contact_email | active |
| --- | --- | --- | --- |
| 2001 | Northstar Medical Supply | orders@northstar.example | true |
| 2002 | Cedar Valley Pharmaceuticals | NULL | true |

## stock_lot

| lot_id | product_id | supplier_id | lot_code | received_date | expiry_date | quantity_on_hand | unit_cost |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | AMX-26-A | 2026-01-15 | 2027-01-15 | 120 | 0.24 |
| 3002 | 1002 | 2002 | LOR-26-B | 2026-02-10 | 2027-02-10 | 85 | 0.11 |

## Dependencies

- product: (product_id) → sku, generic_name, dosage_form, strength, active
- supplier: (supplier_id) → supplier_name, contact_email, active
- stock_lot: (lot_id) → product_id, supplier_id, lot_code, received_date, expiry_date, quantity_on_hand, unit_cost

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
