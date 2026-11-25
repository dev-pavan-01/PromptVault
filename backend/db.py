"""Database connection helper for PromptVault."""

import os
import mysql.connector
from dotenv import load_dotenv

# Load environment variables from backend/.env regardless of current working directory
ENV_PATH = os.path.join(os.path.dirname(__file__), ".env")
load_dotenv(ENV_PATH)


def get_db_connection():
    """Create and return a new MySQL database connection."""
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_NAME", "promptvault"),
    )
