// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("inventory_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("inventory_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "lot_received",
                    "quantity_dispensed"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "stock_lot"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "lot_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("inventory_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "lot_received",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "stock_lot",
            "key": {
                "lot_id": 3001
            },
            "snapshot": {
                "lot_id": 3001,
                "product_id": 1001,
                "supplier_id": 2001,
                "lot_code": "AMX-26-A",
                "received_date": "2026-01-15",
                "expiry_date": "2027-01-15",
                "quantity_on_hand": 120,
                "unit_cost": 0.24
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 1001
                    },
                    "snapshot": {
                        "product_id": 1001,
                        "sku": "RX-1001",
                        "generic_name": "amoxicillin",
                        "dosage_form": "capsule",
                        "strength": "500 mg",
                        "active": true
                    },
                    "via": [
                        "stock_lot.product_id → product"
                    ]
                }
            ],
            "supplier": [
                {
                    "key": {
                        "supplier_id": 2001
                    },
                    "snapshot": {
                        "supplier_id": 2001,
                        "supplier_name": "Northstar Medical Supply",
                        "contact_email": "orders@northstar.example",
                        "active": true
                    },
                    "via": [
                        "stock_lot.supplier_id → supplier"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "quantity_dispensed",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "stock_lot",
            "key": {
                "lot_id": 3001
            },
            "snapshot": {
                "lot_id": 3001,
                "product_id": 1001,
                "supplier_id": 2001,
                "lot_code": "AMX-26-A",
                "received_date": "2026-01-15",
                "expiry_date": "2027-01-15",
                "quantity_on_hand": 120,
                "unit_cost": 0.24
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 1001
                    },
                    "snapshot": {
                        "product_id": 1001,
                        "sku": "RX-1001",
                        "generic_name": "amoxicillin",
                        "dosage_form": "capsule",
                        "strength": "500 mg",
                        "active": true
                    },
                    "via": [
                        "stock_lot.product_id → product"
                    ]
                }
            ],
            "supplier": [
                {
                    "key": {
                        "supplier_id": 2001
                    },
                    "snapshot": {
                        "supplier_id": 2001,
                        "supplier_name": "Northstar Medical Supply",
                        "contact_email": "orders@northstar.example",
                        "active": true
                    },
                    "via": [
                        "stock_lot.supplier_id → supplier"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "reason": "illustrative reason",
                "adjustment_reference": "illustrative adjustment_reference",
                "measured_temperature_c": "illustrative measured_temperature_c"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "lot_received",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "stock_lot",
            "key": {
                "lot_id": 3002
            },
            "snapshot": {
                "lot_id": 3002,
                "product_id": 1002,
                "supplier_id": 2002,
                "lot_code": "LOR-26-B",
                "received_date": "2026-02-10",
                "expiry_date": "2027-02-10",
                "quantity_on_hand": 85,
                "unit_cost": 0.11
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 1002
                    },
                    "snapshot": {
                        "product_id": 1002,
                        "sku": "RX-1002",
                        "generic_name": "loratadine",
                        "dosage_form": "tablet",
                        "strength": "10 mg",
                        "active": true
                    },
                    "via": [
                        "stock_lot.product_id → product"
                    ]
                }
            ],
            "supplier": [
                {
                    "key": {
                        "supplier_id": 2002
                    },
                    "snapshot": {
                        "supplier_id": 2002,
                        "supplier_name": "Cedar Valley Pharmaceuticals",
                        "contact_email": null,
                        "active": true
                    },
                    "via": [
                        "stock_lot.supplier_id → supplier"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "quantity_dispensed",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "stock_lot",
            "key": {
                "lot_id": 3002
            },
            "snapshot": {
                "lot_id": 3002,
                "product_id": 1002,
                "supplier_id": 2002,
                "lot_code": "LOR-26-B",
                "received_date": "2026-02-10",
                "expiry_date": "2027-02-10",
                "quantity_on_hand": 85,
                "unit_cost": 0.11
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 1002
                    },
                    "snapshot": {
                        "product_id": 1002,
                        "sku": "RX-1002",
                        "generic_name": "loratadine",
                        "dosage_form": "tablet",
                        "strength": "10 mg",
                        "active": true
                    },
                    "via": [
                        "stock_lot.product_id → product"
                    ]
                }
            ],
            "supplier": [
                {
                    "key": {
                        "supplier_id": 2002
                    },
                    "snapshot": {
                        "supplier_id": 2002,
                        "supplier_name": "Cedar Valley Pharmaceuticals",
                        "contact_email": null,
                        "active": true
                    },
                    "via": [
                        "stock_lot.supplier_id → supplier"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "reason": "illustrative reason",
                "adjustment_reference": "illustrative adjustment_reference",
                "measured_temperature_c": "illustrative measured_temperature_c"
            }
        }
    }
]));
  await db.getCollection("inventory_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("inventory_events").find({"eventType":"lot_received"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("inventory_events").find({"source.key.lot_id":3001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("inventory_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("inventory_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("inventory_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "lot_received",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "stock_lot",
        "key": {
            "lot_id": 3001
        },
        "snapshot": {
            "lot_id": 3001,
            "product_id": 1001,
            "supplier_id": 2001,
            "lot_code": "AMX-26-A",
            "received_date": "2026-01-15",
            "expiry_date": "2027-01-15",
            "quantity_on_hand": 120,
            "unit_cost": 0.24
        }
    },
    "embedded": {
        "product": [
            {
                "key": {
                    "product_id": 1001
                },
                "snapshot": {
                    "product_id": 1001,
                    "sku": "RX-1001",
                    "generic_name": "amoxicillin",
                    "dosage_form": "capsule",
                    "strength": "500 mg",
                    "active": true
                },
                "via": [
                    "stock_lot.product_id → product"
                ]
            }
        ],
        "supplier": [
            {
                "key": {
                    "supplier_id": 2001
                },
                "snapshot": {
                    "supplier_id": 2001,
                    "supplier_name": "Northstar Medical Supply",
                    "contact_email": "orders@northstar.example",
                    "active": true
                },
                "via": [
                    "stock_lot.supplier_id → supplier"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("inventory_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "lot_received",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "stock_lot",
        "key": {
            "lot_id": 3001
        },
        "snapshot": {
            "lot_id": 3001,
            "product_id": 1001,
            "supplier_id": 2001,
            "lot_code": "AMX-26-A",
            "received_date": "2026-01-15",
            "expiry_date": "2027-01-15",
            "quantity_on_hand": 120,
            "unit_cost": 0.24
        }
    },
    "embedded": {
        "product": [
            {
                "key": {
                    "product_id": 1001
                },
                "snapshot": {
                    "product_id": 1001,
                    "sku": "RX-1001",
                    "generic_name": "amoxicillin",
                    "dosage_form": "capsule",
                    "strength": "500 mg",
                    "active": true
                },
                "via": [
                    "stock_lot.product_id → product"
                ]
            }
        ],
        "supplier": [
            {
                "key": {
                    "supplier_id": 2001
                },
                "snapshot": {
                    "supplier_id": 2001,
                    "supplier_name": "Northstar Medical Supply",
                    "contact_email": "orders@northstar.example",
                    "active": true
                },
                "via": [
                    "stock_lot.supplier_id → supplier"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("inventory_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
