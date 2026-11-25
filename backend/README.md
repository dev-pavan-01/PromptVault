# PromptVault Backend Documentation

This is the backend REST API for **PromptVault**, a beginner-friendly DBMS project built with **Python**, **Flask**, and **MySQL**.

---

## 1. Project Backend Structure

```text
promptvault/
├── .gitignore                 # Excludes .env, venv/, and __pycache__/ from Git
├── database/
│   └── promptvault.sql        # MySQL database and table definitions
└── backend/
    ├── .env                   # Private MySQL connection credentials
    ├── app.py                 # Main Flask application and API endpoints
    ├── db.py                  # MySQL connection helper
    ├── requirements.txt       # Python package dependencies
    ├── README.md              # Backend documentation (this file)
    └── venv/                  # Python virtual environment
```

---

## 2. Technologies Used

- **Python** — Programming language used for the backend logic.
- **Flask (`3.1.0`)** — Lightweight Python web framework used to define API routes and return JSON responses.
- **MySQL** — Relational database storing `Categories`, `Prompts`, `Tags`, `Prompt_Tags`, and `Favorites`.
- **`mysql-connector-python` (`9.2.0`)** — Official MySQL driver that lets Python run SQL queries.
- **`python-dotenv` (`1.0.1`)** — Loads database credentials from `backend/.env` into environment variables.

---

## 3. How Flask Connects to MySQL

1. Your database settings (`DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`) are stored in `backend/.env` so passwords are kept out of Python source code.
2. `backend/db.py` loads `backend/.env` using `load_dotenv()`.
3. When an API route needs data, it calls `get_db_connection()` from `db.py` to open a connection to the `promptvault` MySQL database.
4. Every route closes its `cursor` and `connection` inside a `finally` block so connections are never left open.
5. You can verify the connection anytime by visiting `GET /test-db`.

---

## 4. Purpose of Each Python File

- **`backend/db.py`**
  - Loads environment variables from `backend/.env`.
  - Defines `get_db_connection()` to create and return a MySQL connection using `mysql.connector.connect(...)`.
- **`backend/app.py`**
  - Creates the Flask app (`app = Flask(__name__)`).
  - Contains helper functions to validate JSON input (`validate_prompt_payload`, `validate_category_payload`, `validate_tag_payload`), build search/filter queries (`build_prompt_filters`), check existence (`category_exists`, `prompt_exists`, `tag_exists`), and format rows as JSON (`serialize_prompt`, `serialize_category`, `serialize_tag`).
  - Defines all 22 API endpoints for health checks, Prompts, Categories, Search/Filtering, Tags, and Favorites.

---

## 5. Implemented API Endpoints

### Database Health Check
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/test-db` | Checks whether Flask can connect to the `promptvault` MySQL database |

### Prompts CRUD & Search / Filtering
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/prompts` | Retrieve all prompts (supports optional `?category_id=`, `?ai_tool=`, `?featured=`, `?q=`) |
| `GET` | `/prompts/search` | Search prompts by `title` or `content` (`?q=` required; supports combining with filters) |
| `GET` | `/prompts/<id>` | Retrieve a single prompt by `prompt_id` |
| `POST` | `/prompts` | Create a new prompt |
| `PUT` | `/prompts/<id>` | Update an existing prompt |
| `DELETE` | `/prompts/<id>` | Delete a prompt |

### Categories
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/categories` | Retrieve all categories |
| `GET` | `/categories/<id>` | Retrieve a single category by `category_id` |
| `POST` | `/categories` | Create a new category |
| `PUT` | `/categories/<id>` | Update an existing category |
| `DELETE` | `/categories/<id>` | Delete a category (blocked with `409` if used by any prompts) |

### Tags & Prompt Tags
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/tags` | Retrieve all available tags |
| `POST` | `/tags` | Create a new tag |
| `PUT` | `/tags/<id>` | Update an existing tag |
| `DELETE` | `/tags/<id>` | Delete a tag (linked `Prompt_Tags` rows cascade-delete) |
| `GET` | `/prompts/<id>/tags` | Retrieve all tags assigned to a prompt |
| `POST` | `/prompts/<id>/tags` | Assign an existing tag to a prompt |
| `DELETE` | `/prompts/<id>/tags/<tag_id>` | Remove a tag from a prompt |

### Favorites
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/favorites` | Retrieve all favorited prompts |
| `POST` | `/favorites` | Add a prompt to favorites (`prompt_id` in JSON body) |
| `DELETE` | `/favorites/<prompt_id>` | Remove a prompt from favorites |

---

## 6. How SQL Operations Work in the Backend

All queries use **parameterized SQL** (`%s` placeholders) instead of string concatenation to prevent SQL injection:

- **`SELECT` (Read):** Opens a dictionary cursor (`connection.cursor(dictionary=True)`), runs `cursor.execute(query, params)`, fetches rows with `fetchone()` or `fetchall()`, and converts them to JSON with `jsonify()`.
- **`INSERT` (Create):** Validates the JSON body, runs `INSERT INTO ... VALUES (%s, ...)`, calls `connection.commit()` to save changes, reads `cursor.lastrowid`, and returns HTTP `201`. Duplicate `UNIQUE` values (like duplicate category names, tag names, or favorites) are caught via MySQL error `1062` and return HTTP `409`.
- **`UPDATE` (Modify):** Verifies the record exists (`404` if missing), builds a parameterized `UPDATE ... SET field = %s WHERE ... = %s` query for the provided fields, calls `connection.commit()`, and returns HTTP `200`.
- **`DELETE` (Remove):** Runs `DELETE FROM ... WHERE ... = %s`, calls `connection.commit()`, and checks `cursor.rowcount` (returning `404` if no row matched, or `200` if deleted). Deleting a category still referenced by `Prompts` is blocked with HTTP `409`.

If any database error occurs during a write (`POST`, `PUT`, `DELETE`), `connection.rollback()` cancels the partial change and the API returns a clean JSON error.

---

## 7. Activating the Virtual Environment & Starting Flask

Run these commands from the project root (`d:\promptvault`) in PowerShell:

1. **Activate the virtual environment:**
   ```powershell
   backend\venv\Scripts\Activate.ps1
   ```
   *(If PowerShell blocks script execution, you can run Python directly without activating: `backend\venv\Scripts\python.exe backend\app.py`)*

2. **Install dependencies (only needed once or after `requirements.txt` changes):**
   ```powershell
   pip install -r backend\requirements.txt
   ```

3. **Start the Flask server:**
   ```powershell
   python backend\app.py
   ```
   The server will start at `http://127.0.0.1:5000`.

---

## 8. Testing the APIs with Postman

1. Start the Flask server (`http://127.0.0.1:5000`).
2. Test the database connection first:
   - `GET http://127.0.0.1:5000/test-db` → should return `200` with `"database": "promptvault"`.
3. For `POST` and `PUT` requests in Postman:
   - Open **Body** → select **raw** → choose **JSON** from the dropdown.
4. Recommended test flow:
   - **Create a Category:** `POST /categories` with `{"category_name": "Coding", "description": "Developer prompts"}`
   - **Create a Prompt:** `POST /prompts` with `{"title": "Python Helper", "content": "Explain...", "category_id": 1, "ai_tool": "ChatGPT", "is_featured": true}`
   - **Search & Filter:** `GET /prompts/search?q=Python&category_id=1&ai_tool=ChatGPT&featured=true`
   - **Create & Assign a Tag:** `POST /tags` with `{"tag_name": "python"}`, then `POST /prompts/1/tags` with `{"tag_id": 1}`
   - **Favorite a Prompt:** `POST /favorites` with `{"prompt_id": 1}`, then `GET /favorites`
   - **Delete in reverse order** to test cleanup: `DELETE /favorites/1` → `DELETE /prompts/1/tags/1` → `DELETE /tags/1` → `DELETE /prompts/1` → `DELETE /categories/1`
