// Shared API client and helpers for PromptVault frontend

const API_BASE_URL = "http://127.0.0.1:5000";

const CATEGORY_ICONS = {
  "Programming & Development": "</>",
  "AI & Automation": "AI",
  "Photo Editing & AI Art": "ART",
  "Students & Education": "EDU",
  "Business & Marketing": "BIZ",
  "Career & Professional": "PRO",
  "Social Media & Content Creation": "SOC",
  "Productivity": "OPS",
};

function getCategoryIcon(categoryName) {
  return CATEGORY_ICONS[categoryName] || "PV";
}

async function apiRequest(path, options = {}) {
  const config = {
    headers: {
      "Content-Type": "application/json",
      ...(options.headers || {}),
    },
    ...options,
  };

  const response = await fetch(`${API_BASE_URL}${path}`, config);
  const payload = await response.json().catch(() => ({}));

  if (!response.ok) {
    const message = payload.message || `Request failed with status ${response.status}.`;
    throw new Error(message);
  }

  return payload;
}

async function fetchCategories() {
  const res = await apiRequest("/categories");
  return res.data || [];
}

async function fetchPrompts(filters = {}) {
  const params = new URLSearchParams();
  if (filters.category_id && filters.category_id !== "All") {
    params.set("category_id", filters.category_id);
  }
  if (filters.ai_tool && filters.ai_tool !== "All") {
    params.set("ai_tool", filters.ai_tool);
  }
  if (filters.featured) {
    params.set("featured", "true");
  }

  const query = filters.q ? filters.q.trim() : "";
  if (query) {
    params.set("q", query);
    const res = await apiRequest(`/prompts/search?${params.toString()}`);
    return res.data || [];
  }

  const qs = params.toString();
  const res = await apiRequest(qs ? `/prompts?${qs}` : "/prompts");
  return res.data || [];
}

async function fetchPromptById(promptId) {
  const res = await apiRequest(`/prompts/${promptId}`);
  return res.data;
}

async function createPrompt(promptData) {
  const res = await apiRequest("/prompts", {
    method: "POST",
    body: JSON.stringify(promptData),
  });
  return res.data;
}

async function updatePrompt(promptId, promptData) {
  const res = await apiRequest(`/prompts/${promptId}`, {
    method: "PUT",
    body: JSON.stringify(promptData),
  });
  return res.data;
}

async function deletePromptById(promptId) {
  return apiRequest(`/prompts/${promptId}`, {
    method: "DELETE",
  });
}

async function fetchPromptTags(promptId) {
  const res = await apiRequest(`/prompts/${promptId}/tags`);
  return res.data || [];
}

async function fetchFavorites() {
  const res = await apiRequest("/favorites");
  return res.data || [];
}

async function addFavorite(promptId) {
  return apiRequest("/favorites", {
    method: "POST",
    body: JSON.stringify({ prompt_id: promptId }),
  });
}

async function removeFavoriteById(promptId) {
  return apiRequest(`/favorites/${promptId}`, {
    method: "DELETE",
  });
}
