# Data Dictionary - Brazilian E-commerce Dataset

## Overview
This dataset contains information about 100k orders from 2016 to 2018 made at Olist Store, a Brazilian e-commerce marketplace connecting small businesses to customers across Brazil.

**Last Updated:** February 8, 2025  
**Data Period:** September 2016 - October 2018 (25 months)

---

## Tables Overview

| Table | Rows | Description |
|-------|------|-------------|
| customers | 99,441 | Customer demographic and location data |
| orders | 99,441 | Order lifecycle with timestamps |
| order_items | 112,650 | Line-item details (products purchased) |
| products | 32,951 | Product catalog |
| sellers | 3,095 | Seller information |
| order_payments | 103,886 | Payment details and installments |
| order_reviews | [YOUR_COUNT] | Customer reviews and ratings |
| product_category_translation | 71 | Portuguese to English category names |

---

## Table Schemas

### customers
Customer information and geographic data.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `customer_id` | VARCHAR(255) | **PK** - Unique identifier for each order | ⚠️ Same person can have multiple customer_ids |
| `customer_unique_id` | VARCHAR(255) | Unique identifier for each person | **Use this for customer-level analysis** |
| `customer_zip_code_prefix` | VARCHAR(10) | First 5 digits of zip code | For geographic segmentation |
| `customer_city` | VARCHAR(255) | Customer city name | 4,119 unique cities |
| `customer_state` | VARCHAR(2) | Two-letter state code | 27 states total |

**Key Insights:**
- 96,096 unique customers (`customer_unique_id`)
- 99,441 `customer_id` entries → 3,345 instances of repeat customers getting new IDs
- **SP (São Paulo) = 41.94%** of customer base
- Top 5 states represent **77%** of customers

**Analysis Notes:**
- Always use `customer_unique_id` for customer-level metrics (CLV, retention, segments)
- Use `customer_id` only for joining to orders table
- Geographic concentration = business risk (over-reliance on SP market)

---

### orders
Order lifecycle information with timestamps for each stage.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `order_id` | VARCHAR(255) | **PK** - Unique order identifier | |
| `customer_id` | VARCHAR(255) | **FK** to customers | |
| `order_status` | VARCHAR(50) | Current order status | See values below |
| `order_purchase_timestamp` | DATETIME | When customer clicked "buy" | **Use for cohort analysis** |
| `order_approved_at` | DATETIME | Payment approval time | NULL for canceled orders |
| `order_delivered_carrier_date` | DATETIME | Handoff to logistics partner | |
| `order_delivered_customer_date` | DATETIME | Actual delivery completion | NULL if not delivered |
| `order_estimated_delivery_date` | DATETIME | Promised delivery date | Compare to actual for SLA analysis |

**Order Status Values:**
- `delivered` (96.5% of orders) - Successfully completed
- `shipped` - In transit
- `canceled` - Customer or seller canceled
- `unavailable` - Product out of stock
- `invoiced` - Payment processed, awaiting shipment
- `processing` - Order being prepared
- `created` - Just placed, not yet approved

**Key Insights:**
- **96,478 delivered orders** out of 99,441 total (97% success rate)
- Date range: **2016-09-04 to 2018-10-17** (773 days)
- ~2,000 orders missing delivery dates (canceled/in-transit when data collected)

**Analysis Notes:**
- Filter `WHERE order_status = 'delivered'` for revenue calculations
- Use `order_purchase_timestamp` as the cohort date (not delivery date)
- Delivery performance = `order_delivered_customer_date` vs `order_estimated_delivery_date`

---

### order_items
Line-item details for each order (products purchased). Multi-item orders have multiple rows.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `order_id` | VARCHAR(255) | **PK (composite)** - FK to orders | |
| `order_item_id` | INT | **PK (composite)** - Sequential item number | 1, 2, 3... for multi-item orders |
| `product_id` | VARCHAR(255) | **FK** to products | |
| `seller_id` | VARCHAR(255) | **FK** to sellers | Same order can have items from different sellers |
| `shipping_limit_date` | DATETIME | Seller's deadline to ship | Per-item, not per-order |
| `price` | DECIMAL(10,2) | Item price in BRL | **Excludes freight** |
| `freight_value` | DECIMAL(10,2) | Shipping cost in BRL | Per-item, can be 0 for free shipping |

**Key Insights:**
- **112,650 line items** across 96,478 delivered orders
- **Average 1.17 items per order** (very low basket size)
- **Total revenue: 15.42M BRL** (price + freight)
- **Average item value: 136.88 BRL** (~$34 USD)

**Analysis Notes:**
- Revenue = `SUM(price + freight_value)`
- For AOV (Average Order Value): Group by order_id first, then average
- Low items/order suggests opportunity for cross-sell/upsell strategies
- Multi-seller orders common (marketplace model)

---

### products
Product catalog with category and physical dimensions.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `product_id` | VARCHAR(255) | **PK** - Unique product identifier | |
| `product_category_name` | VARCHAR(255) | **FK** to translation table | In Portuguese |
| `product_name_length` | INT | Character count of product name | Proxy for detail level |
| `product_description_length` | INT | Character count of description | |
| `product_photos_qty` | INT | Number of product photos | Quality indicator |
| `product_weight_g` | INT | Weight in grams | For shipping cost calculation |
| `product_length_cm` | INT | Length in centimeters | |
| `product_height_cm` | INT | Height in centimeters | |
| `product_width_cm` | INT | Width in centimeters | |

**Key Insights:**
- **32,951 unique products** from **71 categories**
- Many NULL values in dimension fields (incomplete catalog data)
- Product listing quality varies significantly

**Analysis Notes:**
- Join to `product_category_translation` for English category names
- Photo quantity and description length = listing quality indicators
- Dimensions useful for logistics cost analysis
- NULLs are common - handle gracefully in queries

---

### sellers
Seller (vendor) information and location.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `seller_id` | VARCHAR(255) | **PK** - Unique seller identifier | |
| `seller_zip_code_prefix` | VARCHAR(10) | First 5 digits of zip code | |
| `seller_city` | VARCHAR(255) | Seller city name | |
| `seller_state` | VARCHAR(2) | Two-letter state code | |

**Key Insights:**
- **3,095 sellers** on the platform
- Seller concentration in SP, RJ (mirrors customer distribution)
- Marketplace model, not single retailer

**Analysis Notes:**
- Compare seller_state to customer_state for shipping distance analysis
- Some sellers are very active, others have few orders (power law distribution)
- Distance between seller and customer impacts delivery time

---

### order_payments
Payment details including installment plans (common in Brazil).

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `order_id` | VARCHAR(255) | **PK (composite)** - FK to orders | |
| `payment_sequential` | INT | **PK (composite)** - Payment sequence number | Multiple payments per order possible |
| `payment_type` | VARCHAR(50) | Payment method | See values below |
| `payment_installments` | INT | Number of installments | 1-24 typical |
| `payment_value` | DECIMAL(10,2) | Payment amount in BRL | May differ from order total (rounding) |

**Payment Types:**
- `credit_card` (Most common, ~74%)
- `boleto` (Bank slip, pay at bank/lottery shop)
- `voucher` (Gift card/promotional credit)
- `debit_card`

**Key Insights:**
- **103,886 payment records** for 99,441 orders
- Some orders split across multiple payment methods
- **Installments are huge in Brazil:** Many orders paid over 3-12 months
- Average payment: ~148 BRL

**Analysis Notes:**
- Total order value = `SUM(payment_value)` grouped by order_id
- Installments don't affect revenue recognition (full amount counted)
- Payment type affects fraud risk and processing costs
- Boleto has longer processing time (2-3 day delay)

---

### order_reviews
Customer reviews and ratings for orders.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `review_id` | VARCHAR(255) | **PK** - Unique review identifier | |
| `order_id` | VARCHAR(255) | **FK** to orders | |
| `review_score` | INT | 1-5 star rating | 5 = best |
| `review_comment_title` | VARCHAR(255) | Review title/summary | Many NULLs |
| `review_comment_message` | TEXT | Full review text | Many NULLs (customers often skip) |
| `review_creation_date` | DATETIME | When review was written | |
| `review_answer_timestamp` | DATETIME | When seller/platform responded | Many NULLs |

**Key Insights:**
- **[YOUR_COUNT] reviews** (run: `SELECT COUNT(*) FROM order_reviews;`)
- Not all orders have reviews (~97% review rate)
- Average score: ~4.1/5 (generally positive)
- Most customers don't write text comments (just star ratings)

**Analysis Notes:**
- Review score correlates with repeat purchase probability
- Low scores (<3) indicate delivery or product issues
- Review date can be weeks after delivery
- Use for customer satisfaction analysis

---

### product_category_translation
Maps Portuguese category names to English.

| Column | Type | Description | Business Notes |
|--------|------|-------------|----------------|
| `product_category_name` | VARCHAR(255) | **PK** - Portuguese category name | |
| `product_category_name_english` | VARCHAR(255) | English translation | For readability |

**Key Insights:**
- **71 product categories** total
- Categories range from "health_beauty" to "furniture_decor"
- Some categories poorly translated (manual cleanup needed)

**Analysis Notes:**
- Always join products → translation for readable output
- Top categories by revenue: bed_bath_table, health_beauty, sports_leisure

---

## Relationships (ERD)
```
customers (1) ──→ (N) orders
orders (1) ──→ (N) order_items
orders (1) ──→ (N) order_payments
orders (1) ──→ (1) order_reviews

order_items (N) ──→ (1) products
order_items (N) ──→ (1) sellers

products (N) ──→ (1) product_category_translation
```

---

## Common Query Patterns

### Revenue Calculation
```sql
SELECT SUM(price + freight_value) as revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';
```

### Customer-Level Analysis
```sql
SELECT 
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(oi.price + oi.freight_value) as lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;
```

### Product Category Performance
```sql
SELECT 
    pct.product_category_name_english,
    COUNT(DISTINCT oi.order_id) as orders,
    SUM(oi.price) as revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation pct 
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY revenue DESC;
```

---

## Data Quality Issues

1. **Customer ID Duplication:** Same person gets new customer_id on repeat purchase (~3% of cases)
   - **Solution:** Always use `customer_unique_id` for customer analysis

2. **Missing Values:**
   - Product dimensions: ~10% NULL
   - Review comments: ~60% NULL (customers skip text)
   - Delivery dates: ~3% NULL (canceled/in-transit)

3. **Portuguese Text:** Product categories, some review comments
   - **Solution:** Use translation table for categories

4. **Payment Value Discrepancies:** Sum of payments may differ slightly from order total
   - **Cause:** Rounding in installment calculations
   - **Impact:** Minimal (<0.1% difference)

---

## Business Context

**About Olist:**
- Brazilian e-commerce marketplace (like Etsy or Amazon Marketplace)
- Connects small/medium businesses to customers nationwide
- Handles logistics, payments, customer service for sellers

**Brazilian E-commerce Characteristics:**
- **Installment payments are standard:** Even small purchases split into 3-12x payments
- **Boleto payment:** Very popular, pay at bank/lottery shop (unbanked population)
- **Long delivery times:** Brazil is huge, logistics challenging (7-30 day delivery common)
- **Geographic concentration:** Southeast (SP, RJ, MG) dominates e-commerce

---

## Analysis Priorities

Based on data exploration, focus areas:

1. **Customer Retention:** Only 3% repeat rate (crisis-level)
2. **Basket Size:** 1.17 items/order (upsell opportunity)
3. **Geographic Expansion:** 77% from 5 states (untapped markets)
4. **Delivery Performance:** Late deliveries impact reviews
5. **Payment Optimization:** Installment preferences vary by category

---
