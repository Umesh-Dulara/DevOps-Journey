import os
import time
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "counter_db")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "postgres")
DB_PORT = os.getenv("DB_PORT", "5432")

def get_db_connection():
    # Retry loop to wait until PostgreSQL is ready
    retries = 5
    while retries > 0:
        try:
            conn = psycopg2.connect(
                host=DB_HOST,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASS,
                port=DB_PORT
            )
            return conn
        except psycopg2.OperationalError:
            retries -= 1
            time.sleep(2)
    raise Exception("Could not connect to PostgreSQL after multiple retries.")

@app.route("/")
def visit():
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Atomic increment and return current count
    cur.execute("""
        UPDATE visitor_count 
        SET count = count + 1 
        WHERE id = 1 
        RETURNING count;
    """)
    current_count = cur.fetchone()[0]
    conn.commit()
    
    cur.close()
    conn.close()
    
    return jsonify({
        "message": "Welcome!",
        "total_visits": current_count
    }), 200

@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
