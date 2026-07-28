# Credit Risk Analysis using Machine Learning

## Probability of Default Prediction using Machine Learning

This project develops an end-to-end **Probability of Default (PD)** prediction model using the **UCI Default of Credit Card Clients** dataset. The objective is to identify customers who are likely to default on their credit card payments by leveraging machine learning techniques and interpretable financial features.

The project covers the complete machine learning workflow, including data validation, SQL-based business analysis, feature engineering, model development, hyperparameter optimization, and model explainability using SHAP.

---

## Project Overview

Financial institutions face significant financial losses due to customer defaults. Early identification of high-risk borrowers enables better lending decisions, improved portfolio management, and more effective credit risk mitigation.

This project builds and compares multiple machine learning models to predict the probability of customer default while maintaining model interpretability for practical decision-making.

---

## Dataset

**Source:** UCI Machine Learning Repository

**Dataset:** Default of Credit Card Clients

- 30,000 customer records
- Demographic information
- Credit limit
- Repayment history
- Bill statements
- Previous payments
- Default payment status (Target Variable)

---

## Project Workflow

```
SQL Data Validation
        │
        ▼
Business Analysis
        │
        ▼
Feature Engineering
        │
        ▼
Exploratory Data Analysis
        │
        ▼
Feature Selection
(Correlation + VIF + LASSO)
        │
        ▼
Data Preprocessing
• Winsorization
• Standardization
• Class Weight Handling
        │
        ▼
Model Development
• Logistic Regression
• Random Forest
• XGBoost
        │
        ▼
Hyperparameter Optimization
(Optuna)
        │
        ▼
Model Evaluation
        │
        ▼
Model Interpretation
(SHAP)
```

---

## Feature Engineering

The project introduces several behavioural features designed to capture customers' repayment patterns more effectively than raw monthly variables.

Engineered features include:

- Average Bill Amount
- Average Payment Amount
- Credit Utilization Ratio
- Payment-to-Bill Ratio
- Bill Amount Volatility
- Payment Volatility

---

## Machine Learning Models

The following models were developed and optimized:

- Logistic Regression
- Random Forest
- XGBoost

Hyperparameter optimization was performed using **Optuna** with stratified cross-validation.

---

## Model Evaluation

The models were evaluated using:

- Accuracy
- Balanced Accuracy
- Precision
- Recall
- F1-Score
- ROC-AUC
- Precision-Recall AUC (PR-AUC)

Since credit default prediction is an imbalanced classification problem, **PR-AUC** was considered the primary model selection metric.

---

## Final Model Performance

| Model | Accuracy | F1 Score | ROC-AUC | PR-AUC |
|-------|----------:|----------:|---------:|---------:|
| Logistic Regression | 0.713 | 0.485 | 0.722 | 0.493 |
| Random Forest | **0.785** | **0.546** | 0.771 | 0.551 |
| **XGBoost (Final Model)** | 0.764 | 0.535 | **0.774** | **0.553** |

The optimized **XGBoost** model achieved the highest PR-AUC and ROC-AUC, making it the final selected model.

---

## Model Explainability

To improve interpretability, SHAP (SHapley Additive exPlanations) was used.

Interpretation includes:

- SHAP Summary Plot
- SHAP Waterfall Plot
- Global Feature Importance
- Local Prediction Explanation

These analyses provide insight into how individual features influence default predictions.

---

## Technologies Used

### Programming

- Python
- SQL

### Python Libraries

- Pandas
- NumPy
- Scikit-learn
- XGBoost
- Optuna
- SHAP
- Matplotlib
- Seaborn

---

## Repository Structure

```
├── python_notebook.ipynb                 # Complete machine learning workflow
├── default of credit card clients.csv    # Original dataset
├── credit_card_features.csv              # Feature descriptions
├── output_EXCEL.xlsx                     # Model evaluation outputs
├── create_table.sql                      # SQL table creation
├── data_validation_clean_table.sql       # Data cleaning and validation
├── feature_engineering.sql               # SQL feature engineering
├── business_analysis.sql                 # SQL business analysis
└── README.md
```

---

## Key Highlights

- End-to-end credit risk modelling project
- SQL + Machine Learning workflow
- Behavioural feature engineering
- Hyperparameter optimization using Optuna
- Model comparison across three algorithms
- SHAP-based explainable AI
- Suitable for credit risk and banking analytics applications

---

## Future Improvements

- Incorporate macroeconomic indicators
- Explore LightGBM and CatBoost
- Cost-sensitive learning for credit approval
- Probability calibration
- Real-time deployment using FastAPI or Streamlit

---

## Author

**Ashis Pal**

Master's in Applied Quantitative Finance  
Madras School of Economics

Interested in Machine Learning, Credit Risk Modelling, Financial Analytics, and Quantitative Finance.
