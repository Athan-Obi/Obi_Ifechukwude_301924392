-- Fictional sample records for Pharmacy / Drug Inventory System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active") VALUES (1001, 'RX-1001', 'amoxicillin', 'capsule', '500 mg', TRUE);
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active") VALUES (1002, 'RX-1002', 'loratadine', 'tablet', '10 mg', TRUE);
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email", "active") VALUES (2001, 'Northstar Medical Supply', 'orders@northstar.example', TRUE);
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email", "active") VALUES (2002, 'Cedar Valley Pharmaceuticals', NULL, TRUE);
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost") VALUES (3001, 1001, 2001, 'AMX-26-A', '2026-01-15', '2027-01-15', 120, 0.24);
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost") VALUES (3002, 1002, 2002, 'LOR-26-B', '2026-02-10', '2027-02-10', 85, 0.11);
COMMIT;
