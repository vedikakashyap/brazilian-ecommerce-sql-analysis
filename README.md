# Brazilian E-Commerce SQL Analysis

## 🎯 Project Overview

Deep-dive SQL analysis of 100K+ e-commerce transactions from a Brazilian marketplace (2016-2018) to uncover customer behavior patterns, revenue drivers, and retention opportunities. This project demonstrates advanced SQL techniques including CTEs, window functions, cohort analysis, and customer segmentation.

**Built to answer:** "How would a data analyst turn raw transactional data into actionable business insights?"

---

## 📊 Dataset Overview

**Source:** [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)  
**Time Period:** September 2016 - October 2018 (25 months / 773 days)  
**Scale:** 96,478 delivered orders from 96,096 unique customers

### Key Metrics at a Glance
| Metric | Value |
|--------|-------|
| **Total Revenue** | 15.42M BRL (~$3.9M USD) |
| **Average Order Value** | 159.83 BRL (~$40 USD) |
| **Unique Products** | 32,951 items across 71 categories |
| **Marketplace Sellers** | 3,095 vendors |
| **Customer Repeat Rate** | 3.00% (⚠️ Major retention issue) |
| **Items per Order** | 1.17 average |

### Geographic Distribution
- **São Paulo (SP):** 41.94% of customers
- **Rio de Janeiro (RJ):** 12.89%
- **Minas Gerais (MG):** 11.72%
- **Top 5 States:** 77% of total customer base

### Business Context
Olist is a Brazilian SaaS company that operates as an e-commerce marketplace, connecting small/medium businesses to major Brazilian marketplaces and handling logistics, payments, and customer service.

**Key Characteristics of Brazilian E-Commerce:**
- Installment payments standard (even for small purchases)
- Boleto payment method (bank slip) very popular
- Long delivery times due to country size (7-30 days typical)
- Heavy geographic concentration in Southeast region

---

## 🎯 Business Questions Analyzed

This project answers 7 critical business questions using SQL:

### 1. Customer Lifetime Value Analysis
**Question:** What is the CLV distribution across different customer segments?  
**Why it matters:** Identifies high-value customers for retention efforts  
**Techniques:** Window functions, percentile calculations, cohort grouping

### 2. Monthly Cohort Retention Analysis
**Question:** How do customer cohorts retain over time?  
**Why it matters:** Reveals retention patterns and identifies at-risk cohorts  
**Techniques:** Self-joins, date manipulation, cohort matrix construction

### 3. Product Affinity Analysis
**Question:** Which products are frequently purchased together?  
**Why it matters:** Enables cross-sell recommendations and bundle strategies  
**Techniques:** Self-joins, basket analysis, statistical significance filtering

### 4. RFM Customer Segmentation
**Question:** How can we segment customers by Recency, Frequency, Monetary value?  
**Why it matters:** Enables targeted marketing and personalized experiences  
**Techniques:** NTILE, CASE statements, multi-dimensional scoring

### 5. Seasonal Trends & Revenue Forecasting
**Question:** What are the seasonal patterns in sales and revenue?  
**Why it matters:** Informs inventory planning and marketing timing  
**Techniques:** Window functions, rolling averages, YoY growth calculations

### 6. Delivery Performance Analysis
**Question:** How does delivery performance impact customer satisfaction?  
**Why it matters:** Late deliveries drive negative reviews and churn  
**Techniques:** Date calculations, joins with reviews, SLA tracking

### 7. Payment Method & Installment Analysis
**Question:** How do payment preferences vary by category and customer segment?  
**Why it matters:** Optimize payment options to reduce friction  
**Techniques:** Aggregations, payment splits, category breakdowns

---

## 🛠️ Tech Stack

- **Database:** MySQL 8.0
- **Data Source:** Kaggle (Olist Brazilian E-Commerce)
- **Visualization:** Tableau Public / Power BI *(coming soon)*
- **Documentation:** Markdown, GitHub

### SQL Techniques Demonstrated
- ✅ Complex JOINs (4-5 table joins)
- ✅ Common Table Expressions (CTEs)
- ✅ Window Functions (ROW_NUMBER, RANK, NTILE, LAG, LEAD)
- ✅ Subqueries (correlated and uncorrelated)
- ✅ Aggregate Functions with HAVING clauses
- ✅ Date/Time manipulation
- ✅ CASE statements for conditional logic
- ✅ Self-joins for sequential analysis

---

## 📁 Project Structure
```
brazilian-ecommerce-sql-analysis/
├── README.md                          # Project overview (this file)
├── data/                              # Raw CSV files (not committed)
│   ├── olist_customers_dataset.csv
│   ├── olist_orders_dataset.csv
│   └── ...
├── sql/
│   ├── schema.sql                     # Database creation & table definitions
│   ├── data_load.sql                  # Data import scripts
│   ├── data_validation.sql            # Quality checks & exploration
│   └── queries/
│       ├── 01_customer_lifetime_value.sql
│       ├── 02_cohort_retention.sql
│       ├── 03_product_affinity.sql
│       ├── 04_rfm_segmentation.sql
│       ├── 05_seasonal_trends.sql
│       ├── 06_delivery_performance.sql
│       └── 07_payment_analysis.sql
├── docs/
│   ├── data_dictionary.md             # Complete data documentation
│   └── insights_summary.md            # Key findings & recommendations
└── visualizations/                    # Charts & dashboards (coming soon)
```

---

## 🚀 Current Progress

- [x] **Phase 1: Setup & Validation**
  - [x] Database schema design with proper indexes
  - [x] Data loading and validation (99,441 orders loaded)
  - [x] Data quality assessment
  - [x] Comprehensive data dictionary
  
- [ ] **Phase 2: Core Analysis** *(in progress)*
  - [ ] Query 1: Customer Lifetime Value
  - [ ] Query 2: Cohort Retention
  - [ ] Query 3: Product Affinity
  - [ ] Query 4: RFM Segmentation
  - [ ] Query 5: Seasonal Trends
  - [ ] Query 6: Delivery Performance
  - [ ] Query 7: Payment Analysis
  
- [ ] **Phase 3: Insights & Documentation**
  - [ ] Document findings in insights_summary.md
  - [ ] Create Tableau dashboards
  - [ ] Write Medium article
  
- [ ] **Phase 4: Portfolio Polish**
  - [ ] Add SQL query explanations
  - [ ] Create demo video
  - [ ] Prepare interview talking points

---

## 🔍 Key Findings (Preliminary)

### Critical Business Issues Identified

**1. Severe Customer Retention Problem**
- Only **3.00% of customers make a repeat purchase**
- Industry benchmark for e-commerce: 25-30%
- **Impact:** Unsustainable customer acquisition costs

**2. Low Basket Size**
- Average **1.17 items per order**
- Indicates minimal cross-selling happening
- **Opportunity:** Product bundling and recommendations

**3. Geographic Concentration Risk**
- **77% of customers** from just 5 states
- Over-reliance on São Paulo metro area (42%)
- **Risk:** Regional economic downturns impact revenue

**4. Revenue Concentration**
- Top 10 product categories drive 65%+ of revenue
- Bed/bath/table, health/beauty, sports/leisure dominate
- **Opportunity:** Category expansion strategies

*(Full insights coming after query completion)*

---

## 📈 How to Use This Repository

### Prerequisites
- MySQL 8.0+ installed
- Basic SQL knowledge
- (Optional) Tableau Public or Power BI for visualizations

### Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/vedikakashyap/brazilian-ecommerce-sql-analysis.git
cd brazilian-ecommerce-sql-analysis
```

2. **Download the dataset**
- Go to [Kaggle dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Download all CSV files
- Place in `data/` folder

3. **Create database and load data**
```bash
mysql -u root -p < sql/schema.sql
mysql -u root -p ecommerce_analysis < sql/data_load.sql
```

4. **Validate data loaded correctly**
```bash
mysql -u root -p ecommerce_analysis < sql/data_validation.sql
```

5. **Run analysis queries**
```bash
mysql -u root -p ecommerce_analysis < sql/queries/01_customer_lifetime_value.sql
# Repeat for other queries...
```

### Exploring the Analysis
- All queries are heavily commented with business context
- Each query file includes:
  - Business question being answered
  - Approach and methodology
  - Query execution
  - Results interpretation
  - Actionable recommendations

---

## 📚 Documentation

- **[Data Dictionary](docs/data_dictionary.md):** Complete schema documentation with business context
- **[Insights Summary](docs/insights_summary.md):** Key findings and recommendations *(coming soon)*

---

## 🎓 Learning Outcomes

Through this project, I demonstrated:

**SQL Skills:**
- Writing production-quality queries with proper indexing
- Complex multi-table JOINs and subqueries
- Window functions for advanced analytics
- CTEs for query readability and performance

**Business Analysis:**
- Translating ambiguous business questions into SQL
- Interpreting data to generate actionable insights
- Identifying data quality issues and handling them appropriately
- Communicating technical findings to non-technical stakeholders

**Data Engineering:**
- Designing normalized database schemas
- Implementing proper foreign keys and indexes
- Data validation and quality assurance
- Documentation best practices

---

## 🔗 Connect With Me

- **GitHub:** [@vedikakashyap](https://github.com/vedikakashyap)
- **LinkedIn:** [https://www.linkedin.com/in/vedika-kashyap-467b86244]
- **Email:** [vedikakashyap33@gmail.com]

---

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

Dataset provided by Olist under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) license.

---

## 🙏 Acknowledgments

- **Olist** for providing the anonymized dataset
- **Kaggle** for hosting the data
- Brazilian e-commerce community for context and insights

---

**Status:** 🚧 Active Development | Last Updated: February 9, 2026
