// PromptVault Add New Prompt Page Script (connected to Flask backend APIs)

const addPromptForm = document.getElementById("addPromptForm");
const promptTitle = document.getElementById("promptTitle");
const promptCategory = document.getElementById("promptCategory");
const promptTool = document.getElementById("promptTool");
const promptType = document.getElementById("promptType");
const promptContent = document.getElementById("promptContent");
const submitBtn = addPromptForm.querySelector('button[type="submit"]');
const formAlert = document.getElementById("formAlert");
const menuToggle = document.getElementById("menuToggle");
const navLinks = document.getElementById("navLinks");

async function populateCategories() {
  try {
    const categories = await fetchCategories();
    promptCategory.innerHTML = '<option value="">Select a category...</option>';
    categories.forEach((cat) => {
      const option = document.createElement("option");
      option.value = String(cat.category_id);
      option.textContent = cat.category_name;
      promptCategory.appendChild(option);
    });
  } catch (err) {
    showAlert("error", `Could not load categories (${err.message}). Make sure Flask is running.`);
  }
}

function showAlert(type, message) {
  formAlert.className = `form-alert ${type === "success" ? "alert-success" : "alert-error"}`;
  formAlert.textContent = message;
  formAlert.hidden = false;
  formAlert.scrollIntoView({ behavior: "smooth", block: "nearest" });
}

function clearAlert() {
  formAlert.hidden = true;
  formAlert.textContent = "";
}

addPromptForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  clearAlert();

  const title = promptTitle.value.trim();
  const categoryId = Number(promptCategory.value);
  const aiTool = promptTool.value.trim();
  const type = promptType.value.trim();
  const content = promptContent.value.trim();

  if (!title) {
    showAlert("error", "Please enter a prompt title.");
    promptTitle.focus();
    return;
  }

  if (title.length > 200) {
    showAlert("error", "Prompt title cannot exceed 200 characters.");
    promptTitle.focus();
    return;
  }

  if (!categoryId || Number.isNaN(categoryId)) {
    showAlert("error", "Please select a category.");
    promptCategory.focus();
    return;
  }

  if (!aiTool) {
    showAlert("error", "Please select an AI tool.");
    promptTool.focus();
    return;
  }

  if (!type) {
    showAlert("error", "Please select a prompt type.");
    promptType.focus();
    return;
  }

  if (!content) {
    showAlert("error", "Please enter the prompt content.");
    promptContent.focus();
    return;
  }

  submitBtn.disabled = true;
  submitBtn.textContent = "Saving...";

  try {
    const created = await createPrompt({
      title,
      content,
      category_id: categoryId,
      ai_tool: aiTool,
      prompt_type: type,
    });
    showAlert("success", `Prompt "${created.title}" saved successfully!`);
    addPromptForm.reset();
  } catch (err) {
    showAlert("error", err.message || "Failed to save prompt.");
  } finally {
    submitBtn.disabled = false;
    submitBtn.textContent = "Submit Prompt";
  }
});

menuToggle.addEventListener("click", () => {
  const isOpen = navLinks.classList.toggle("open");
  menuToggle.setAttribute("aria-expanded", String(isOpen));
});

populateCategories();
