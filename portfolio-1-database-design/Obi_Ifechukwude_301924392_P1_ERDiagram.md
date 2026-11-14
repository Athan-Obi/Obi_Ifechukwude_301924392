# Pharmacy / Drug Inventory System — ER diagram

```mermaid
erDiagram
    direction LR
    product {
        bigint product_id PK
        text sku UK
        text generic_name
        text dosage_form
        text strength
        boolean active
    }
    supplier {
        bigint supplier_id PK
        text supplier_name
        text contact_email "Optional"
        boolean active
    }
    stock_lot {
        bigint lot_id PK
        bigint product_id FK
        bigint supplier_id FK
        text lot_code
        date received_date
        date expiry_date
        integer quantity_on_hand
        numeric unit_cost
    }
    product ||--o{ stock_lot : "product_id"
    supplier ||--o{ stock_lot : "supplier_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Obi_Ifechukwude_301924392_ERDiagram.png)
