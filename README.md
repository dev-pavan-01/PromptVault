# PromptVault

**PromptVault** is a beginner-friendly full-stack Database Management System (DBMS) project for storing, organizing, searching, and managing reusable AI prompts using **Python**, **Flask**, **MySQL**, **HTML**, **CSS**, and **JavaScript**.

---

## 1. Project Introduction & Objectives

As AI tools like ChatGPT, Claude, Gemini, and Midjourney become part of daily workflows, useful prompts often get lost across chats and notes. **PromptVault** solves this by providing a structured relational database and clean web interface to manage prompts in one place.

**Objectives:**
- Store prompts in a normalized **MySQL** relational database with categories, tags, and favorites.
- Build a clean REST API using **Python Flask** and parameterized SQL queries.
- Provide a responsive web frontend where users can browse, search, filter, copy, add, edit, delete, and favorite prompts.

---

## 2. Main Features

- **Organized Categories:** 8 curated categories (`Programming & Development`, `AI & Automation`, `Photo Editing & AI Art`, `Students & Education`, `Business & Marketing`, `Career & Professional`, `Social Media & Content Creation`, and `Productivity`).
- **Prompt Library (112 Seeded Prompts):** Practical, copy-ready prompts with placeholders, compatible AI tools, and prompt types.
- **Search & Multi-Filtering:** Search by keyword in prompt titles/content and combine filters for Category, AI Tool, and Prompt Type.
- **Prompt Details & One-Click Copy:** View complete prompt text, assigned tags, and copy prompts to the clipboard with confirmation.
- **Add, Edit & Delete Prompts:** Create new prompts, update existing prompts inline, and delete prompts with confirmation.
- **Favorites Management:** Save or remove prompts from favorites and view them on a dedicated Favorites page.
- **Tags Support (Backend API + Details Display):** Manage tags and many-to-many prompt-tag assignments via the REST API, with assigned tags shown on the Prompt Details page.

---

## 3. Technologies Used

- **Database:** MySQL
- **Backend:** Python, Flask (`3.1.0`), `mysql-connector-python` (`9.2.0`), `python-dotenv` (`1.0.1`)
- **Frontend:** HTML5, CSS3, Vanilla JavaScript (`fetch` API)
- **Tools:** Git, SQLTools / MySQL Workbench, Postman

---

## 4. Database Design (5 Tables)

The schema is defined in `database/promptvault.sql` under the `promptvault` database:

1. **`Categories`**
   - Stores prompt categories (`category_id` PK, `category_name` UNIQUE, `description`).
2. **`Prompts`**
   - Stores each prompt (`prompt_id` PK, `title`, `content`, `category_id` FK → `Categories`, `prompt_type`, `ai_tool`, `source_name`, `source_url`, `is_featured`, `created_at`, `updated_at`).
3. **`Tags`**
   - Stores reusable tag labels (`tag_id` PK, `tag_name` UNIQUE).
4. **`Prompt_Tags`**
   - Junction table for the **many-to-many** relationship between `Prompts` and `Tags` (`PRIMARY KEY (prompt_id, tag_id)`, with `ON DELETE CASCADE` on both foreign keys).
5. **`Favorites`**
   - Stores favorited prompts (`favorite_id` PK, `prompt_id` UNIQUE FK → `Prompts` with `ON DELETE CASCADE`, `added_at`).

---

## 5. Project Folder Structure

```text
promptvault/
├── .gitignore                 # Excludes .env, venv/, and __pycache__/ from Git
├── README.md                  # Main project documentation (this file)
├── database/
│   ├── promptvault.sql        # Database & 5-table schema definition
│   ├── categories.sql         # Initial 8 categories seed script
│   └── prompts.sql            # Initial 112 prompts seed script
├── backend/
│   ├── .env                   # Private MySQL credentials (excluded from Git)
│   ├── app.py                 # Flask application & 22 REST API endpoints
│   ├── db.py                  # MySQL connection helper using python-dotenv
│   ├── requirements.txt       # Python dependencies
│   ├── README.md              # Backend-specific documentation
│   └── venv/                  # Python virtual environment (excluded from Git)
└── frontend/
    ├── index.html             # Homepage (hero, search, filters, categories, prompts)
    ├── prompt.html            # Prompt details, copy, tags, edit & delete controls
    ├── favorites.html         # Saved favorites page
    ├── add-prompt.html        # Add new prompt form page
    ├── css/
    │   └── styles.css         # Responsive styling and animations
    └── js/
        ├── data.js            # Shared API client & helper functions
        ├── main.js            # Homepage logic
        ├── prompt.js          # Prompt details, edit & delete logic
        ├── favorites.js       # Favorites page logic
        └── add-prompt.js      # Add prompt form validation & submission
```

---

## 6. Installation & Setup Instructions

1. **Create the MySQL database and tables:**
   - Open `database/promptvault.sql` in **SQLTools** (or MySQL Workbench) and execute it.
2. **Load the initial seed data (in order):**
   - Execute `database/categories.sql` (adds the 8 categories).
   - Execute `database/prompts.sql` (adds the 112 prompts).
3. **Create / activate the Python virtual environment and install dependencies:**
   - **Git Bash:**
     ```bash
     cd backend
     python -m venv venv          # skip if venv already exists
     source venv/Scripts/activate
     pip install -r requirements.txt
     ```
   - **PowerShell:**
     ```powershell
     cd backend
     backend\venv\Scripts\Activate.ps1   # or run from project root
     pip install -r requirements.txt
     ```

---

## 7. Configuring the MySQL Connection

Create or edit `backend/.env` with your local MySQL credentials (never commit `.env` to Git):

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=promptvault
```

`backend/db.py` loads `backend/.env` via `python-dotenv` and exposes `get_db_connection()`.

---

## 8. How to Activate & Start the Servers

You need **two terminals**: one for the Flask backend and one for the frontend static server.

### Terminal 1 — Start the Flask Backend (`http://127.0.0.1:5000`)
- **Git Bash (from `backend/`):**
  ```bash
  source venv/Scripts/activate
  python app.py
  (or) 
  backend/venv/Scripts/python.exe backend/app.py
  ```
- **PowerShell (from project root `d:\promptvault`):**
  ```powershell
  backend\venv\Scripts\python.exe backend\app.py
  ```

### Terminal 2 — Start the Frontend Server (`http://127.0.0.1:5500`)
- **Git Bash (from `backend/`):**
  ```bash
  venv/Scripts/python.exe -m http.server 5500 -d ../frontend
  ```
- **PowerShell (from project root `d:\promptvault`):**
  ```powershell
  backend\venv\Scripts\python.exe -m http.server 5500 -d frontend
  ```
  *(Alternatively, open `frontend/index.html` using VS Code **Live Server**.)*

Then open **`http://127.0.0.1:5500/index.html`** in your browser.

---

## 9. API Endpoint Documentation

Base URL: `http://127.0.0.1:5000`

| Module | Method & Endpoint | Description |
|---|---|---|
| **Health** | `GET /test-db` | Verify MySQL connection |
| **Prompts** | `GET /prompts` | List prompts (supports `?category_id=`, `?ai_tool=`, `?featured=`, `?q=`) |
| **Prompts** | `GET /prompts/search` | Search `title`/`content` (`?q=` required; supports combining filters) |
| **Prompts** | `GET /prompts/<id>` | Get a single prompt |
| **Prompts** | `POST /prompts` | Create a new prompt |
| **Prompts** | `PUT /prompts/<id>` | Update an existing prompt |
| **Prompts** | `DELETE /prompts/<id>` | Delete a prompt |
| **Categories** | `GET /categories` | List all categories |
| **Categories** | `GET /categories/<id>` | Get a single category |
| **Categories** | `POST /categories` | Create a new category |
| **Categories** | `PUT /categories/<id>` | Update a category |
| **Categories** | `DELETE /categories/<id>` | Delete an unused category (`409` if referenced by prompts) |
| **Tags** | `GET /tags` | List all tags |
| **Tags** | `POST /tags` | Create a tag |
| **Tags** | `PUT /tags/<id>` | Update a tag |
| **Tags** | `DELETE /tags/<id>` | Delete a tag |
| **Prompt Tags** | `GET /prompts/<id>/tags` | List tags assigned to a prompt |
| **Prompt Tags** | `POST /prompts/<id>/tags` | Assign an existing `tag_id` to a prompt |
| **Prompt Tags** | `DELETE /prompts/<id>/tags/<tag_id>` | Remove a tag from a prompt |
| **Favorites** | `GET /favorites` | List all favorited prompts |
| **Favorites** | `POST /favorites` | Add a prompt to favorites (`{"prompt_id": 1}`) |
| **Favorites** | `DELETE /favorites/<prompt_id>` | Remove a prompt from favorites |

---

## 10. Examples of SQL Operations (via Backend & MySQL)

All backend queries use parameterized `%s` placeholders to prevent SQL injection:

- **INSERT (`POST /prompts`):**
  ```sql
  INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured)
  VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
  ```
- **SELECT (`GET /prompts/search` & `GET /prompts/<id>/tags`):**
  ```sql
  SELECT * FROM Prompts WHERE (title LIKE %s OR content LIKE %s) ORDER BY created_at DESC;
  ```
- **UPDATE (`PUT /prompts/<id>`):**
  ```sql
  UPDATE Prompts SET title = %s, content = %s WHERE prompt_id = %s;
  ```
- **DELETE (`DELETE /prompts/<id>` & `DELETE /favorites/<prompt_id>`):**
  ```sql
  DELETE FROM Prompts WHERE prompt_id = %s;
  ```

---

## 11. Testing Instructions

1. **Database Check:**
   - Visit `http://127.0.0.1:5000/test-db` → confirm `"status": "success"` and `"database": "promptvault"`.
   - In SQLTools, verify `SELECT COUNT(*) FROM Categories;` (`8`) and `SELECT COUNT(*) FROM Prompts;` (`112`).
2. **API Testing (Postman):**
   - Test `GET /categories`, `GET /prompts`, `POST /prompts`, `PUT /prompts/<id>`, `DELETE /prompts/<id>`, `POST /tags`, `POST /prompts/<id>/tags`, `POST /favorites`, and `DELETE /favorites/<prompt_id>` using JSON bodies (`Content-Type: application/json`).
3. **Frontend Testing (Browser):**
   - Open `http://127.0.0.1:5500/index.html` and open Chrome DevTools (`F12` → **Console**) to verify zero errors.
   - Test searching, combining Category / AI Tool / Prompt Type filters, clearing filters, copying a prompt, adding/removing favorites, creating a prompt on `add-prompt.html`, and editing/deleting a prompt on `prompt.html`.
   - Toggle mobile view (`Ctrl+Shift+M` at `375px` width) to verify responsive cards and mobile navigation menu.
