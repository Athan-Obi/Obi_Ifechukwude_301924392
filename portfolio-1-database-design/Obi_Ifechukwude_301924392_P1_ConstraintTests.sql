-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. product pk duplicate. Expected: pk_product, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (1001, 'RX-TEST-PK', 'test medication', 'tablet', '1 mg', TRUE);

-- 2. product sku duplicate. Expected: uq_product_0, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (4001, 'RX-1001', 'test medication', 'tablet', '1 mg', TRUE);

-- 3. product id null. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (NULL, 'RX-4002', 'test medication', 'tablet', '1 mg', TRUE);

-- 4. product sku null. Expected: sku, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (4003, NULL, 'test medication', 'tablet', '1 mg', TRUE);

-- 5. product generic name null. Expected: generic_name, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (4004, 'RX-4004', NULL, 'tablet', '1 mg', TRUE);

-- 6. product dosage form null. Expected: dosage_form, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (4005, 'RX-4005', 'test medication', NULL, '1 mg', TRUE);

-- 7. product strength null. Expected: strength, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (4006, 'RX-4006', 'test medication', 'tablet', NULL, TRUE);

-- 8. product active null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "generic_name", "dosage_form", "strength", "active")
VALUES (4007, 'RX-4007', 'test medication', 'tablet', '1 mg', NULL);

-- 9. supplier pk duplicate. Expected: pk_supplier, SQLSTATE 23505.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (2001, 'Test Supplier', NULL, TRUE);

-- 10. supplier id null. Expected: supplier_id, SQLSTATE 23502.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (NULL, 'Test Supplier', NULL, TRUE);

-- 11. supplier name null. Expected: supplier_name, SQLSTATE 23502.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (4008, NULL, NULL, TRUE);

-- 12. supplier active null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (4009, 'Test Supplier', NULL, NULL);

-- 13. lot pk duplicate. Expected: pk_stock_lot, SQLSTATE 23505.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (3001, 1002, 2001, 'TEST-PK', '2026-03-01', '2027-03-01', 10, 1.25);

-- 14. lot unique duplicate. Expected: uq_stock_lot_0, SQLSTATE 23505.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4010, 1001, 2001, 'AMX-26-A', '2026-03-01', '2027-03-01', 10, 1.25);

-- 15. lot product fk invalid. Expected: fk_stock_lot_0, SQLSTATE 23503.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4011, 99991, 2001, 'TEST-FK-P', '2026-03-01', '2027-03-01', 10, 1.25);

-- 16. lot supplier fk invalid. Expected: fk_stock_lot_1, SQLSTATE 23503.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4012, 1001, 99992, 'TEST-FK-S', '2026-03-01', '2027-03-01', 10, 1.25);

-- 17. lot id null. Expected: lot_id, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (NULL, 1001, 2001, 'TEST-NN-ID', '2026-03-01', '2027-03-01', 10, 1.25);

-- 18. lot product id null. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4013, NULL, 2001, 'TEST-NN-P', '2026-03-01', '2027-03-01', 10, 1.25);

-- 19. lot supplier id null. Expected: supplier_id, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4014, 1001, NULL, 'TEST-NN-S', '2026-03-01', '2027-03-01', 10, 1.25);

-- 20. lot code null. Expected: lot_code, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4015, 1001, 2001, NULL, '2026-03-01', '2027-03-01', 10, 1.25);

-- 21. lot received date null. Expected: received_date, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4016, 1001, 2001, 'TEST-NN-R', NULL, '2027-03-01', 10, 1.25);

-- 22. lot expiry date null. Expected: expiry_date, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4017, 1001, 2001, 'TEST-NN-E', '2026-03-01', NULL, 10, 1.25);

-- 23. lot quantity null. Expected: quantity_on_hand, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4018, 1001, 2001, 'TEST-NN-Q', '2026-03-01', '2027-03-01', NULL, 1.25);

-- 24. lot unit cost null. Expected: unit_cost, SQLSTATE 23502.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4019, 1001, 2001, 'TEST-NN-C', '2026-03-01', '2027-03-01', 10, NULL);

-- 25. lot quantity negative. Expected: nonnegative_quantity, SQLSTATE 23514.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4020, 1001, 2001, 'TEST-CHK-Q', '2026-03-01', '2027-03-01', -1, 1.25);

-- 26. lot dates invalid. Expected: valid_lot_dates, SQLSTATE 23514.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4021, 1001, 2001, 'TEST-CHK-D', '2027-03-01', '2027-03-01', 10, 1.25);

-- 27. lot unit cost negative. Expected: nonnegative_unit_cost, SQLSTATE 23514.
INSERT INTO portfolio."stock_lot" ("lot_id", "product_id", "supplier_id", "lot_code", "received_date", "expiry_date", "quantity_on_hand", "unit_cost")
VALUES (4022, 1001, 2001, 'TEST-CHK-C', '2026-03-01', '2027-03-01', 10, -0.01);
