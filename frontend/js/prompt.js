// PromptVault Prompt Details Page Script (connected to Flask backend APIs)

const detailCard = document.getElementById("detailCard");
const notFoundState = document.getElementById("notFoundState");
const detailCategory = document.getElementById("detailCategory");
const detailTool = document.getElementById("detailTool");
const detailType = document.getElementById("detailType");
const detailTitle = document.getElementById("detailTitle");
const detailContent = document.getElementById("detailContent");
const detailTags = document.getElementById("detailTags");
const copyPromptBtn = document.getElementById("copyPromptBtn");
const favPromptBtn = document.getElementById("favPromptBtn");
const editPromptBtn = document.getElementById("editPromptBtn");
const deletePromptBtn = document.getElementById("deletePromptBtn");
const editFormCard = document.getElementById("editFormCard");
const editPromptForm = document.getElementById("editPromptForm");
const editAlert = document.getElementById("editAlert");
const editTitle = document.getElementById("editTitle");
const editCategory = document.getElementById("editCategory");
const editTool = document.getElementById("editTool");
const editType = document.getElementById("editType");
const editContent = document.getElementById("editContent");
const cancelEditBtn = document.getElementById("cancelEditBtn");
const saveEditBtn = document.getElementById("saveEditBtn");
const copyToast = document.getElementById("copyToast");
const menuToggle = document.getElementById("menuToggle");
const navLinks = document.getElementById("navLinks");

let toastTimer = null;
let currentPrompt = null;
let currentCategories = [];
let isSaved = false;

function showToast(message) {
  copyToast.textContent = message;
  copyToast.classList.add("show");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    copyToast.classList.remove("show");
  }, 2200);
}

function showEditAlert(type, message) {
  editAlert.className = `form-alert ${type === "success" ? "alert-success" : "alert-error"}`;
  editAlert.textContent = message;
  editAlert.hidden = false;
}

function updateFavButton(saved) {
  favPromptBtn.classList.toggle("is-fav", saved);
  favPromptBtn.innerHTML = saved ? "&#9733; Saved in Favorites" : "&#9734; Add to Favorites";
}

function renderTags(tags) {
  if (!tags || tags.length === 0) {
    detailTags.hidden = true;
    return;
  }

  detailTags.innerHTML = '<span class="detail-tags-label">Tags:</span>';
  tags.forEach((tag) => {
    const span = document.createElement("span");
    span.className = "tool-badge";
    span.textContent = `#${tag.tag_name}`;
    detailTags.appendChild(span);
  });
  detailTags.hidden = false;
}

function renderPromptView(prompt) {
  const categoryMap = Object.fromEntries(
    currentCategories.map((c) => [c.category_id, c.category_name])
  );

  document.title = `${prompt.title} — PromptVault`;
  detailCategory.textContent = categoryMap[prompt.category_id] || `Category #${prompt.category_id}`;
  detailTool.textContent = `AI Tool: ${prompt.ai_tool || "Any"}`;
  detailType.textContent = `Type: ${prompt.prompt_type || "Text"}`;
  detailTitle.textContent = prompt.title;
  detailContent.textContent = prompt.content;
}

function populateEditForm(prompt) {
  editCategory.innerHTML = "";
  currentCategories.forEach((cat) => {
    const option = document.createElement("option");
    option.value = String(cat.category_id);
    option.textContent = cat.category_name;
    editCategory.appendChild(option);
  });

  editTitle.value = prompt.title;
  editCategory.value = String(prompt.category_id);
  editTool.value = prompt.ai_tool || "Any";
  editType.value = prompt.prompt_type || "Text";
  editContent.value = prompt.content;
  editAlert.hidden = true;
}

async function loadPromptDetails() {
  const params = new URLSearchParams(window.location.search);
  const idParam = params.get("id");

  if (!idParam || Number.isNaN(Number(idParam))) {
    detailCard.hidden = true;
    notFoundState.hidden = false;
    return;
  }

  const promptId = Number(idParam);

  try {
    const [prompt, categories, tags, favorites] = await Promise.all([
      fetchPromptById(promptId),
      fetchCategories().catch(() => []),
      fetchPromptTags(promptId).catch(() => []),
      fetchFavorites().catch(() => []),
    ]);

    currentPrompt = prompt;
    currentCategories = categories;
    isSaved = favorites.some((fav) => fav.prompt_id === prompt.prompt_id);

    renderPromptView(prompt);
    renderTags(tags);
    updateFavButton(isSaved);
  } catch {
    detailCard.hidden = true;
    notFoundState.hidden = false;
  }
}

favPromptBtn.addEventListener("click", async () => {
  if (!currentPrompt) return;
  favPromptBtn.disabled = true;
  try {
    if (isSaved) {
      await removeFavoriteById(currentPrompt.prompt_id);
      isSaved = false;
      showToast("Removed from favorites.");
    } else {
      await addFavorite(currentPrompt.prompt_id);
      isSaved = true;
      showToast("Added to favorites!");
    }
    updateFavButton(isSaved);
  } catch (err) {
    showToast(err.message || "Could not update favorite.");
  } finally {
    favPromptBtn.disabled = false;
  }
});

copyPromptBtn.addEventListener("click", async () => {
  if (!currentPrompt) return;
  try {
    await navigator.clipboard.writeText(currentPrompt.content);
    copyPromptBtn.textContent = "Copied!";
    copyPromptBtn.classList.add("copied");
    showToast("Prompt copied to clipboard!");
    setTimeout(() => {
      copyPromptBtn.textContent = "Copy Prompt";
      copyPromptBtn.classList.remove("copied");
    }, 1800);
  } catch {
    showToast("Could not copy automatically. Please copy manually.");
  }
});

editPromptBtn.addEventListener("click", () => {
  if (!currentPrompt) return;
  populateEditForm(currentPrompt);
  editFormCard.hidden = false;
  editFormCard.scrollIntoView({ behavior: "smooth" });
});

cancelEditBtn.addEventListener("click", () => {
  editFormCard.hidden = true;
});

editPromptForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!currentPrompt) return;
  editAlert.hidden = true;

  const title = editTitle.value.trim();
  const categoryId = Number(editCategory.value);
  const aiTool = editTool.value.trim();
  const promptType = editType.value.trim();
  const content = editContent.value.trim();

  if (!title) {
    showEditAlert("error", "Prompt title is required.");
    editTitle.focus();
    return;
  }
  if (!categoryId || Number.isNaN(categoryId)) {
    showEditAlert("error", "Please select a valid category.");
    editCategory.focus();
    return;
  }
  if (!content) {
    showEditAlert("error", "Prompt content cannot be empty.");
    editContent.focus();
    return;
  }

  saveEditBtn.disabled = true;
  saveEditBtn.textContent = "Saving...";

  try {
    const updated = await updatePrompt(currentPrompt.prompt_id, {
      title,
      content,
      category_id: categoryId,
      ai_tool: aiTool,
      prompt_type: promptType,
    });
    currentPrompt = updated;
    renderPromptView(updated);
    editFormCard.hidden = true;
    showToast("Prompt updated successfully!");
  } catch (err) {
    showEditAlert("error", err.message || "Failed to update prompt.");
  } finally {
    saveEditBtn.disabled = false;
    saveEditBtn.textContent = "Save Changes";
  }
});

deletePromptBtn.addEventListener("click", async () => {
  if (!currentPrompt) return;
  const confirmed = window.confirm(
    `Are you sure you want to delete "${currentPrompt.title}"? This cannot be undone.`
  );
  if (!confirmed) return;

  deletePromptBtn.disabled = true;
  deletePromptBtn.textContent = "Deleting...";

  try {
    await deletePromptById(currentPrompt.prompt_id);
    showToast("Prompt deleted! Redirecting...");
    setTimeout(() => {
      window.location.href = "index.html";
    }, 900);
  } catch (err) {
    showToast(err.message || "Failed to delete prompt.");
    deletePromptBtn.disabled = false;
    deletePromptBtn.textContent = "Delete";
  }
});

menuToggle.addEventListener("click", () => {
  const isOpen = navLinks.classList.toggle("open");
  menuToggle.setAttribute("aria-expanded", String(isOpen));
});

loadPromptDetails();
