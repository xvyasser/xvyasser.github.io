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
2. **Data Loading** using Python
3. **Data cleaning & transformation**  
4. **Analytical view design**  
5. **Power BI dashboard development**

---

## 🛠️ Project Workflow

### 1️⃣ **Database Setup & Loading with Faced Challenges with Soultion (SQL Server & Python)**
- Created a new SQL Server database (`steam_analytics`)
- Imported all 13 CSV files from the [Steam Dataset 2025 CSV Package](https://www.kaggle.com/datasets/crainbramp/steam-dataset-2025-multi-modal-gaming-analytics) using Python
## Data Loading Process

### Challenge: Multi-Language UTF-8 Data

The Steam dataset contains game information in **multiple languages** (Japanese, Chinese, Russian, Spanish, etc.), which presented unique challenges during the ETL process.

### Initial Approach: SQL Server BULK INSERT ❌

Attempted using native SQL Server `BULK INSERT` command, but encountered multiple failures:
- **Character encoding errors**: UTF-8 data with international characters caused conversion errors
- **Field terminator issues**: Commas within quoted fields caused column misalignment
- **Data corruption**: Characters displayed as garbled text (`ã‚¢ãƒ‹ãƒ¡` instead of proper Unicode)
```sql
-- This approach FAILED due to UTF-8 complexity
BULK INSERT applications 
FROM 'applications.csv'
WITH (CODEPAGE = '65001', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
-- Result: Msg 4866, 4864, 7301 errors
```

### Solution: Python ETL Pipeline ✅

**Why Python was necessary:**
- **Native UTF-8 support**: Pandas handles multi-byte character encoding seamlessly
- **Robust CSV parsing**: Properly processes quoted fields and special characters
- **Data validation**: Clean and transform data before insertion
- **Batch processing**: Efficient loading of 239K+ records with error recovery

**Implementation:**
```python
import pandas as pd
import pyodbc

# Read CSV with UTF-8 encoding
df = pd.read_csv(csv_file, encoding='utf-8', low_memory=False)

# Load to SQL Server with proper NULL handling
cursor.executemany(insert_sql, processed_rows)
```

**Results:**
- ✅ Successfully loaded **239,664 applications** across 11 tables
- ✅ Preserved international text integrity (Japanese: なんでライフルを持ってるの？, Chinese: 在线合作, Russian: Кооператив)
- ✅ Zero data corruption or character encoding issues

### Technologies Used
- **Python 3.x**: ETL scripting
- **Pandas**: CSV parsing and data manipulation
- **pyodbc**: SQL Server database connectivity
- **SQL Server**: Data warehouse and analytics platform

### Lesson Learned
For datasets with **international/multi-language content**, Python-based ETL pipelines are more reliable than SQL Server's native BULK INSERT, which was designed primarily for single-byte character sets.


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
