"""Entry point for the PromptVault Flask backend."""

from flask import Flask, jsonify, request
from mysql.connector import Error

from db import get_db_connection

app = Flask(__name__)


@app.after_request
def add_cors_headers(response):
    """Allow the frontend origin to call Flask APIs during local development."""
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    return response

# Fields that can be set or updated on a prompt
STRING_LIMITS = {
    "title": 200,
    "prompt_type": 50,
    "ai_tool": 100,
    "source_name": 150,
    "source_url": 500,
}

# Maximum lengths for Categories table columns
CATEGORY_STRING_LIMITS = {
    "category_name": 100,
    "description": 255,
}


def serialize_category(row):
    """Convert a Categories row dictionary into a JSON-friendly dictionary."""
    if not row:
        return None

    return {
        "category_id": row["category_id"],
        "category_name": row["category_name"],
        "description": row["description"],
    }


def validate_category_payload(data, is_update=False):
    """Validate JSON input for creating or updating a category.

    Returns (cleaned_data, error_message).
    """
    if not isinstance(data, dict):
        return None, "Request body must be a valid JSON object."

    cleaned = {}

    if not is_update:
        if "category_name" not in data or data["category_name"] is None:
            return None, "Missing required field: 'category_name'."

    if "category_name" in data:
        name = data["category_name"]
        if not isinstance(name, str) or not name.strip():
            return None, "'category_name' must be a non-empty string."
        cleaned["category_name"] = name.strip()

    if "description" in data:
        desc = data["description"]
        if desc is not None and not isinstance(desc, str):
            return None, "'description' must be a string or null."
        cleaned["description"] = desc.strip() if isinstance(desc, str) else None

    for field, max_len in CATEGORY_STRING_LIMITS.items():
        if field in cleaned and cleaned[field] is not None:
            if len(cleaned[field]) > max_len:
                return None, f"'{field}' cannot exceed {max_len} characters."

    if is_update and not cleaned:
        return None, "Provide at least one valid field to update."

    return cleaned, None


def serialize_prompt(row):
    """Convert a database row dictionary into a JSON-friendly dictionary."""
    if not row:
        return None

    return {
        "prompt_id": row["prompt_id"],
        "title": row["title"],
        "content": row["content"],
        "category_id": row["category_id"],
        "prompt_type": row["prompt_type"],
        "ai_tool": row["ai_tool"],
        "source_name": row["source_name"],
        "source_url": row["source_url"],
        "is_featured": bool(row["is_featured"]),
        "created_at": row["created_at"].isoformat() if row["created_at"] else None,
        "updated_at": row["updated_at"].isoformat() if row["updated_at"] else None,
    }


def validate_prompt_payload(data, is_update=False):
    """Validate JSON input for creating or updating a prompt.

    Returns (cleaned_data, error_message).
    """
    if not isinstance(data, dict):
        return None, "Request body must be a valid JSON object."

    cleaned = {}

    if not is_update:
        # Required fields when creating a new prompt
        for field in ("title", "content", "category_id"):
            if field not in data or data[field] is None:
                return None, f"Missing required field: '{field}'."

    # Validate title and content if present
    for required_text in ("title", "content"):
        if required_text in data:
            value = data[required_text]
            if not isinstance(value, str) or not value.strip():
                return None, f"'{required_text}' must be a non-empty string."
            cleaned[required_text] = value.strip()

    # Validate category_id if present (note: bool is a subclass of int in Python)
    if "category_id" in data:
        cat_id = data["category_id"]
        if isinstance(cat_id, bool) or not isinstance(cat_id, int) or cat_id <= 0:
            return None, "'category_id' must be a positive integer."
        cleaned["category_id"] = cat_id

    # Validate optional string fields
    for field in ("prompt_type", "ai_tool", "source_name", "source_url"):
        if field in data:
            value = data[field]
            if value is not None and not isinstance(value, str):
                return None, f"'{field}' must be a string or null."
            cleaned[field] = value.strip() if isinstance(value, str) else None

    # Check maximum column lengths
    for field, max_len in STRING_LIMITS.items():
        if field in cleaned and cleaned[field] is not None:
            if len(cleaned[field]) > max_len:
                return None, f"'{field}' cannot exceed {max_len} characters."

    # Validate is_featured if present
    if "is_featured" in data:
        if not isinstance(data["is_featured"], bool):
            return None, "'is_featured' must be a boolean (true or false)."
        cleaned["is_featured"] = data["is_featured"]

    if is_update and not cleaned:
        return None, "Provide at least one valid field to update."

    return cleaned, None


def category_exists(cursor, category_id):
    """Check whether a category_id exists in the Categories table."""
    cursor.execute(
        "SELECT category_id FROM Categories WHERE category_id = %s;",
        (category_id,),
    )
    return cursor.fetchone() is not None


@app.route("/test-db", methods=["GET"])
def test_db():
    """Verify that Flask can connect to the MySQL promptvault database."""
    connection = None
    cursor = None

    try:
        # Open a connection to MySQL
        connection = get_db_connection()
        cursor = connection.cursor()

        # Run a simple query to confirm the active database
        cursor.execute("SELECT DATABASE();")
        row = cursor.fetchone()
        active_db = row[0] if row else None

        return jsonify({
            "status": "success",
            "message": "Connected to MySQL database successfully.",
            "database": active_db,
        }), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to connect to MySQL database.",
            "error": str(err),
        }), 500

    finally:
        # Always close cursor and connection to avoid leaking resources
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


def build_prompt_filters(args, require_query=False):
    """Build parameterized SQL WHERE conditions from query string parameters.

    Supports: q (title/content search), category_id, ai_tool, and featured.
    Returns (where_sql, params, error_message).
    """
    conditions = []
    params = []

    # 1. Text search in title or content
    q = args.get("q", "").strip()
    if require_query and not q:
        return None, None, "Search query parameter 'q' cannot be empty."
    if q:
        like_pattern = f"%{q}%"
        conditions.append("(title LIKE %s OR content LIKE %s)")
        params.extend([like_pattern, like_pattern])

    # 2. Filter by category_id
    category_id_raw = args.get("category_id")
    if category_id_raw is not None and category_id_raw.strip() != "":
        try:
            category_id = int(category_id_raw)
            if category_id <= 0:
                raise ValueError
        except ValueError:
            return None, None, "'category_id' must be a positive integer."
        conditions.append("category_id = %s")
        params.append(category_id)

    # 3. Filter by ai_tool
    ai_tool = args.get("ai_tool", "").strip()
    if ai_tool:
        conditions.append("ai_tool = %s")
        params.append(ai_tool)

    # 4. Filter by featured status (true/false)
    featured_raw = args.get("featured")
    if featured_raw is not None and featured_raw.strip() != "":
        featured_lower = featured_raw.strip().lower()
        if featured_lower in ("true", "1"):
            conditions.append("is_featured = %s")
            params.append(True)
        elif featured_lower in ("false", "0"):
            conditions.append("is_featured = %s")
            params.append(False)
        else:
            return None, None, "'featured' must be 'true' or 'false'."

    where_sql = f"WHERE {' AND '.join(conditions)}" if conditions else ""
    return where_sql, params, None


def fetch_prompts_with_filters(require_query=False):
    """Shared handler for listing, filtering, and searching prompts."""
    where_sql, params, error_msg = build_prompt_filters(request.args, require_query=require_query)
    if error_msg:
        return jsonify({"status": "error", "message": error_msg}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        query = f"SELECT * FROM Prompts {where_sql} ORDER BY created_at DESC;"
        cursor.execute(query, tuple(params))
        rows = cursor.fetchall()

        prompts = [serialize_prompt(row) for row in rows]
        return jsonify({"status": "success", "count": len(prompts), "data": prompts}), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve prompts.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/prompts", methods=["GET"])
def get_prompts():
    """Retrieve all prompts, with optional category_id, ai_tool, featured, and q filters."""
    return fetch_prompts_with_filters(require_query=False)


@app.route("/prompts/search", methods=["GET"])
def search_prompts():
    """Search prompts by title or content, optionally combined with filters."""
    return fetch_prompts_with_filters(require_query=True)


@app.route("/prompts/<int:prompt_id>", methods=["GET"])
def get_prompt(prompt_id):
    """Retrieve a single prompt by its ID."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("SELECT * FROM Prompts WHERE prompt_id = %s;", (prompt_id,))
        row = cursor.fetchone()

        if row is None:
            return jsonify({
                "status": "error",
                "message": f"Prompt with id {prompt_id} not found.",
            }), 404

        return jsonify({"status": "success", "data": serialize_prompt(row)}), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve prompt.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/prompts", methods=["POST"])
def create_prompt():
    """Add a new prompt to the Prompts table."""
    data = request.get_json(silent=True)
    cleaned, error_msg = validate_prompt_payload(data, is_update=False)
    if error_msg:
        return jsonify({"status": "error", "message": error_msg}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Ensure the referenced category exists before inserting
        if not category_exists(cursor, cleaned["category_id"]):
            return jsonify({
                "status": "error",
                "message": f"Category with id {cleaned['category_id']} does not exist.",
            }), 400

        insert_query = """
            INSERT INTO Prompts (
                title, content, category_id, prompt_type,
                ai_tool, source_name, source_url, is_featured
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
        """
        values = (
            cleaned["title"],
            cleaned["content"],
            cleaned["category_id"],
            cleaned.get("prompt_type") or "Text",
            cleaned.get("ai_tool") or "Any",
            cleaned.get("source_name"),
            cleaned.get("source_url"),
            cleaned.get("is_featured", False),
        )

        cursor.execute(insert_query, values)
        connection.commit()

        new_id = cursor.lastrowid
        cursor.execute("SELECT * FROM Prompts WHERE prompt_id = %s;", (new_id,))
        created_prompt = cursor.fetchone()

        return jsonify({
            "status": "success",
            "message": "Prompt created successfully.",
            "data": serialize_prompt(created_prompt),
        }), 201

    except Error as err:
        if connection is not None:
            connection.rollback()
        return jsonify({
            "status": "error",
            "message": "Failed to create prompt.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/prompts/<int:prompt_id>", methods=["PUT"])
def update_prompt(prompt_id):
    """Update an existing prompt by its ID."""
    data = request.get_json(silent=True)
    cleaned, error_msg = validate_prompt_payload(data, is_update=True)
    if error_msg:
        return jsonify({"status": "error", "message": error_msg}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Check if the prompt exists
        cursor.execute("SELECT * FROM Prompts WHERE prompt_id = %s;", (prompt_id,))
        if cursor.fetchone() is None:
            return jsonify({
                "status": "error",
                "message": f"Prompt with id {prompt_id} not found.",
            }), 404

        # If category_id is being updated, verify the new category exists
        if "category_id" in cleaned and not category_exists(cursor, cleaned["category_id"]):
            return jsonify({
                "status": "error",
                "message": f"Category with id {cleaned['category_id']} does not exist.",
            }), 400

        # Build a parameterized UPDATE query from the validated fields
        set_clauses = [f"{field} = %s" for field in cleaned]
        values = list(cleaned.values())
        values.append(prompt_id)

        update_query = f"UPDATE Prompts SET {', '.join(set_clauses)} WHERE prompt_id = %s;"
        cursor.execute(update_query, tuple(values))
        connection.commit()

        cursor.execute("SELECT * FROM Prompts WHERE prompt_id = %s;", (prompt_id,))
        updated_prompt = cursor.fetchone()

        return jsonify({
            "status": "success",
            "message": "Prompt updated successfully.",
            "data": serialize_prompt(updated_prompt),
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        return jsonify({
            "status": "error",
            "message": "Failed to update prompt.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/prompts/<int:prompt_id>", methods=["DELETE"])
def delete_prompt(prompt_id):
    """Delete a prompt by its ID."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("DELETE FROM Prompts WHERE prompt_id = %s;", (prompt_id,))
        connection.commit()

        if cursor.rowcount == 0:
            return jsonify({
                "status": "error",
                "message": f"Prompt with id {prompt_id} not found.",
            }), 404

        return jsonify({
            "status": "success",
            "message": f"Prompt with id {prompt_id} deleted successfully.",
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        return jsonify({
            "status": "error",
            "message": "Failed to delete prompt.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/categories", methods=["GET"])
def get_categories():
    """Retrieve all categories from the Categories table."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("SELECT * FROM Categories ORDER BY category_id ASC;")
        rows = cursor.fetchall()

        categories = [serialize_category(row) for row in rows]
        return jsonify({"status": "success", "count": len(categories), "data": categories}), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve categories.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/categories/<int:category_id>", methods=["GET"])
def get_category(category_id):
    """Retrieve a single category by its ID."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("SELECT * FROM Categories WHERE category_id = %s;", (category_id,))
        row = cursor.fetchone()

        if row is None:
            return jsonify({
                "status": "error",
                "message": f"Category with id {category_id} not found.",
            }), 404

        return jsonify({"status": "success", "data": serialize_category(row)}), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve category.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/categories", methods=["POST"])
def create_category():
    """Add a new category to the Categories table."""
    data = request.get_json(silent=True)
    cleaned, error_msg = validate_category_payload(data, is_update=False)
    if error_msg:
        return jsonify({"status": "error", "message": error_msg}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute(
            "INSERT INTO Categories (category_name, description) VALUES (%s, %s);",
            (cleaned["category_name"], cleaned.get("description")),
        )
        connection.commit()

        new_id = cursor.lastrowid
        cursor.execute("SELECT * FROM Categories WHERE category_id = %s;", (new_id,))
        created_category = cursor.fetchone()

        return jsonify({
            "status": "success",
            "message": "Category created successfully.",
            "data": serialize_category(created_category),
        }), 201

    except Error as err:
        if connection is not None:
            connection.rollback()
        # MySQL error 1062: Duplicate entry for UNIQUE category_name
        if err.errno == 1062:
            return jsonify({
                "status": "error",
                "message": f"Category '{cleaned['category_name']}' already exists.",
            }), 409
        return jsonify({
            "status": "error",
            "message": "Failed to create category.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/categories/<int:category_id>", methods=["PUT"])
def update_category(category_id):
    """Update an existing category by its ID."""
    data = request.get_json(silent=True)
    cleaned, error_msg = validate_category_payload(data, is_update=True)
    if error_msg:
        return jsonify({"status": "error", "message": error_msg}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("SELECT * FROM Categories WHERE category_id = %s;", (category_id,))
        if cursor.fetchone() is None:
            return jsonify({
                "status": "error",
                "message": f"Category with id {category_id} not found.",
            }), 404

        set_clauses = [f"{field} = %s" for field in cleaned]
        values = list(cleaned.values())
        values.append(category_id)

        update_query = f"UPDATE Categories SET {', '.join(set_clauses)} WHERE category_id = %s;"
        cursor.execute(update_query, tuple(values))
        connection.commit()

        cursor.execute("SELECT * FROM Categories WHERE category_id = %s;", (category_id,))
        updated_category = cursor.fetchone()

        return jsonify({
            "status": "success",
            "message": "Category updated successfully.",
            "data": serialize_category(updated_category),
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        if err.errno == 1062:
            return jsonify({
                "status": "error",
                "message": f"Category '{cleaned.get('category_name')}' already exists.",
            }), 409
        return jsonify({
            "status": "error",
            "message": "Failed to update category.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/categories/<int:category_id>", methods=["DELETE"])
def delete_category(category_id):
    """Delete a category only if no prompts reference it."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        # Check whether the category exists
        cursor.execute("SELECT category_id FROM Categories WHERE category_id = %s;", (category_id,))
        if cursor.fetchone() is None:
            return jsonify({
                "status": "error",
                "message": f"Category with id {category_id} not found.",
            }), 404

        # Prevent deleting a category that is still used by prompts
        cursor.execute("SELECT COUNT(*) FROM Prompts WHERE category_id = %s;", (category_id,))
        prompt_count = cursor.fetchone()[0]
        if prompt_count > 0:
            return jsonify({
                "status": "error",
                "message": f"Cannot delete category {category_id}: it is used by {prompt_count} prompt(s).",
            }), 409

        cursor.execute("DELETE FROM Categories WHERE category_id = %s;", (category_id,))
        connection.commit()

        return jsonify({
            "status": "success",
            "message": f"Category with id {category_id} deleted successfully.",
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        # MySQL error 1451: Foreign key constraint fails on delete
        if err.errno == 1451:
            return jsonify({
                "status": "error",
                "message": f"Cannot delete category {category_id}: it is referenced by existing prompts.",
            }), 409
        return jsonify({
            "status": "error",
            "message": "Failed to delete category.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


# ---------------------------------------------------------------------------
# Tags & Prompt_Tags Management
# ---------------------------------------------------------------------------

def serialize_tag(row):
    """Convert a Tags row dictionary into a JSON-friendly dictionary."""
    if not row:
        return None

    return {
        "tag_id": row["tag_id"],
        "tag_name": row["tag_name"],
    }


def validate_tag_payload(data):
    """Validate JSON input for creating or updating a tag."""
    if not isinstance(data, dict):
        return None, "Request body must be a valid JSON object."

    if "tag_name" not in data or data["tag_name"] is None:
        return None, "Missing required field: 'tag_name'."

    tag_name = data["tag_name"]
    if not isinstance(tag_name, str) or not tag_name.strip():
        return None, "'tag_name' must be a non-empty string."

    cleaned_name = tag_name.strip()
    if len(cleaned_name) > 100:
        return None, "'tag_name' cannot exceed 100 characters."

    return cleaned_name, None


def prompt_exists(cursor, prompt_id):
    """Check whether a prompt_id exists in the Prompts table."""
    cursor.execute("SELECT prompt_id FROM Prompts WHERE prompt_id = %s;", (prompt_id,))
    return cursor.fetchone() is not None


def tag_exists(cursor, tag_id):
    """Check whether a tag_id exists in the Tags table."""
    cursor.execute("SELECT tag_id FROM Tags WHERE tag_id = %s;", (tag_id,))
    return cursor.fetchone() is not None


@app.route("/tags", methods=["GET"])
def get_tags():
    """Retrieve all available tags."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("SELECT * FROM Tags ORDER BY tag_name ASC;")
        rows = cursor.fetchall()

        tags = [serialize_tag(row) for row in rows]
        return jsonify({"status": "success", "count": len(tags), "data": tags}), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve tags.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/tags", methods=["POST"])
def create_tag():
    """Create a new tag in the Tags table."""
    data = request.get_json(silent=True)
    tag_name, error_msg = validate_tag_payload(data)
    if error_msg:
        return jsonify({"status": "error", "message": error_msg}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("INSERT INTO Tags (tag_name) VALUES (%s);", (tag_name,))
        connection.commit()

        new_id = cursor.lastrowid
        cursor.execute("SELECT * FROM Tags WHERE tag_id = %s;", (new_id,))
        created_tag = cursor.fetchone()

        return jsonify({
            "status": "success",
            "message": "Tag created successfully.",
            "data": serialize_tag(created_tag),
        }), 201

    except Error as err:
        if connection is not None:
            connection.rollback()
        if err.errno == 1062:
            return jsonify({
                "status": "error",
                "message": f"Tag '{tag_name}' already exists.",
            }), 409
        return jsonify({
            "status": "error",
            "message": "Failed to create tag.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/tags/<int:tag_id>", methods=["PUT"])
def update_tag(tag_id):
    """Update an existing tag by its ID."""
    data = request.get_json(silent=True)
    tag_name, error_msg = validate_tag_payload(data)
    if error_msg:
        return jsonify({"status": "error", "message": error_msg}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        if not tag_exists(cursor, tag_id):
            return jsonify({
                "status": "error",
                "message": f"Tag with id {tag_id} not found.",
            }), 404

        cursor.execute(
            "UPDATE Tags SET tag_name = %s WHERE tag_id = %s;",
            (tag_name, tag_id),
        )
        connection.commit()

        cursor.execute("SELECT * FROM Tags WHERE tag_id = %s;", (tag_id,))
        updated_tag = cursor.fetchone()

        return jsonify({
            "status": "success",
            "message": "Tag updated successfully.",
            "data": serialize_tag(updated_tag),
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        if err.errno == 1062:
            return jsonify({
                "status": "error",
                "message": f"Tag '{tag_name}' already exists.",
            }), 409
        return jsonify({
            "status": "error",
            "message": "Failed to update tag.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/tags/<int:tag_id>", methods=["DELETE"])
def delete_tag(tag_id):
    """Delete a tag by its ID (Prompt_Tags rows cascade-delete automatically)."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("DELETE FROM Tags WHERE tag_id = %s;", (tag_id,))
        connection.commit()

        if cursor.rowcount == 0:
            return jsonify({
                "status": "error",
                "message": f"Tag with id {tag_id} not found.",
            }), 404

        return jsonify({
            "status": "success",
            "message": f"Tag with id {tag_id} deleted successfully.",
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        return jsonify({
            "status": "error",
            "message": "Failed to delete tag.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/prompts/<int:prompt_id>/tags", methods=["GET"])
def get_prompt_tags(prompt_id):
    """Retrieve all tags associated with a specific prompt."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        if not prompt_exists(cursor, prompt_id):
            return jsonify({
                "status": "error",
                "message": f"Prompt with id {prompt_id} not found.",
            }), 404

        cursor.execute(
            """
            SELECT t.tag_id, t.tag_name
            FROM Tags t
            INNER JOIN Prompt_Tags pt ON t.tag_id = pt.tag_id
            WHERE pt.prompt_id = %s
            ORDER BY t.tag_name ASC;
            """,
            (prompt_id,),
        )
        rows = cursor.fetchall()

        tags = [serialize_tag(row) for row in rows]
        return jsonify({
            "status": "success",
            "prompt_id": prompt_id,
            "count": len(tags),
            "data": tags,
        }), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve prompt tags.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/prompts/<int:prompt_id>/tags", methods=["POST"])
def assign_tag_to_prompt(prompt_id):
    """Assign an existing tag to a prompt."""
    data = request.get_json(silent=True)
    if not isinstance(data, dict) or "tag_id" not in data or data["tag_id"] is None:
        return jsonify({"status": "error", "message": "Missing required field: 'tag_id'."}), 400

    tag_id = data["tag_id"]
    if isinstance(tag_id, bool) or not isinstance(tag_id, int) or tag_id <= 0:
        return jsonify({"status": "error", "message": "'tag_id' must be a positive integer."}), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        if not prompt_exists(cursor, prompt_id):
            return jsonify({
                "status": "error",
                "message": f"Prompt with id {prompt_id} not found.",
            }), 404

        if not tag_exists(cursor, tag_id):
            return jsonify({
                "status": "error",
                "message": f"Tag with id {tag_id} not found.",
            }), 404

        cursor.execute(
            "INSERT INTO Prompt_Tags (prompt_id, tag_id) VALUES (%s, %s);",
            (prompt_id, tag_id),
        )
        connection.commit()

        return jsonify({
            "status": "success",
            "message": f"Tag {tag_id} assigned to prompt {prompt_id} successfully.",
            "data": {"prompt_id": prompt_id, "tag_id": tag_id},
        }), 201

    except Error as err:
        if connection is not None:
            connection.rollback()
        # MySQL error 1062: Duplicate composite primary key (prompt_id, tag_id)
        if err.errno == 1062:
            return jsonify({
                "status": "error",
                "message": f"Tag {tag_id} is already assigned to prompt {prompt_id}.",
            }), 409
        return jsonify({
            "status": "error",
            "message": "Failed to assign tag to prompt.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/prompts/<int:prompt_id>/tags/<int:tag_id>", methods=["DELETE"])
def remove_tag_from_prompt(prompt_id, tag_id):
    """Remove a tag assignment from a prompt."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        if not prompt_exists(cursor, prompt_id):
            return jsonify({
                "status": "error",
                "message": f"Prompt with id {prompt_id} not found.",
            }), 404

        if not tag_exists(cursor, tag_id):
            return jsonify({
                "status": "error",
                "message": f"Tag with id {tag_id} not found.",
            }), 404

        cursor.execute(
            "DELETE FROM Prompt_Tags WHERE prompt_id = %s AND tag_id = %s;",
            (prompt_id, tag_id),
        )
        connection.commit()

        if cursor.rowcount == 0:
            return jsonify({
                "status": "error",
                "message": f"Tag {tag_id} is not assigned to prompt {prompt_id}.",
            }), 404

        return jsonify({
            "status": "success",
            "message": f"Tag {tag_id} removed from prompt {prompt_id} successfully.",
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        return jsonify({
            "status": "error",
            "message": "Failed to remove tag from prompt.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


# ---------------------------------------------------------------------------
# Favorites Management
# ---------------------------------------------------------------------------

@app.route("/favorites", methods=["GET"])
def get_favorites():
    """Retrieve all favorited prompts."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT p.*, f.favorite_id, f.added_at
            FROM Favorites f
            INNER JOIN Prompts p ON f.prompt_id = p.prompt_id
            ORDER BY f.added_at DESC;
            """
        )
        rows = cursor.fetchall()

        favorites = []
        for row in rows:
            item = serialize_prompt(row)
            item["favorite_id"] = row["favorite_id"]
            item["added_at"] = row["added_at"].isoformat() if row["added_at"] else None
            favorites.append(item)

        return jsonify({
            "status": "success",
            "count": len(favorites),
            "data": favorites,
        }), 200

    except Error as err:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve favorites.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/favorites", methods=["POST"])
def add_favorite():
    """Add an existing prompt to favorites."""
    data = request.get_json(silent=True)
    if not isinstance(data, dict) or "prompt_id" not in data or data["prompt_id"] is None:
        return jsonify({
            "status": "error",
            "message": "Missing required field: 'prompt_id'.",
        }), 400

    prompt_id = data["prompt_id"]
    if isinstance(prompt_id, bool) or not isinstance(prompt_id, int) or prompt_id <= 0:
        return jsonify({
            "status": "error",
            "message": "'prompt_id' must be a positive integer.",
        }), 400

    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Ensure the prompt exists before adding it to favorites
        if not prompt_exists(cursor, prompt_id):
            return jsonify({
                "status": "error",
                "message": f"Prompt with id {prompt_id} not found.",
            }), 404

        cursor.execute(
            "INSERT INTO Favorites (prompt_id) VALUES (%s);",
            (prompt_id,),
        )
        connection.commit()

        new_fav_id = cursor.lastrowid
        cursor.execute(
            "SELECT favorite_id, prompt_id, added_at FROM Favorites WHERE favorite_id = %s;",
            (new_fav_id,),
        )
        fav_row = cursor.fetchone()

        return jsonify({
            "status": "success",
            "message": f"Prompt {prompt_id} added to favorites.",
            "data": {
                "favorite_id": fav_row["favorite_id"],
                "prompt_id": fav_row["prompt_id"],
                "added_at": fav_row["added_at"].isoformat() if fav_row["added_at"] else None,
            },
        }), 201

    except Error as err:
        if connection is not None:
            connection.rollback()
        # MySQL error 1062: Duplicate entry for UNIQUE prompt_id
        if err.errno == 1062:
            return jsonify({
                "status": "error",
                "message": f"Prompt {prompt_id} is already in favorites.",
            }), 409
        return jsonify({
            "status": "error",
            "message": "Failed to add prompt to favorites.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


@app.route("/favorites/<int:prompt_id>", methods=["DELETE"])
def remove_favorite(prompt_id):
    """Remove a prompt from favorites by its prompt_id."""
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("DELETE FROM Favorites WHERE prompt_id = %s;", (prompt_id,))
        connection.commit()

        if cursor.rowcount == 0:
            return jsonify({
                "status": "error",
                "message": f"Prompt {prompt_id} is not in favorites.",
            }), 404

        return jsonify({
            "status": "success",
            "message": f"Prompt {prompt_id} removed from favorites.",
        }), 200

    except Error as err:
        if connection is not None:
            connection.rollback()
        return jsonify({
            "status": "error",
            "message": "Failed to remove prompt from favorites.",
            "error": str(err),
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None and connection.is_connected():
            connection.close()


if __name__ == "__main__":
    app.run(debug=True)
