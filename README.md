

# 📈 Sales Data Analysis

## 📌 Project Overview
This project analyzes a sales transactions dataset using **MySQL Workbench**, covering data cleaning, exploratory analysis, and advanced SQL techniques to answer real business questions around revenue, top products, and customer behavior.

**Internship:** Analyst Lab Africa

---

## 🛠️ Tool Used
- MySQL Workbench — Data cleaning, querying & analysis

---

## 🧹 Data Cleaning
- ✅ Created a separate working table (`sales_2`) to preserve the original dataset
- ✅ Converted `ORDERDATE` from text to proper DATE format for accurate time-based analysis
- ✅ Explored distinct values across `STATUS`, `PRODUCTLINE`, and `DEALSIZE` to understand data structure

---

## 🔍 Analysis Performed
- Core filtering — cancelled orders, high-value orders (>$5,000), and large deal sizes
- Aggregations — total revenue by product line and by year
- Customer segmentation — identified customers with total spend over $100,000
- **Window functions** — ranked top-performing products within each product line using `RANK() OVER (PARTITION BY...)`
- **Subqueries** — orders above average sale value
- **Running totals** — cumulative monthly revenue trend for 2004

---

## 💡 Key Findings
- 🏆 Identified the **top-performing products** by revenue and units sold within each product line
- 👤 Ranked **top customers** by total revenue contribution
- 📅 Tracked **monthly and yearly revenue trends**, including a running total for 2004
- 💰 Calculated **average order value per customer** to spot high-value buying patterns
- 🚫 Isolated all **cancelled orders** for further business review

---

*Project completed as part of the Analyst Lab Africa Data Analytics Internship.*
