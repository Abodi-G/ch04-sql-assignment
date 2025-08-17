Section 1 – Core SQL Concepts

Q1: Customers in Nairobi

Used a simple WHERE location = 'Nairobi' filter to restrict results.

Selected only full_name and location to keep output focused and efficient.

Q2: Customers and Products Purchased

Joined customer_info with products on customer_id (their relationship).

Chose attributes full_name, product_name, and price to highlight purchases.

Q3: Total Sales per Customer

Joined customer_info with sales to match customers with their sales.

Applied SUM(total_sales) with GROUP BY to aggregate per customer, then sorted by highest spend.

Q4: Customers Buying Products Above 10,000

Filtered on p.price > 10000.

Used DISTINCT to avoid duplicate rows since customers may buy multiple expensive products.

Q5: Top 3 Customers by Total Sales

Similar to Q3, but limited results to 3 with ORDER BY ... DESC LIMIT 3.

This ranks customers and quickly identifies top spenders.

Section 2 – Advanced SQL Techniques

Q6: CTE for Above-Average Sales

First CTE calculates SUM(total_sales) per customer.

Second CTE finds the average of those totals.

Final query returns customers exceeding that average.

Q7: Ranking Products by Sales

Used SUM(total_sales) grouped by product to compute totals.

Applied RANK() OVER (ORDER BY SUM(...) DESC) to rank products from highest to lowest sales.

Q8: View for High Value Customers

Created a view storing customers with SUM(total_sales) > 15000.

Encapsulates complex aggregation logic in a reusable, queryable object.

Q9: Stored Procedure by Location

Procedure/function accepts a location as input.

Joins customer + sales, filters by that location, and aggregates spending.

PostgreSQL version returns a table via RETURNS TABLE.

Q10: Recursive Running Total

Anchor query starts with the lowest sales_id.

Recursive step iteratively adds each sale to the cumulative sum.

Produces a running total column alongside transactions.

Section 3 – Query Optimization & Execution Plans

Q11: Optimizing Sales Query

Indexed total_sales column for faster lookups.

Replaced SELECT * with specific columns to reduce I/O.

Q12: Index on Customer Location

Added an index on location in customer_info.

Used EXPLAIN ANALYZE to confirm that queries filtering on location switch from Seq Scan to Index Scan.

Section 4 – Data Modeling

Q13: 3NF Schema Redesign

Removed transitive dependency (customer_id in products).

Made sales the bridging table linking customers and products.

Added quantity for better transactional detail.

Q14: Star Schema for Sales Analysis

Designed fact_sales with measures (quantity, sales).

Built dimension tables (dim_product, dim_customer, dim_location) for descriptive attributes.

Fact table references dimensions with foreign keys.

Q15: Denormalization for Reporting

Chose to pre-join data (customers + products + sales) into one wide table.

Speeds up reporting queries since no joins are required at query time.

Accepts redundancy as a trade-off for performance."# ch04-sql-assignemnt"      # optional README
