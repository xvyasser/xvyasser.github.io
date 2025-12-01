import pandas as pd
import pyodbc
import os

# Configuration
SERVER = 'DESKTOP-M9MOB75\SQLEXPRESS'  # Change this (e.g., 'localhost', '.', or '.\SQLEXPRESS')
DATABASE = 'Steam'
CSV_PATH = r'F:\Steam Project\steam_dataset_2025_csv_package_v1\steam_dataset_2025_csv'
# Database connection
conn_str = (
    f'DRIVER={{ODBC Driver 17 for SQL Server}};'
    f'SERVER={SERVER};'
    f'DATABASE={DATABASE};'
    f'Trusted_Connection=yes;'
)

# Table definitions: (csv_file, table_name, has_composite_key)
tables_to_load = [
    # Dimension tables (load first)
    ('categories.csv', 'categories', False),
    ('Developers.csv', 'Developers', False),
    ('genres.csv', 'Genres', False),
    ('platforms.csv', 'Platforms', False),
    ('publishers.csv', 'Publishers', False),
    ('applications.csv', 'applications', False),
    
    # Fact tables (load after dimensions)
    ('application_categories.csv', 'application_categories', True),
    ('application_developers.csv', 'application_developers', True),
    ('application_genres.csv', 'application_genres', True),
    ('application_platforms.csv', 'application_platforms', True),
    ('application_publishers.csv', 'application_publishers', True),
]

def load_table(cursor, conn, csv_file, table_name):
    """Load a single CSV file into a table"""
    csv_full_path = os.path.join(CSV_PATH, csv_file)
    
    print(f"\n{'='*60}")
    print(f"Loading: {csv_file} → {table_name}")
    print(f"{'='*60}")
    
    try:
        # Read CSV with UTF-8 encoding
        print(f"  Reading CSV file...")
        df = pd.read_csv(
            csv_full_path,
            encoding='utf-8',
            low_memory=False,
            on_bad_lines='warn'
        )
        
        print(f"  Found {len(df):,} rows, {len(df.columns)} columns")
        print(f"  Columns: {list(df.columns)}")
        
        # Handle date columns if present
        date_columns = ['release_date', 'created_at', 'updated_at']
        for col in date_columns:
            if col in df.columns:
                df[col] = pd.to_datetime(df[col], errors='coerce')
        
        # Truncate table
        print(f"  Truncating table {table_name}...")
        cursor.execute(f"TRUNCATE TABLE {table_name}")
        conn.commit()
        
        # Prepare insert statement
        columns = list(df.columns)
        placeholders = ','.join(['?' for _ in columns])
        insert_sql = f"INSERT INTO {table_name} ({','.join(columns)}) VALUES ({placeholders})"
        
        # Insert in batches
        batch_size = 1000
        total_rows = len(df)
        successful_batches = 0
        failed_batches = 0
        
        print(f"  Inserting data in batches of {batch_size}...")
        for i in range(0, total_rows, batch_size):
            batch = df.iloc[i:i+batch_size]
            
            # Convert rows to tuples, handling NaN
            rows = []
            for _, row in batch.iterrows():
                processed = tuple(None if pd.isna(x) else x for x in row)
                rows.append(processed)
            
            try:
                cursor.executemany(insert_sql, rows)
                conn.commit()
                successful_batches += 1
                
                if (i + batch_size) % 5000 == 0 or (i + batch_size) >= total_rows:
                    print(f"    Progress: {min(i + batch_size, total_rows):,}/{total_rows:,} rows")
            
            except Exception as batch_error:
                print(f"    ✗ Error in batch {i}-{i+batch_size}: {batch_error}")
                failed_batches += 1
                conn.rollback()
        
        # Verify
        cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
        count = cursor.fetchone()[0]
        
        print(f"\n  ✓ SUCCESS!")
        print(f"    Rows in table: {count:,}")
        print(f"    Successful batches: {successful_batches}")
        if failed_batches > 0:
            print(f"    Failed batches: {failed_batches}")
        
        return True
        
    except FileNotFoundError:
        print(f"  ✗ ERROR: File not found: {csv_full_path}")
        return False
    except Exception as e:
        print(f"  ✗ ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    print("="*60)
    print("STEAM DATABASE LOADER")
    print("="*60)
    print(f"Server: {SERVER}")
    print(f"Database: {DATABASE}")
    print(f"CSV Path: {CSV_PATH}")
    
    try:
        # Connect to database
        print("\nConnecting to database...")
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        print("✓ Connected successfully!")
        
        # Load all tables
        results = {}
        for csv_file, table_name, _ in tables_to_load:
            success = load_table(cursor, conn, csv_file, table_name)
            results[table_name] = success
        
        # Summary
        print("\n" + "="*60)
        print("LOAD SUMMARY")
        print("="*60)
        
        for table_name, success in results.items():
            status = "✓ SUCCESS" if success else "✗ FAILED"
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            count = cursor.fetchone()[0]
            print(f"{status:12} {table_name:30} {count:>10,} rows")
        
        print("\n" + "="*60)
        successful = sum(1 for s in results.values() if s)
        print(f"Tables loaded successfully: {successful}/{len(results)}")
        print("="*60)
        
    except Exception as e:
        print(f"\n✗ FATAL ERROR: {e}")
        import traceback
        traceback.print_exc()
    
    finally:
        if 'conn' in locals():
            conn.close()
            print("\nConnection closed.")

if __name__ == "__main__":
    main()
