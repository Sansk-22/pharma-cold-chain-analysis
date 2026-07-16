# Pharma Cold Chain Thermal Defect Analysis

An end-to-end analytics case study examining temperature compliance failures, vendor risk, and financial exposure across pharmaceutical cold chain shipments — built to simulate the kind of supply chain quality analysis done in life sciences consulting.

---

## Tools & Technologies
- **Python** (pandas, numpy) — data cleaning, feature engineering, EDA
- **MySQL** — structured querying, window functions, vendor risk ranking
- **Excel** — financial modelling and value-at-risk quantification
- **Power BI** — interactive compliance and risk dashboard

---

## Dataset
**Source:** Simulated pharma cold chain dataset — 515 shipments across 5 vendors, 4 routes, 12 products  
**Key fields:** Temperature readings (avg/min/max), breach hours, batch value (₹ Lakhs), compliance status, vendor, route, season

> Raw dataset not included. The notebook generates/expects `pharma_cold_chain_raw.csv` in the working directory.

---

## Project Structure

```
pharma-cold-chain-analysis/
├── notebooks/
│   └── cold_chain.ipynb          # Data cleaning, EDA, vendor & route analysis
├── sql/
│   └── coldsql.sql               # MySQL table setup and risk queries
├── excel/
│   └── cold_chain_model.xlsx     # Financial value-at-risk model
├── dashboard/
│   └── cold_chain_dashboard.pbix # Power BI compliance dashboard
└── README.md
```

---

## Key Findings

### Overall Compliance
- **~12% non-compliance rate** across 485 valid shipments
- Total financial value at risk: **₹2,566 Lakhs** across all non-compliant batches

### Vendor Risk
- **ColdEx Logistics** — worst performer at **24% failure rate**, highest value at risk
- **ChillChain Pvt Ltd** — most reliable vendor with consistently low breach hours
- Window function analysis revealed ColdEx's failure rate worsening through monsoon months

### Route Risk
- Long-distance and summer routes showed significantly higher breach hours
- Monsoon season correlated with the highest non-compliance spikes across all vendors

### Product Exposure
- High-value biologics and insulin products drove disproportionate financial risk
- Top 3 products accounted for over 60% of total value at risk

---

## Analysis Highlights

**Data Cleaning Challenges Solved:**
- Mixed timestamp formats (6 different formats) — custom parser built
- Vendor name inconsistencies (20+ variants) — standardized via mapping dictionary
- Derived compliance status from breach hours where labels were missing

**Advanced SQL Used:**
- Rolling 3-month average failure rate per vendor (window functions)
- Vendor × Route risk ranking with RANK()
- Seasonal breakdown of compliance by product and vendor

---

## Business Recommendations

1. **Place ColdEx Logistics on probation** — 24% failure rate is 2x the industry threshold; trigger SLA review
2. **Add real-time temperature monitoring on monsoon routes** — seasonal spikes are predictable and preventable
3. **Prioritize biologics shipments with ChillChain** — highest-value products should go to most reliable vendor
4. **Implement breach-hour SLA penalties** — current contracts lack financial accountability for temperature excursions
5. **Pre-position backup cold storage at high-risk destinations** before summer and monsoon onset

---

## How to Run

**Python Notebook:**
```bash
pip install pandas numpy
jupyter notebook notebooks/cold_chain.ipynb
```
Place `pharma_cold_chain_raw.csv` in the same directory before running.

**SQL Queries:**
```sql
-- Run coldsql.sql in MySQL Workbench
-- Import your cleaned CSV into the shipments table first
```

**Power BI Dashboard:**
- Open `dashboard/cold_chain_dashboard.pbix` in Power BI Desktop
- Reconnect data source to your local cleaned CSV

---

## Domain Context
This project was built with awareness of pharmaceutical cold chain regulatory requirements (GDP guidelines, 2°C–8°C storage bands for biologics). The analysis mirrors the kind of vendor performance audits and compliance risk quantification common in life sciences supply chain consulting.

---

## Author
**Sansu** | B.Tech Mechanical Engineering, MANIT Bhopal  
Aspiring Data & Business Analyst | Pharma & Supply Chain Analytics
