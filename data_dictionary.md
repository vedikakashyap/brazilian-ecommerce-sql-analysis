## Orders Table
- `order_id`: Unique order identifier
- `customer_id`: FK to customers
- `order_status`: delivered, shipped, canceled, etc.
- `order_purchase_timestamp`: When customer clicked "buy"
- **Business Note**: Use this as the cohort date, not delivery date
