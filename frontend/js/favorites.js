// PromptVault Favorites Page Script (connected to Flask backend APIs)

const favoritesGrid = document.getElementById("favoritesGrid");
const favoritesEmpty = document.getElementById("favoritesEmpty");
const favoritesCount = document.getElementById("favoritesCount");
const favToast = document.getElementById("favToast");
const menuToggle = document.getElementById("menuToggle");
const navLinks = document.getElementById("navLinks");

let toastTimer = null;
let categoryMap = {};

function showToast(message) {
  favToast.textContent = message;
  favToast.classList.add("show");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    favToast.classList.remove("show");
  }, 2200);
}

async function handleRemoveFavorite(promptId) {
  try {
    await removeFavoriteById(promptId);
    showToast("Removed from favorites.");
    await loadFavorites();
  } catch (err) {
    showToast(err.message || "Failed to remove favorite.");
  }
}

function renderFavorites(favPrompts) {
  favoritesGrid.innerHTML = "";
  favoritesCount.textContent = `${favPrompts.length} favorite${favPrompts.length === 1 ? "" : "s"}`;
  favoritesEmpty.hidden = favPrompts.length > 0;

  favPrompts.forEach((prompt) => {
    const card = document.createElement("article");
    card.className = "prompt-card";
    const categoryLabel = categoryMap[prompt.category_id] || `Category #${prompt.category_id}`;

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
        <button type="button" class="btn btn-danger-outline btn-sm remove-fav-btn">Remove</button>
      </div>
    `;

    card.querySelector(".tag-badge").textContent = categoryLabel;
    card.querySelector(".tool-badge").textContent = prompt.ai_tool || "Any";
    card.querySelector(".prompt-title-link").textContent = prompt.title;
    card.querySelector(".prompt-content").textContent = prompt.content;
    card.querySelector(".remove-fav-btn").addEventListener("click", () => {
      handleRemoveFavorite(prompt.prompt_id);
    });

    favoritesGrid.appendChild(card);
  });
}

async function loadFavorites() {
  favoritesEmpty.hidden = true;
  favoritesGrid.innerHTML = '<div class="loading-state">Loading favorites...</div>';

  try {
    const [favorites, categories] = await Promise.all([
      fetchFavorites(),
      fetchCategories().catch(() => []),
    ]);

    categoryMap = Object.fromEntries(
      categories.map((c) => [c.category_id, c.category_name])
    );

    renderFavorites(favorites);
  } catch (err) {
    favoritesCount.textContent = "0 favorites";
    favoritesGrid.innerHTML = `<div class="error-state">Could not load favorites (${err.message}). Make sure Flask is running on ${API_BASE_URL}.</div>`;
  }
}

menuToggle.addEventListener("click", () => {
  const isOpen = navLinks.classList.toggle("open");
  menuToggle.setAttribute("aria-expanded", String(isOpen));
});

loadFavorites();
