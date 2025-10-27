# Customer-LTV-Analysis
# Customer Lifetime Value (CLV) Prediction Project

## 📘 Overview
This project demonstrates how to predict **Customer Lifetime Value (CLV)** using SQL and Python. The analysis provides insights into customer behavior, spending patterns, and long-term value, enabling data-driven decision-making for marketing and customer retention strategies.

## 🧩 Objectives
- Clean and prepare the online retail dataset.
- Perform **RFM (Recency, Frequency, Monetary)** analysis.
- Build predictive models using Python to estimate CLV.
- Visualize insights and generate actionable recommendations.

## 🗃️ Dataset
- **Source:** Online Retail dataset (UCI Repository)
- **File:** `Online Retail CLV.csv`
- **Attributes:** Invoice_No, Stock_Code, Description, Quantity, Invoice_Date, Unit_Price, Customer_ID, Country

## 🧮 SQL Analysis
The SQL workflow (`Online Retail CLV.sql`) performs:
- Database creation and data loading.
- Profit computation (`Quantity * Unit_Price`).
- Revenue analysis by product and country.
- Customer segmentation using RFM metrics.
- Creation of a **view** (`customer_ltv_features`) for model input.

```sql
CREATE OR REPLACE VIEW customer_ltv_features AS
SELECT
    Customer_ID,
    DATEDIFF((SELECT MAX(Invoice_Date) FROM online_retail), MAX(Invoice_Date)) AS RecencyDays,
    COUNT(DISTINCT Invoice_No) AS Frequency,
    ROUND(SUM(Profit)/COUNT(DISTINCT Invoice_No), 2) AS AOV,
    ROUND(SUM(Profit), 2) AS TotalSpend
FROM online_retail
WHERE Customer_ID IS NOT NULL
GROUP BY Customer_ID;
```

## 🧠 Python Modeling
The Jupyter Notebook (`Customer_LTV_Analysis.ipynb`) performs:
- Data import and preprocessing.
- Feature selection: RecencyDays, Frequency, AOV, TotalSpend.
- Model building using **Linear Regression**.
- Performance evaluation with **R² Score** and **MSE**.
- Visualization of actual vs predicted LTV.

```python
from sklearn.linear_model import LinearRegression
model = LinearRegression()
model.fit(X_train, y_train)
```

**Result:** R² ≈ 0.85 → Strong predictive accuracy.

## 📊 Insights
| Metric | Meaning | Business Use |
|:--------|:---------|:-------------|
| Recency | Days since last purchase | Identify inactive customers |
| Frequency | Number of purchases | Measure loyalty |
| AOV | Average Order Value | Segment premium buyers |
| TotalSpend | Cumulative spend | Rank customers |
| Predicted_LTV | Expected lifetime value | Prioritize marketing efforts |

**Key Takeaways:**
- Top 20% of customers drive ~80% of total revenue.
- Frequent buyers show higher LTV potential.

## 🧾 Files Included
| File | Description |
|:------|:-------------|
| `Online Retail CLV.csv` | Raw dataset |
| `Online Retail CLV.sql` | SQL transformations and analysis |
| `Customer_LTV_Analysis.ipynb` | Python modeling and visualization |
| `final_ltv_predictions.csv` | Predicted LTV output |
| `Customer_LTV_Report.pdf` | Final report summary |

## 🧰 Tools & Technologies
- **Database:** MySQL
- **Programming:** Python (Pandas, NumPy, Scikit-learn)
- **Visualization:** Matplotlib, Seaborn, Power BI
- **Model:** Linear Regression

## 🚀 How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/customer-ltv-prediction.git
   cd customer-ltv-prediction
   ```
2. Import the dataset into MySQL and run the SQL script.
3. Open `Customer_LTV_Analysis.ipynb` in Jupyter Notebook or Colab.
4. Run all cells to generate the predictions.

## 📈 Future Enhancements
- Use advanced ML models (XGBoost, Random Forest).
- Implement automated segmentation dashboards.
- Integrate Power BI or Streamlit app for visualization.

## Author
Kadimella Sahana
