import csv
import sqlite3
import os

db_path = ":memory:"
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Locate dataset
csv_path = os.path.join(os.path.dirname(__file__), "..", "Dataset", "supply_chain_clean_data.csv")

with open(csv_path, "r", encoding="utf-8") as f:
    reader = csv.reader(f)
    headers = next(reader)
    
    # Create table dynamically
    col_defs = ", ".join([f'"{h}" TEXT' for h in headers])
    cursor.execute(f"CREATE TABLE supply_chain ({col_defs})")
    
    # Insert rows
    placeholders = ", ".join(["?"] * len(headers))
    cursor.executemany(f"INSERT INTO supply_chain VALUES ({placeholders})", reader)
    conn.commit()

print(f"Loaded {cursor.execute('SELECT COUNT(*) FROM supply_chain').fetchone()[0]} records into SQLite database.\n")

queries = [
    ("Total Records & Revenue", "SELECT COUNT(*) AS total_records, ROUND(SUM(CAST(Revenue_generated AS FLOAT)), 2) AS total_revenue FROM supply_chain"),
    ("Top 3 Product Types by Revenue", "SELECT Product_type, ROUND(SUM(CAST(Revenue_generated AS FLOAT)), 2) AS total_revenue FROM supply_chain GROUP BY Product_type ORDER BY total_revenue DESC"),
    ("Average Defect Rate by Supplier", "SELECT Supplier_name, ROUND(AVG(CAST(Defect_rates AS FLOAT)), 2) AS avg_defect_rate FROM supply_chain GROUP BY Supplier_name ORDER BY avg_defect_rate DESC"),
    ("Shipping Cost by Transportation Mode", "SELECT Transportation_modes, ROUND(AVG(CAST(Shipping_costs AS FLOAT)), 2) AS avg_shipping_cost FROM supply_chain GROUP BY Transportation_modes ORDER BY avg_shipping_cost DESC"),
    ("Supplier Revenue Rank (Window Function)", "SELECT Supplier_name, ROUND(SUM(CAST(Revenue_generated AS FLOAT)), 2) AS total_revenue, DENSE_RANK() OVER (ORDER BY SUM(CAST(Revenue_generated AS FLOAT)) DESC) as rank FROM supply_chain GROUP BY Supplier_name LIMIT 5")
]

for title, q in queries:
    print(f"=== {title} ===")
    cursor.execute(q)
    cols = [desc[0] for desc in cursor.description]
    print(" | ".join(cols))
    print("-" * 50)
    for row in cursor.fetchall():
        print(" | ".join(str(val) for val in row))
    print("\n")
