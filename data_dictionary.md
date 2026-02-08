# Data Dictionary - Brazilian E-commerce Dataset

## Overview
This dataset contains information about 100k orders from 2016 to 2018 made at Olist Store (Brazilian e-commerce platform).

---

## Tables

### customers
Customer information and geographic data.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| customer_id | VARCHAR(255) | Unique identifier for each order | Different from customer_unique_id - same person can have multiple customer_ids |
| customer_unique_id | VARCHAR(255) | Unique identifier for each person | Use this for customer-level analysis |
| customer_zip_code_prefix | VARCHAR(10) | First 5 digits of zip code | |
| customer_city | VARCHAR(255) | Customer city | |
| customer_state | VARCHAR(2) | Customer state code | SP (São Paulo) has ~40% of customers |

**Key Insights:**
- 96,096 unique customers (customer_unique_id)
- 99,441 customer_id entries (some repeat customers)
- Geographic concentration in SP, RJ, MG states

---

### orders
Order lifecycle information with timestamps for each stage.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| order_id | VARCHAR(255) | Unique order identifier | Primary key |
| customer_id | VARCHAR(255) | FK to customers | |
| order_status | VARCHAR(50) | Order status | Values: delivered, shipped, canceled, unavailable, etc. |
| order_purchase_timestamp | DATETIME | Purchase date/time | **Use this for cohort analysis** |
| order_approved_at | DATETIME | Payment approval timestamp | Can be NULL for canceled orders |
| order_delivered_carrier_date | DATETIME | Handoff to logistics | |
| order_delivered_customer_date | DATETIME | Actual delivery | Can be NULL (in transit/canceled) |
| order_estimated_delivery_date | DATETIME | Estimated delivery | Compare to actual for delivery performance |

**Key Insights:**
- 96.5% of orders are "delivered" status
- Date range: 2016-09-04 to 2018-10-17
- ~2,000 orders missing delivery dates (canceled/in transit)

---

### order_items
Line-item details for each order (products purchased).

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| order_id | VARCHAR(255) | FK to orders | |
| order_item_id | INT | Sequential item number within order | 1, 2, 3... for multi-item orders |
| product_id | VARCHAR(255) | FK to products | |
| seller_id | VARCHAR(255) | FK to sellers | One order can have items from multiple sellers |
| price | DECIMAL(10,2) | Item price (BRL) | **Excludes freight** |
| freight_value | DECIMAL(10,2) | Shipping cost (BRL) | Per item, can be 0 |

**Key Insights:**
- 112,650 total line items across 99,441 orders
- Average 1.13 items per order
- Total revenue: ~13.5M BRL (~$2.7M USD at 2018 rates)

---

[Continue with other tables: products, sellers, order_payments, order_reviews]
