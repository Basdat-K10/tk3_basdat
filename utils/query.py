
from collections import namedtuple
import psycopg2
from psycopg2 import Error
from psycopg2.extras import RealDictCursor
import os

try:
    connection = psycopg2.connect(
        user=os.getenv("DB_USERNAME", "avnadmin"),
        password=os.getenv("DB_PASSWORD", "AVNS_ivRXzozyV6jfpn-JVxu"),
        host=os.getenv("DB_HOST", "basdat-k10-arya-2952.g.aivencloud.com"),
        port=os.getenv("DB_PORT", "23774"),
        database=os.getenv("DB_NAME", "defaultdb"))

    # Create a cursor to perform database operations
    connection.autocommit = True
    cursor = connection.cursor()
except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL: ", error)


def map_cursor(cursor):
    """Return all rows from a cursor as a namedtuple"""
    description = cursor.description
    named_tuple_result = namedtuple("Result", [col[0] for col in description])
    return [dict(row) for row in cursor.fetchall()]


def query(query_str: str, parameter: tuple = tuple()):
    result = []
    with connection.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute("SET search_path TO pacilflix")
        try:
            cursor.execute(query_str, parameter)
            # Handling SELECT queries
            if query_str.strip().upper().startswith("SELECT") or query_str.strip().upper().startswith("WITH"):
                result = map_cursor(cursor)
            else:
                # Returns modified row count
                result = cursor.rowcount
                connection.commit()
        except Exception as e:
           raise e

    return result