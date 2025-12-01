# 🎮 Steam Dataset 2025: End-to-End Analytics Project

*An end-to-end analytics pipeline using the official **Steam Dataset 2025** — from raw data to interactive dashboard.*

---

## 🔗 **About the Dataset**

This project uses the **[Steam Dataset 2025](https://www.kaggle.com/datasets/crainbramp/steam-dataset-2025-multi-modal-gaming-analytics)** — the first multi-modal Steam dataset with **239,664 applications**, **1M+ reviews**, semantic search (BGE-M3 embeddings), and graph-ready relationships.

> ✅ Built exclusively from **official Steam Web APIs**  
> ✅ Covers **28 years** of platform evolution (1997–2025)  
> ✅ Includes publishers, developers, genres, reviews, and language support

---

## 🧠 Project Overview

I built a **full analytics pipeline** using the Steam Dataset 2025 CSV package (v1) to answer key questions about:
- Platform growth over time
- Genre and pricing trends
- Publisher/developer ecosystems
- User sentiment (via reviews)

This repository contains **all code, views, and documentation** for:
1. **Database creation** in SQL Server  
2. **Data cleaning & transformation**  
3. **Analytical view design**  
4. **Power BI dashboard development**

---

## 🛠️ Project Workflow

### 1️⃣ **Database Setup (SQL Server)**
- Created a new SQL Server database (`steam_analytics`)
- Imported all 13 CSV files from the [Steam Dataset 2025 CSV Package](https://www.kaggle.com/datasets/crainbramp/steam-dataset-2025-multi-modal-gaming-analytics) using Python

### 2️⃣ **Data Cleaning**
Performed comprehensive cleaning in SQL Server:
- Removed HTML tags and malformed strings (e.g., `"Koreanlanguages with full audio support"`)
- Standardized language names to English (e.g., `"Inglês"` → `"English"`)
- Normalized region formats (e.g., `"Spanish - Spain"` → `"Spanish (Spain)"`)
- Fixed data types (`release_date` → `DATE`, boolean flags → `BIT`)
- Added derived columns: `fixedprice`, `release_year`, `price_bins`, etc...

### 3️⃣ **Data Modeling & Views**
Designed a star-schema–inspired model with:
- Fact tables: `applications`
- Dimension tables: `genres`, `publishers`, `developers`,'reviews'm'categories'
- Junction tables: `app_genres`, `app_categories`

Created **optimized analytical views**:
- `Fact_view_applications`
- `Dim_View_applications`
- `Dim_view_publisher`
- `dim_view_developer`
- 'dim_view_genre'
- 'dim_view_categories'

> 📂 See `/sql` folder for full scripts.

### 4️⃣ **Power BI Dashboard**
- Connected Power BI directly to SQL Server (**Import mode**)
- Built **5 interactive dashboard pages**:
  - Overview
  - Games Analytics (1997–2025)
  - Genre & Categories Trends
  - Publisher & Developer Ecosystem
  - User Reviews 
- Implemented DAX measures for KPIs, trends, and segmentation

> 📊 **Final Output**: `Steam_Analytics_Dashboard.pbix` (included)

