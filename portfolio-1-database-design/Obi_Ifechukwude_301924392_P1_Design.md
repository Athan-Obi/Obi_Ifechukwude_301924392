# Pharmacy / Drug Inventory System — database design

My case study records product, supplier, stock_lot.

## Users

- Pharmacy inventory staff
- Procurement staff
- Database students

## Main operations

- Record a received lot with its product, supplier, dates, quantity, and unit cost.
- Find in-stock lots approaching expiry and identify their products.
- Summarize in-stock quantity by product across lots.
- For a worked normalization example, begin with a flat lot-receipt record containing repeated product details. Use product as the sole repeated ancestor in this example; decompose product details into product and keep product_id as a foreign key in stock_lot. Explain the progression through first, second, and third normal forms.

## Entities

| Entity | Information stored |
| --- | --- |
| product | A medication and its identifying attributes. |
| supplier | A supplier that provides stock lots. |
| stock_lot | A received quantity of one product from one supplier, tracked by lot and expiry date. |

## product

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| generic_name | TEXT |  | Yes |
| dosage_form | TEXT |  | Yes |
| strength | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## supplier

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| supplier_id | BIGINT | PK | Yes |
| supplier_name | TEXT |  | Yes |
| contact_email | TEXT |  | No |
| active | BOOLEAN |  | Yes |


## stock_lot

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| lot_id | BIGINT | PK | Yes |
| product_id | BIGINT | FK | Yes |
| supplier_id | BIGINT | FK | Yes |
| lot_code | TEXT |  | Yes |
| received_date | DATE |  | Yes |
| expiry_date | DATE |  | Yes |
| quantity_on_hand | INTEGER |  | Yes |
| unit_cost | NUMERIC(18,2) |  | Yes |
- product_id → product.product_id
- supplier_id → supplier.supplier_id
- Unique key: (product_id, lot_code).

## Relationships and business rules

- Each product has a distinct SKU.
- Every stock lot references an existing product through product_id.
- Every stock lot references an existing supplier through supplier_id.
- A product cannot have duplicate lot codes.
- Quantity on hand cannot be negative.
- A lot's expiry date must be later than its received date.
- Unit cost cannot be negative.

## Assumptions

- Each product represents one medication, dosage form, and strength; quantities are counted in a consistent unit for that product.
- Each stock lot belongs to exactly one product and one supplier.
- Product, supplier, and lot identifiers are single-column primary keys minted from one globally unique identifier namespace.
- Required fields are non-null; optional supplier contact_email may be absent.
- All records, names, identifiers, and benchmark rows used in exercises are synthetic.

