# Portfolio 1 — Database Design and Modelling

I organised the data into product, supplier, stock_lot. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| product | 2 |
| supplier | 2 |
| stock_lot | 2 |

The 27 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Obi_Ifechukwude_301924392_P1_Design.md)
- [ER diagram](Obi_Ifechukwude_301924392_P1_ERDiagram.md)
- [Normalisation](Obi_Ifechukwude_301924392_P1_Normalisation.md)
- [Schema](Obi_Ifechukwude_301924392_P1_Schema.sql)
- [Sample data](Obi_Ifechukwude_301924392_P1_SampleData.sql)
- [Constraint tests](Obi_Ifechukwude_301924392_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Obi_Ifechukwude_301924392_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

