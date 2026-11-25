// PromptVault Homepage Script (connected to Flask backend APIs)

// UI state
let categoriesList = [];
let categoryNameById = {};
let favoriteIds = new Set();
let selectedCategoryId = "All";
let selectedTool = "All";
let selectedType = "All";
let searchQuery = "";
let searchDebounceTimer = null;

const categoriesGrid = document.getElementById("categoriesGrid");
const promptsGrid = document.getElementById("promptsGrid");
const resultsCount = document.getElementById("resultsCount");
const emptyState = document.getElementById("emptyState");
const emptyMessage = document.getElementById("emptyMessage");
const resetCategoryBtn = document.getElementById("resetCategoryBtn");
const clearFiltersBtn = document.getElementById("clearFiltersBtn");
const clearFiltersBarBtn = document.getElementById("clearFiltersBarBtn");
const categoryFilter = document.getElementById("categoryFilter");
const toolFilter = document.getElementById("toolFilter");
const typeFilter = document.getElementById("typeFilter");
const searchForm = document.getElementById("searchForm");
const searchInput = document.getElementById("searchInput");
const toolFilters = document.getElementById("toolFilters");
const menuToggle = document.getElementById("menuToggle");
const navLinks = document.getElementById("navLinks");
const copyToast = document.getElementById("copyToast");

let toastTimer = null;

function showToast(message) {
  copyToast.textContent = message;
  copyToast.classList.add("show");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    copyToast.classList.remove("show");
  }, 2200);
}

function showLoading(container, text) {
  container.innerHTML = `<div class="loading-state">${text}</div>`;
}

function showError(container, message) {
  container.innerHTML = `<div class="error-state">${message}</div>`;
}

function populateCategoryDropdown() {
  categoryFilter.innerHTML = '<option value="All">All Categories</option>';
  categoriesList.forEach((cat) => {
    const option = document.createElement("option");
    option.value = String(cat.category_id);
    option.textContent = cat.category_name;
    categoryFilter.appendChild(option);
  });
}

function populatePromptFilterDropdowns(prompts) {
  const currentTool = selectedTool;
  const currentType = selectedType;

  const tools = [...new Set(["ChatGPT", "Claude", "Gemini", "Midjourney", ...prompts.map((p) => p.ai_tool).filter(Boolean)])].sort();
  toolFilter.innerHTML = '<option value="All">All AI Tools</option>';
  tools.forEach((tool) => {
    const option = document.createElement("option");
    option.value = tool;
    option.textContent = tool;
    toolFilter.appendChild(option);
  });
  toolFilter.value = tools.includes(currentTool) ? currentTool : "All";

  const types = [...new Set(["Text", "Code", "Debug", "System", "Workflow", "Image", "Study", "Copywriting", "Career", "Social", "Productivity", ...prompts.map((p) => p.prompt_type).filter(Boolean)])].sort();
  typeFilter.innerHTML = '<option value="All">All Prompt Types</option>';
  types.forEach((type) => {
    const option = document.createElement("option");
    option.value = type;
    option.textContent = type;
    typeFilter.appendChild(option);
  });
  typeFilter.value = types.includes(currentType) ? currentType : "All";
}

function syncFilterControls() {
  categoryFilter.value = String(selectedCategoryId);
  toolFilter.value = selectedTool;
  typeFilter.value = selectedType;
  resetCategoryBtn.hidden = selectedCategoryId === "All";

  document.querySelectorAll(".filter-pill").forEach((pill) => {
    pill.classList.toggle("active", pill.dataset.tool === selectedTool);
  });

  const hasActiveFilters =
    selectedCategoryId !== "All" ||
    selectedTool !== "All" ||
    selectedType !== "All" ||
    searchQuery.trim() !== "";

  clearFiltersBarBtn.hidden = !hasActiveFilters;
}

function renderCategories() {
  categoriesGrid.innerHTML = "";

  if (categoriesList.length === 0) {
    categoriesGrid.innerHTML = '<div class="loading-state">No categories found in database.</div>';
    return;
  }

  categoriesList.forEach((cat) => {
    const card = document.createElement("button");
    card.type = "button";
    card.className = "category-card";
    if (String(selectedCategoryId) === String(cat.category_id)) {
      card.classList.add("active");
    }

    card.innerHTML = `
      <div class="category-icon">${getCategoryIcon(cat.category_name)}</div>
      <h3 class="category-name"></h3>
      <p class="category-desc"></p>
    `;

    card.querySelector(".category-name").textContent = cat.category_name;
    card.querySelector(".category-desc").textContent = cat.description || "";

    card.addEventListener("click", () => {
      const catId = String(cat.category_id);
      selectedCategoryId = selectedCategoryId === catId ? "All" : catId;
      syncFilterControls();
      renderCategories();
      loadPrompts();
      document.getElementById("featured").scrollIntoView({ behavior: "smooth" });
    });

    categoriesGrid.appendChild(card);
  });
}

function renderPrompts(prompts) {
  // Apply prompt_type filter on the returned list (backend filters q, category_id, ai_tool)
  const filtered =
    selectedType === "All"
      ? prompts
      : prompts.filter((p) => p.prompt_type === selectedType);

  promptsGrid.innerHTML = "";
  resultsCount.textContent = `${filtered.length} prompt${filtered.length === 1 ? "" : "s"}`;
  emptyState.hidden = filtered.length > 0;

  if (filtered.length === 0) {
    emptyMessage.textContent = searchQuery.trim()
      ? `No prompts match "${searchQuery.trim()}" with the selected filters.`
      : "No prompts found. Try adjusting your filters or adding a new prompt.";
    return;
  }

  filtered.forEach((prompt) => {
    const card = document.createElement("article");
    card.className = "prompt-card";
    const categoryLabel = categoryNameById[prompt.category_id] || `Category #${prompt.category_id}`;
    const favorited = favoriteIds.has(prompt.prompt_id);

    card.innerHTML = `
      <div class="prompt-meta">
        <span class="tag-badge"></span>
        <span class="tool-badge"></span>
      </div>
      <h3 class="prompt-title">
        <a href="prompt.html?id=${prompt.prompt_id}" class="prompt-title-link"></a>
      </h3>
      <p class="prompt-content"></p>
      <div class="prompt-footer">
        <a href="prompt.html?id=${prompt.prompt_id}" class="prompt-details-link">View Details &rarr;</a>
        <div class="prompt-actions">
          <button type="button" class="btn btn-secondary btn-sm fav-toggle-btn ${favorited ? "is-fav" : ""}" aria-label="Toggle favorite">
            ${favorited ? "&#9733; Saved" : "&#9734; Save"}
          </button>
          <button type="button" class="btn btn-secondary copy-btn">Copy Prompt</button>
        </div>
      </div>
    `;

    card.querySelector(".tag-badge").textContent = categoryLabel;
    card.querySelector(".tool-badge").textContent = prompt.ai_tool || "Any";
    card.querySelector(".prompt-title-link").textContent = prompt.title;
    card.querySelector(".prompt-content").textContent = prompt.content;

    const favBtn = card.querySelector(".fav-toggle-btn");
    favBtn.addEventListener("click", async () => {
      favBtn.disabled = true;
      try {
        if (favoriteIds.has(prompt.prompt_id)) {
          await removeFavoriteById(prompt.prompt_id);
          favoriteIds.delete(prompt.prompt_id);
          favBtn.classList.remove("is-fav");
          favBtn.innerHTML = "&#9734; Save";
          showToast("Removed from favorites.");
        } else {
          await addFavorite(prompt.prompt_id);
          favoriteIds.add(prompt.prompt_id);
          favBtn.classList.add("is-fav");
          favBtn.innerHTML = "&#9733; Saved";
          showToast("Added to favorites!");
        }
      } catch (err) {
        showToast(err.message || "Could not update favorite.");
      } finally {
        favBtn.disabled = false;
      }
    });

    const copyBtn = card.querySelector(".copy-btn");
    copyBtn.addEventListener("click", async () => {
      try {
        await navigator.clipboard.writeText(prompt.content);
        copyBtn.textContent = "Copied!";
        copyBtn.classList.add("copied");
        showToast("Prompt copied to clipboard!");
        setTimeout(() => {
          copyBtn.textContent = "Copy Prompt";
          copyBtn.classList.remove("copied");
        }, 1600);
      } catch {
        showToast("Could not copy automatically. Please copy manually.");
      }
    });

    promptsGrid.appendChild(card);
  });
}

async function loadPrompts() {
  emptyState.hidden = true;
  showLoading(promptsGrid, "Loading prompts...");

  try {
    const prompts = await fetchPrompts({
      q: searchQuery,
      category_id: selectedCategoryId,
      ai_tool: selectedTool,
    });
    populatePromptFilterDropdowns(prompts);
    renderPrompts(prompts);
  } catch (err) {
    resultsCount.textContent = "0 prompts";
    showError(
      promptsGrid,
      `Could not load prompts from backend (${err.message}). Make sure Flask is running on ${API_BASE_URL}.`
    );
  }
}

function resetAllFilters() {
  selectedCategoryId = "All";
  selectedTool = "All";
  selectedType = "All";
  searchQuery = "";
  searchInput.value = "";
  syncFilterControls();
  renderCategories();
  loadPrompts();
}

// Event listeners
searchForm.addEventListener("submit", (event) => {
  event.preventDefault();
  searchQuery = searchInput.value;
  syncFilterControls();
  loadPrompts();
  document.getElementById("featured").scrollIntoView({ behavior: "smooth" });
});

searchInput.addEventListener("input", () => {
  searchQuery = searchInput.value;
  syncFilterControls();
  clearTimeout(searchDebounceTimer);
  searchDebounceTimer = setTimeout(loadPrompts, 250);
});

toolFilters.addEventListener("click", (event) => {
  const pill = event.target.closest(".filter-pill");
  if (!pill) return;

  selectedTool = pill.dataset.tool;
  syncFilterControls();
  loadPrompts();
});

categoryFilter.addEventListener("change", () => {
  selectedCategoryId = categoryFilter.value;
  syncFilterControls();
  renderCategories();
  loadPrompts();
});

toolFilter.addEventListener("change", () => {
  selectedTool = toolFilter.value;
  syncFilterControls();
  loadPrompts();
});

typeFilter.addEventListener("change", () => {
  selectedType = typeFilter.value;
  syncFilterControls();
  loadPrompts();
});

resetCategoryBtn.addEventListener("click", () => {
  selectedCategoryId = "All";
  syncFilterControls();
  renderCategories();
  loadPrompts();
});

clearFiltersBtn.addEventListener("click", resetAllFilters);
clearFiltersBarBtn.addEventListener("click", resetAllFilters);

menuToggle.addEventListener("click", () => {
  const isOpen = navLinks.classList.toggle("open");
  menuToggle.setAttribute("aria-expanded", String(isOpen));
});

async function initHomepage() {
  showLoading(categoriesGrid, "Loading categories...");
  showLoading(promptsGrid, "Loading prompts...");

  try {
    const [categories, favorites] = await Promise.all([
      fetchCategories(),
      fetchFavorites().catch(() => []),
    ]);

    categoriesList = categories;
    categoryNameById = Object.fromEntries(
      categories.map((c) => [c.category_id, c.category_name])
    );
    favoriteIds = new Set(favorites.map((f) => f.prompt_id));

    populateCategoryDropdown();
    syncFilterControls();
    renderCategories();
  } catch (err) {
    showError(
      categoriesGrid,
      `Could not load categories (${err.message}). Make sure Flask is running on ${API_BASE_URL}.`
    );
  }

  await loadPrompts();
}

initHomepage();
