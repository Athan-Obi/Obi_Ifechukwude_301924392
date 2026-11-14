# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection inventory_events for lot_received and quantity_dispensed events. These are fictional event examples based on stock_lot, product, supplier.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related product, supplier details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
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
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("inventory_events").find({"eventType":"lot_received"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "lot_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "lot_id": 3001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "lot_received",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "lot_id": 3002
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("inventory_events").find({"source.key.lot_id":3001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "lot_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "lot_id": 3001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "quantity_dispensed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "lot_id": 3001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("inventory_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "lot_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "lot_id": 3001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "quantity_dispensed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "lot_id": 3001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "lot_received",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "lot_id": 3002
    }
  },
  {
    "_id": "event_000004",
    "eventType": "quantity_dispensed",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "lot_id": 3002
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("inventory_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| lot_received | 2 |
| quantity_dispensed | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Obi_Ifechukwude_301924392_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Obi_Ifechukwude_301924392_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

