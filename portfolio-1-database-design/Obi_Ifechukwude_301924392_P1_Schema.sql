-- Pharmacy / Drug Inventory System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."product" (
  "product_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "generic_name" text NOT NULL,
  "dosage_form" text NOT NULL,
  "strength" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_product" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_product_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."supplier" (
  "supplier_id" bigint NOT NULL,
  "supplier_name" text NOT NULL,
  "contact_email" text,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_supplier" PRIMARY KEY ("supplier_id")
);
CREATE TABLE portfolio."stock_lot" (
  "lot_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "supplier_id" bigint NOT NULL,
  "lot_code" text NOT NULL,
  "received_date" date NOT NULL,
  "expiry_date" date NOT NULL,
  "quantity_on_hand" bigint NOT NULL,
  "unit_cost" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_stock_lot" PRIMARY KEY ("lot_id"),
  CONSTRAINT "uq_stock_lot_0" UNIQUE ("product_id", "lot_code")
);
ALTER TABLE portfolio."stock_lot" ADD CONSTRAINT "fk_stock_lot_0" FOREIGN KEY ("product_id") REFERENCES portfolio."product" ("product_id");
ALTER TABLE portfolio."stock_lot" ADD CONSTRAINT "fk_stock_lot_1" FOREIGN KEY ("supplier_id") REFERENCES portfolio."supplier" ("supplier_id");
ALTER TABLE portfolio."stock_lot" ADD CONSTRAINT "nonnegative_quantity" CHECK ("quantity_on_hand" >= 0);
ALTER TABLE portfolio."stock_lot" ADD CONSTRAINT "valid_lot_dates" CHECK ("expiry_date" > "received_date");
ALTER TABLE portfolio."stock_lot" ADD CONSTRAINT "nonnegative_unit_cost" CHECK ("unit_cost" >= 0);
COMMIT;
