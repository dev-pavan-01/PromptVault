USE promptvault;

-- Initial 112 curated prompts across all 8 categories.
-- Note: Run database/categories.sql first so all 8 categories exist in Categories.

-- ============================================================================
-- 1. Programming & Development (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'Senior Code Reviewer',
    'Act as a senior software engineer. Review the following [LANGUAGE] code for bugs, security vulnerabilities, edge cases, readability, and performance bottlenecks. Group your findings by Critical, Warning, and Suggestion, and provide corrected code snippets for each issue.\n\nCode:\n[PASTE CODE]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'Claude',
    'prompts.chat',
    'https://prompts.chat',
    TRUE
),
(
    'Step-by-Step Bug Root Cause Analyzer',
    'I am encountering the following error in my [FRAMEWORK/LANGUAGE] project:\n\nError:\n[PASTE ERROR]\n\nRelevant code:\n[PASTE CODE]\n\nExplain the exact root cause, why it happens, and give me a minimal fix without breaking existing behavior.',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Debug',
    'ChatGPT',
    NULL,
    NULL,
    TRUE
),
(
    'MySQL Query Optimizer & Index Advisor',
    'Analyze this MySQL query and table schema. Identify full table scans, missing indexes, or inefficient joins. Rewrite the query for better performance and suggest exact CREATE INDEX statements with an explanation of how each index helps.\n\nSchema:\n[PASTE SCHEMA]\n\nQuery:\n[PASTE QUERY]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'ChatGPT',
    'GitHub Awesome ChatGPT Prompts',
    'https://github.com/f/awesome-chatgpt-prompts',
    FALSE
),
(
    'REST API Endpoint Designer',
    'Design a clean, RESTful API for a [APP DOMAIN] feature. List the HTTP methods, route paths, request body schemas, response payloads, and appropriate HTTP status codes (200, 201, 400, 404, 409, 500) for each operation.',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Unit Test Suite Generator',
    'Write comprehensive unit tests for the following [LANGUAGE] function using [TEST FRAMEWORK, e.g., pytest/Jest]. Include happy-path tests, boundary conditions, null/empty inputs, and error-handling tests.\n\nFunction:\n[PASTE CODE]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'GitHub Copilot',
    NULL,
    NULL,
    FALSE
),
(
    'Legacy Code Refactoring Assistant',
    'Refactor this legacy [LANGUAGE] function to improve maintainability and reduce nesting without changing its external behavior. Extract well-named helper functions, remove duplicated logic, and add concise docstrings.\n\nCode:\n[PASTE CODE]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Regex Pattern Builder & Explainer',
    'Create a regular expression in [LANGUAGE] that matches [DESCRIBE PATTERN]. Provide 5 valid test strings, 5 invalid test strings, and a token-by-token breakdown explaining how the regex works.',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'Any',
    'prompts.chat',
    'https://prompts.chat',
    FALSE
),
(
    'Git Commit & PR Description Writer',
    'Based on the following git diff or summary of changes, write a concise Conventional Commit message and a clear Pull Request description with sections for Summary, Changes Made, and How to Test.\n\nChanges:\n[PASTE DIFF OR NOTES]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Text',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Database Normalization Checker',
    'Review this relational database schema and evaluate whether it satisfies 1NF, 2NF, and 3NF. Point out any data redundancy, update anomalies, or missing foreign-key constraints, and suggest improved CREATE TABLE statements.\n\nSchema:\n[PASTE SQL]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Docker & Compose Troubleshooting Guide',
    'My Docker container for [TECH STACK] fails with the output below. Inspect my Dockerfile and docker-compose.yml, identify networking, volume, or build-context issues, and provide the corrected configuration.\n\nDockerfile:\n[PASTE DOCKERFILE]\n\nLogs:\n[PASTE LOGS]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Debug',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Time & Space Complexity Analyzer',
    'Analyze the time and space complexity (Big-O) of the following algorithm in both average and worst-case scenarios. If it can be optimized further, show an improved implementation and compare the trade-offs.\n\nCode:\n[PASTE CODE]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'Any',
    'GitHub Awesome ChatGPT Prompts',
    'https://github.com/f/awesome-chatgpt-prompts',
    FALSE
),
(
    'Frontend Responsive Layout Builder',
    'Create a clean, accessible, responsive [COMPONENT, e.g., navbar/card grid/modal] using semantic HTML and modern CSS (Flexbox/Grid). Ensure keyboard navigation, ARIA attributes, and mobile-first breakpoints without external CSS frameworks.',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'API Security & Input Validation Audit',
    'Audit this backend endpoint for common OWASP risks including SQL injection, broken access control, missing input validation, and sensitive data exposure. Show exact fixes using parameterized queries and strict validation.\n\nEndpoint:\n[PASTE CODE]',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Code',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Technical Architecture Trade-Off Comparison',
    'Compare [OPTION A] vs [OPTION B] for a [PROJECT TYPE] with [EXPECTED SCALE/CONSTRAINTS]. Evaluate performance, developer learning curve, operational cost, and maintainability, then recommend the best fit.',
    (SELECT category_id FROM Categories WHERE category_name = 'Programming & Development'),
    'Text',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
);

-- ============================================================================
-- 2. AI & Automation (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'System Prompt Architect',
    'Design a production-ready system prompt for an AI assistant whose role is [ROLE]. Define its persona, strict boundaries, tone, output format (JSON/Markdown), fallback behavior when uncertain, and 2 few-shot examples.',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'System',
    'Claude',
    'FlowGPT',
    'https://flowgpt.com',
    TRUE
),
(
    'Workflow Automation Blueprint (n8n / Zapier)',
    'Design an end-to-end automation workflow that triggers when [TRIGGER EVENT], processes data using [LOGIC/AI STEP], and sends output to [DESTINATION APP]. List every node, required API credentials, error-handling branch, and rate-limit precaution.',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Workflow',
    'ChatGPT',
    NULL,
    NULL,
    TRUE
),
(
    'JSON Schema Structured Output Enforcer',
    'Convert the following unstructured text into a strict JSON object matching this exact schema: [PASTE JSON SCHEMA]. Do not include markdown fences or extra commentary. If a field is missing in the source text, set it to null.\n\nText:\n[PASTE TEXT]',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'System',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Prompt Optimizer & Clarity Refiner',
    'Rewrite and upgrade my draft prompt below to make it clearer, more specific, and less prone to hallucination. Add role framing, explicit constraints, and output formatting instructions, then explain what you improved.\n\nDraft Prompt:\n[PASTE PROMPT]',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Text',
    'Any',
    'FlowGPT',
    'https://flowgpt.com',
    FALSE
),
(
    'RAG Chunking & Retrieval Strategy Designer',
    'I am building a Retrieval-Augmented Generation (RAG) pipeline for [DOCUMENT TYPE, e.g., PDFs/support tickets]. Recommend the optimal chunk size, overlap, metadata fields, embedding strategy, and reranking steps to maximize answer accuracy.',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Workflow',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Email Triage & Auto-Drafting Agent',
    'Read the incoming customer email below and: 1) Classify intent (Billing, Bug, Feature Request, General), 2) Rate urgency (Low, Medium, High), 3) Extract key entities, and 4) Draft a polite, concise reply.\n\nEmail:\n[PASTE EMAIL]',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Workflow',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Few-Shot Classification Prompt Builder',
    'Create a few-shot classification prompt that categorizes [INPUT TYPE] into these labels: [LIST LABELS]. Include 2 diverse, unambiguous examples per label and instructions for handling edge cases.',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'System',
    'Any',
    'prompts.chat',
    'https://prompts.chat',
    FALSE
),
(
    'AI Agent Tool-Use Specification Writer',
    'Write clear function/tool definitions (name, description, JSON parameter schema, and edge-case rules) for an AI agent that needs to interact with [API OR DATABASE]. Ensure parameter descriptions prevent ambiguous tool calls.',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Code',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Python Web Scraping to CSV Pipeline',
    'Write a beginner-friendly Python script using requests and BeautifulSoup that fetches [TARGET DATA] from a local or permitted HTML page, cleans whitespace, handles missing tags gracefully, and exports rows to a UTF-8 CSV file.',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Code',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'LLM Evaluation Rubric & Test Cases',
    'Create an evaluation rubric (1-5 scale across Accuracy, Completeness, Tone, and Format) plus 10 adversarial and normal test cases to benchmark an AI assistant built for [USE CASE].',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Text',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Meeting Transcript to Action Tracker',
    'Parse this raw meeting transcript and output: 1) Decisions Made, 2) Action Items (Owner, Task, Deadline), and 3) Open Questions. Ignore small talk and keep each bullet under 20 words.\n\nTranscript:\n[PASTE TRANSCRIPT]',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Workflow',
    'Gemini',
    NULL,
    NULL,
    FALSE
),
(
    'Chain-of-Thought Reasoning Template',
    'Solve the following multi-step problem by breaking it down explicitly: first list known facts, second identify constraints, third work through each calculation or logical step, and finally state the verified conclusion.\n\nProblem:\n[PASTE PROBLEM]',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Text',
    'Any',
    'GitHub Awesome ChatGPT Prompts',
    'https://github.com/f/awesome-chatgpt-prompts',
    FALSE
),
(
    'Chatbot Guardrails & Safety Checklist',
    'Review this customer-facing chatbot prompt for prompt-injection risks, off-topic drift, and unintended commitments (such as unauthorized refunds). Provide hardened instructions to enforce safe boundaries.\n\nPrompt:\n[PASTE PROMPT]',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'System',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Daily Automated Digest Summarizer',
    'Given a list of [NEWS ARTICLES / GITHUB ISSUES / LOGS], group them by theme, highlight the top 3 items requiring immediate attention, and write a 150-word executive summary.\n\nItems:\n[PASTE ITEMS]',
    (SELECT category_id FROM Categories WHERE category_name = 'AI & Automation'),
    'Workflow',
    'Gemini',
    NULL,
    NULL,
    FALSE
);

-- ============================================================================
-- 3. Photo Editing & AI Art (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'Cinematic Golden Hour Portrait',
    'Ultra-detailed portrait of [SUBJECT], warm golden hour sunlight, soft rim lighting, shallow depth of field, 85mm lens f/1.4, natural skin texture, film grain, Kodak Portra 400 color palette, photorealistic --ar 4:5',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Midjourney',
    'PromptHero',
    'https://prompthero.com',
    TRUE
),
(
    'Minimalist Studio Product Photography',
    'Commercial product photo of [PRODUCT] centered on a matte [COLOR] pedestal, soft diffused studio softbox lighting, subtle contact shadow, crisp reflections, clean uncluttered background, 8k resolution, advertising photography style',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'DALL-E',
    'PromptHero',
    'https://prompthero.com',
    TRUE
),
(
    'Isometric 3D App Icon & UI Illustration',
    'Clean 3D isometric illustration of [OBJECT/CONCEPT], soft pastel gradient palette, smooth clay-render material, gentle ambient occlusion, floating on a pure white background, modern SaaS hero graphic style',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Midjourney',
    NULL,
    NULL,
    FALSE
),
(
    'Cyberpunk Rainy Neon Street Scene',
    'Wide-angle street view of a futuristic Tokyo alley at night in heavy rain, glowing cyan and magenta neon signs reflecting on wet asphalt, atmospheric mist, lone silhouette with umbrella, cinematic blade runner lighting --ar 16:9',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Stable Diffusion',
    'PromptHero',
    'https://prompthero.com',
    FALSE
),
(
    'Vintage Watercolor Travel Postcard',
    'Hand-painted watercolor and ink illustration of [LANDMARK/CITY], loose expressive brush strokes, warm sunlit washes, textured cold-press cotton paper visible, charming editorial travel magazine aesthetic',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'DALL-E',
    NULL,
    NULL,
    FALSE
),
(
    'Lightroom Color Grading Recipe Generator',
    'Suggest exact Adobe Lightroom Classic slider values (Exposure, Contrast, Highlights, Shadows, Whites, Blacks, Temp, Tint, HSL, and Color Grading wheels) to achieve a [MOOD, e.g., moody dark teal / airy pastel] look for a [PHOTO TYPE, e.g., indoor portrait].',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Text',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Flat Vector Mascot Logo Concept',
    'Minimalist flat vector logo of a [ANIMAL OR SYMBOL], bold geometric shapes, 2-color palette ([COLOR 1] and [COLOR 2]), clean negative space, centered on solid white background, scalable brand mark, no gradients, no text',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Midjourney',
    NULL,
    NULL,
    FALSE
),
(
    'Double Exposure Nature Silhouette',
    'Artistic double exposure photograph combining the side-profile silhouette of [SUBJECT] with a misty pine forest and mountain sunrise inside the silhouette, clean off-white background, high contrast, fine art print style',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Stable Diffusion',
    'PromptHero',
    'https://prompthero.com',
    FALSE
),
(
    'Photoshop Non-Destructive Retouching Steps',
    'Give me a step-by-step Adobe Photoshop workflow to remove [UNWANTED OBJECT/BLEMISH] and balance uneven lighting in a [PORTRAIT/LANDSCAPE] photo using non-destructive adjustment layers, masks, and frequency separation.',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Text',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Architectural Interior Daylight Render',
    'Scandinavian minimalist living room interior, floor-to-ceiling windows with soft morning sunlight casting crisp shadows on oak hardwood floors, neutral linen sofa, indoor olive tree, Architectural Digest photography style',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Midjourney',
    NULL,
    NULL,
    FALSE
),
(
    'Pixel Art 16-Bit Game Sprite Sheet',
    '16-bit retro pixel art character sprite of a [CHARACTER, e.g., cyberpunk courier], crisp pixel edges, limited 16-color palette, idle and walking poses, neutral gray background, classic SNES RPG aesthetic',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'DALL-E',
    NULL,
    NULL,
    FALSE
),
(
    'Food Photography Overhead Flatlay',
    'Overhead flatlay food photography of [DISH] served in a handmade ceramic bowl on a dark rustic wooden table, fresh herbs scattered naturally, soft directional window light from the left, appetizing steam, 50mm lens',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Midjourney',
    'PromptHero',
    'https://prompthero.com',
    FALSE
),
(
    'Negative Prompt Pack for Photorealism',
    'Provide a clean, well-organized negative prompt list for Stable Diffusion to avoid common artifacts (extra fingers, distorted faces, plastic skin, watermarks, blurry edges) when generating [SUBJECT TYPE].',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'Stable Diffusion',
    NULL,
    NULL,
    FALSE
),
(
    'YouTube Thumbnail High-Contrast Concept',
    'Eye-catching YouTube thumbnail background showing [SCENE/CONCEPT], dramatic split lighting (warm orange vs cool blue), clean empty space on the left third for bold text overlay, crisp focus, high visual contrast --ar 16:9',
    (SELECT category_id FROM Categories WHERE category_name = 'Photo Editing & AI Art'),
    'Image',
    'DALL-E',
    NULL,
    NULL,
    FALSE
);

-- ============================================================================
-- 4. Students & Education (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'Feynman Technique Concept Explainer',
    'Explain [COMPLEX TOPIC] to me as if I am a first-year college student. Use a simple real-world analogy, avoid unexplained jargon, walk through one concrete example, and then ask me 2 check-for-understanding questions.',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Any',
    'prompts.chat',
    'https://prompts.chat',
    TRUE
),
(
    'Active Recall Quiz & Flashcard Generator',
    'Based on the study notes below, create: 1) 10 spaced-repetition flashcards (Question / Concise Answer) and 2) 5 multiple-choice exam questions with explanations for why each wrong option is incorrect.\n\nNotes:\n[PASTE NOTES]',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'ChatGPT',
    NULL,
    NULL,
    TRUE
),
(
    'Socratic Math & Coding Tutor',
    'Act as a patient Socratic tutor. Do NOT give me the final answer right away. Instead, look at my current attempt on this [SUBJECT] problem, point out where my reasoning drifts, and give me one small hint for the next step.\n\nProblem:\n[PASTE PROBLEM]\n\nMy Attempt:\n[PASTE ATTEMPT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Claude',
    'FlowGPT',
    'https://flowgpt.com',
    FALSE
),
(
    'Research Paper Structured Breakdown',
    'Summarize this academic paper into 5 clear sections: 1) Problem Statement, 2) Methodology, 3) Key Results, 4) Limitations, and 5) Practical Takeaways. Keep technical accuracy high and highlight any undefined assumptions.\n\nPaper/Abstract:\n[PASTE TEXT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'DBMS & SQL Exam Practice Generator',
    'Generate 5 realistic university-level DBMS practice questions covering [TOPIC, e.g., normalization, joins, transactions, indexing]. Include a sample schema, the questions, and step-by-step model answers.',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Essay Outline & Thesis Statement Refiner',
    'I am writing a [WORD COUNT]-word essay on [TOPIC]. Help me sharpen my thesis statement so it is arguable and specific, then build a structured paragraph-by-paragraph outline with topic sentences and evidence ideas.\n\nDraft Thesis:\n[PASTE THESIS]',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    '2-Week Exam Revision Schedule Builder',
    'Create a realistic 14-day study schedule for my upcoming exams in [LIST SUBJECTS] with [HOURS PER DAY] hours available daily. Prioritize weaker topics ([WEAK TOPICS]), mix subjects to prevent burnout, and include review days.',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Productivity',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Lab Report Clarity & Formatting Reviewer',
    'Review my [SCIENCE/ENGINEERING] lab report draft for clarity, objective scientific tone, logical flow between Hypothesis, Method, Results, and Conclusion, and proper unit consistency without altering my experimental data.\n\nDraft:\n[PASTE DRAFT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Language Learning Conversation Partner',
    'Act as a friendly native [LANGUAGE] speaker at an [A2/B1/B2] level. Hold a natural conversation with me about [TOPIC]. Keep replies to 2-3 sentences, gently correct any grammar mistakes at the end, and suggest one natural idiom.',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'ChatGPT',
    'prompts.chat',
    'https://prompts.chat',
    FALSE
),
(
    'Cornell Notes Converter',
    'Convert the following raw lecture transcript or textbook excerpt into clean Cornell Notes format with: Cue Questions on the left, concise Main Notes on the right, and a 3-sentence Summary at the bottom.\n\nMaterial:\n[PASTE TEXT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Gemini',
    NULL,
    NULL,
    FALSE
),
(
    'Viva & Oral Defense Question Simulator',
    'I am presenting my college project titled "[PROJECT TITLE]" built with [TECH STACK]. Act as an external examiner and ask me 8 tough viva questions covering architecture, database design, edge cases, and real-world limitations.',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Compare & Contrast Matrix Builder',
    'Create a side-by-side comparison table contrasting [CONCEPT A] and [CONCEPT B] across 6 key dimensions (definition, how it works, pros, cons, typical use case, and common misconception).',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Capstone Project Idea Brainstormer',
    'Suggest 5 practical, resume-worthy student project ideas combining [SKILL/STACK] for a [TIMEFRAME, e.g., 4-week] semester deadline. For each idea, list core features, database tables needed, and one standout differentiator.',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Citation & Bibliography Format Checker',
    'Format the following source details into accurate [APA 7th / IEEE / MLA] in-text citations and reference list entries. Flag any missing metadata (such as publication year, DOI, or access date).\n\nSources:\n[PASTE DETAILS]',
    (SELECT category_id FROM Categories WHERE category_name = 'Students & Education'),
    'Study',
    'Any',
    NULL,
    NULL,
    FALSE
);

-- ============================================================================
-- 5. Business & Marketing (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'SaaS Landing Page Copywriter',
    'Write high-converting landing page copy for [PRODUCT NAME], which helps [TARGET AUDIENCE] solve [CORE PROBLEM]. Include: 3 hero headline/subheadline variations, 3 benefit-focused feature blocks, social proof placeholder prompts, and a clear CTA.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Copywriting',
    'Claude',
    'FlowGPT',
    'https://flowgpt.com',
    TRUE
),
(
    'Ideal Customer Profile (ICP) & Pain-Point Mapper',
    'Define a detailed Ideal Customer Profile for [PRODUCT/SERVICE] priced at [PRICE POINT]. Break down job roles, daily frustrations, buying triggers, common objections, and the exact language they use to describe their problem.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Text',
    'ChatGPT',
    NULL,
    NULL,
    TRUE
),
(
    '30-Day Product Launch Go-To-Market Plan',
    'Build a lean 30-day go-to-market launch plan for [PRODUCT] targeting [AUDIENCE] with a [BUDGET] marketing budget. Organize weekly milestones across pre-launch waitlist, launch day channels, partnerships, and post-launch retention.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Text',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Cold Outreach Email Sequence (3-Touch)',
    'Write a 3-email cold outreach sequence to [TARGET ROLE] offering [VALUE PROPOSITION]. Keep each email under 100 words, personalize the opening hook around [TRIGGER], avoid spammy buzzwords, and end with a low-friction question.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Copywriting',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'SEO Topic Cluster & Keyword Strategy',
    'Generate an SEO content cluster around the pillar topic "[PILLAR TOPIC]" for a [BUSINESS TYPE]. Provide 1 pillar page outline and 8 supporting blog post ideas with target search intent (informational, commercial, transactional) and long-tail keywords.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Copywriting',
    'ChatGPT',
    'prompts.chat',
    'https://prompts.chat',
    FALSE
),
(
    'Competitor Positioning & SWOT Matrix',
    'Conduct a structured SWOT analysis comparing [MY PRODUCT] against [COMPETITOR 1] and [COMPETITOR 2] based on these facts: [PASTE FACTS]. Highlight 3 actionable positioning angles we can own.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Text',
    'Gemini',
    NULL,
    NULL,
    FALSE
),
(
    'Customer Onboarding Welcome Email Series',
    'Draft a 4-part onboarding email sequence for new users who just signed up for [PRODUCT]. Focus on helping them reach their first "aha moment" ([KEY ACTION]) within 48 hours without overwhelming them.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Copywriting',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Pricing Tier & Value Metric Designer',
    'Design 3 pricing tiers (Free/Starter, Pro, Team) for [PRODUCT]. Recommend a clear value metric (e.g., seats, usage, projects), feature gating that encourages natural upgrades, and psychological anchoring tips.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Text',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    '10-Slide Investor Pitch Deck Outline',
    'Create a 10-slide pitch deck outline for [STARTUP IDEA] (Problem, Solution, Why Now, Market Size, Product, Business Model, Traction, Competition, Team, Ask). For each slide, write the headline takeaway and bullet points.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Text',
    'ChatGPT',
    'GitHub Awesome ChatGPT Prompts',
    'https://github.com/f/awesome-chatgpt-prompts',
    FALSE
),
(
    'Ad Copy A/B Testing Variations',
    'Write 6 ad copy variations for [PLATFORM, e.g., Google Search / Meta / LinkedIn] promoting [OFFER]. Test 3 distinct angles: Pain-Point Agitation, Social Proof/Outcome, and Speed/Convenience, obeying platform character limits.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Copywriting',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Customer Survey & Interview Question Designer',
    'Write 10 unbiased user-interview questions (inspired by The Mom Test) to validate whether [TARGET AUDIENCE] genuinely experiences [PROBLEM] and currently pays to solve it. Avoid leading or hypothetical questions.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Text',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Sales Objection Handling Playbook',
    'List the top 6 objections a prospect raises before buying [PRODUCT/SERVICE] (e.g., price, timing, switching cost, trust) and write empathetic, evidence-based responses with a follow-up discovery question for each.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Text',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Case Study Storyteller (STAR Format)',
    'Turn these raw customer results and quotes into a persuasive 500-word B2B case study structured around: Customer Background, Challenge, Solution Implemented, and Measurable Results.\n\nNotes:\n[PASTE NOTES]',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Copywriting',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Brand Voice & Tone Style Guide',
    'Create a concise Brand Voice & Tone guide for [BRAND NAME] targeting [AUDIENCE]. Define 4 personality traits with "We are / We are not" examples, vocabulary preferences, and sample rewrites of a generic support message.',
    (SELECT category_id FROM Categories WHERE category_name = 'Business & Marketing'),
    'Copywriting',
    'Any',
    NULL,
    NULL,
    FALSE
);

-- ============================================================================
-- 6. Career & Professional (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'ATS-Friendly Resume Bullet Rewriter',
    'Rewrite the resume bullet points below for a [TARGET ROLE] position. Use strong action verbs, highlight measurable impact (metrics/outcomes), and naturally align with keywords from this job description without fabricating experience.\n\nBullets:\n[PASTE BULLETS]\n\nJob Description:\n[PASTE JD]',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Claude',
    'FlowGPT',
    'https://flowgpt.com',
    TRUE
),
(
    'Mock Technical & Behavioral Interviewer',
    'Act as a hiring manager interviewing me for a [JOB TITLE] role at a [COMPANY TYPE]. Ask me one interview question at a time (mixing behavioral and role-specific questions). Wait for my answer, give constructive feedback, then ask the next question.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'ChatGPT',
    'prompts.chat',
    'https://prompts.chat',
    TRUE
),
(
    'Tailored Cover Letter Generator',
    'Write a concise, genuine 250-word cover letter for the [JOB TITLE] role at [COMPANY]. Connect my top 2 achievements ([ACHIEVEMENTS]) directly to the company''s needs in the job description, avoiding generic clichés.\n\nJob Description:\n[PASTE JD]',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'LinkedIn Profile Headline & About Optimizer',
    'Write 3 compelling LinkedIn headline options (under 220 characters) and a 150-word "About" summary for a [CURRENT ROLE / STUDENT] aiming for [TARGET ROLE] roles. Highlight skills: [SKILLS] in a warm, authentic first-person voice.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'STAR Behavioral Story Structurer',
    'Help me turn this rough work/project experience into a crisp 90-second STAR (Situation, Task, Action, Result) interview story demonstrating [COMPETENCY, e.g., conflict resolution/ownership].\n\nExperience:\n[PASTE NOTES]',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Salary & Offer Negotiation Script',
    'I received a job offer for [ROLE] at [OFFER AMOUNT], while my target market range is [TARGET RANGE] based on [JUSTIFICATION]. Write a polite, confident email and phone script to negotiate base pay or sign-on bonus without jeopardizing the offer.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Executive Stakeholder Status Update Email',
    'Turn these technical project updates into a clear 150-word status email for non-technical leadership. Use sections for Progress This Week, Risks/Blockers, and Next Milestones.\n\nUpdates:\n[PASTE NOTES]',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Text',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    '90-Day New Job Onboarding Plan',
    'Create a practical 30-60-90 day onboarding plan for starting a new role as a [JOB TITLE] on a [TEAM SIZE] team. Focus on learning systems, building stakeholder relationships, and delivering one early win.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Performance Review Self-Evaluation Writer',
    'Draft a clear, evidence-based self-evaluation for my annual review using these accomplishments and feedback notes. Organize into Key Wins, Growth Areas, and Goals for Next Quarter.\n\nNotes:\n[PASTE NOTES]',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Cold Networking & Informational Interview Message',
    'Write a respectful, 75-word LinkedIn connection note or email to a [ROLE] at [COMPANY] requesting a brief 15-minute informational chat about their transition into [FIELD]. Do not ask directly for a job.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Difficult Workplace Conversation Prep',
    'I need to address [ISSUE, e.g., missed deadlines/scope creep] with my [MANAGER/COLLEAGUE]. Help me script a calm, constructive conversation using non-violent communication (Observations, Impact, Request) and anticipate their likely responses.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Text',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Portfolio Project README Case Study Writer',
    'Write a polished GitHub README.md for my project "[PROJECT NAME]" built with [TECH STACK]. Include: Problem Solved, Architecture Overview, Key Features, Setup Instructions, and Screenshots placeholder.\n\nProject Details:\n[PASTE DETAILS]',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Skill Gap Analysis & Learning Roadmap',
    'Compare my current skills ([CURRENT SKILLS]) against this target job description ([PASTE JD]). Identify the top 5 skill gaps and create a focused 8-week learning plan with hands-on mini-project ideas to close them.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Career',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Polite Decline & Boundary-Setting Email',
    'Write 3 professional email templates (Warm, Neutral, Firm) to decline [REQUEST, e.g., an extra committee/an out-of-scope task] due to current workload priorities, while preserving a positive working relationship.',
    (SELECT category_id FROM Categories WHERE category_name = 'Career & Professional'),
    'Text',
    'Any',
    NULL,
    NULL,
    FALSE
);

-- ============================================================================
-- 7. Social Media & Content Creation (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'Viral Short-Form Video Script (Reels / Shorts)',
    'Write a 45-second vertical video script about [TOPIC] for [AUDIENCE]. Structure it with: 1) A scroll-stopping 3-second visual + verbal hook, 2) 3 fast-paced actionable points, and 3) A natural comment-driving CTA.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'ChatGPT',
    'FlowGPT',
    'https://flowgpt.com',
    TRUE
),
(
    'LinkedIn Thought-Leadership Post Builder',
    'Turn the insight below into a crisp LinkedIn post (150-220 words). Start with a 1-line hook that sparks curiosity, use short scannable paragraphs, share one concrete lesson, and end with an engaging discussion question.\n\nInsight:\n[PASTE IDEA]',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Claude',
    NULL,
    NULL,
    TRUE
),
(
    'YouTube Video Outline & Retention Hooks',
    'Create a detailed outline for an 8-10 minute YouTube video titled "[TITLE]". Include: a 30-second intro confirming the click promise, 4 structured chapters with pattern interrupts every 2 minutes, and a smooth outro.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'X / Twitter Thread Repurposer',
    'Convert this blog post or article into a punchy 7-tweet thread. Tweet 1 must be a strong hook without hashtags; Tweets 2-6 should each deliver one standalone takeaway; Tweet 7 should summarize and invite replies.\n\nArticle:\n[PASTE TEXT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Instagram Carousel Slide-by-Slide Copy',
    'Design copy for an 8-slide Instagram educational carousel on "[TOPIC]". Keep each slide under 25 words: Slide 1 (Bold Cover Hook), Slide 2 (The Problem), Slides 3-6 (Step-by-step Framework), Slide 7 (Summary), Slide 8 (Save/Share CTA).',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    '30-Day Content Calendar Generator',
    'Build a 30-day content calendar for a [NICHE] creator posting 4 times a week on [PLATFORM]. Balance content across 4 pillars: Educational (How-to), Relatable/Story, Opinion/Myth-Busting, and Behind-the-Scenes.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Gemini',
    NULL,
    NULL,
    FALSE
),
(
    'Newsletter Issue Writer & Subject Line Lab',
    'Write a weekly email newsletter (400 words) on "[TOPIC]" in a conversational, insightful tone. Include 5 curiosity-driven subject line options, a personal intro, one main takeaway, and 2 curated resource blurbs.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Copywriting',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Podcast Guest Research & Question Prep',
    'I am interviewing [GUEST NAME / ROLE], known for [ACHIEVEMENT/TOPIC], on my podcast. Generate 10 thoughtful, non-generic interview questions organized from warm-up backstory to deep tactical insights and rapid-fire closing.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Long-Form Blog Post SEO Outline',
    'Create a comprehensive, reader-friendly outline for a 1,500-word blog post on "[TOPIC]". Include H1, H2, and H3 headings, key points per section, FAQ questions, and a meta description under 155 characters.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Copywriting',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    '10 Scroll-Stopping Hook Variations',
    'Write 10 different opening hooks for content about "[TOPIC]" targeting [AUDIENCE]. Mix formats: Contrarian Statement, Specific Number, Mistake Callout, "How I..." Story, and Question Hook.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Any',
    'FlowGPT',
    'https://flowgpt.com',
    FALSE
),
(
    'Community Comment & DM Engagement Replies',
    'Suggest 8 warm, authentic reply templates for responding to audience comments (questions, praise, skepticism, and resource requests) on [PLATFORM] so replies spark further conversation rather than sounding robotic.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Content Repurposing Multiplier',
    'Take this single core piece of content and turn it into: 1) A 150-word LinkedIn post, 2) A 30-second video script, 3) A 5-slide carousel outline, and 4) A 3-bullet newsletter tip.\n\nCore Content:\n[PASTE CONTENT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Social',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Storytelling Narrative Arc Editor',
    'Rewrite this dry informational draft into an engaging story using the "Status Quo -> Inciting Problem -> Turning Point -> Lesson" structure while keeping all factual details accurate.\n\nDraft:\n[PASTE DRAFT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Copywriting',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Creator Sponsorship Pitch Email',
    'Write a concise pitch email from a [NICHE] creator with [AUDIENCE SIZE / ENGAGEMENT] to [BRAND NAME] proposing a sponsored [VIDEO/NEWSLETTER] integration. Focus on audience fit and measurable value.',
    (SELECT category_id FROM Categories WHERE category_name = 'Social Media & Content Creation'),
    'Copywriting',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
);

-- ============================================================================
-- 8. Productivity (14 prompts)
-- ============================================================================
INSERT INTO Prompts (title, content, category_id, prompt_type, ai_tool, source_name, source_url, is_featured) VALUES
(
    'Eisenhower Matrix Task Prioritizer',
    'Organize my messy to-do list below into the 4 Eisenhower Matrix quadrants (Do First, Schedule, Delegate, Eliminate). Suggest the single top-priority "frog" task to tackle first and explain why.\n\nTasks:\n[PASTE TASKS]',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Any',
    'prompts.chat',
    'https://prompts.chat',
    TRUE
),
(
    'Time-Blocked Daily Schedule Builder',
    'Build a realistic time-blocked schedule for my workday from [START TIME] to [END TIME]. Include deep-work blocks for [TOP 2 PRIORITIES], batching for emails/admin, short breaks, and a 15-minute buffer for unexpected tasks.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'ChatGPT',
    NULL,
    NULL,
    TRUE
),
(
    'Big Goal to Weekly Micro-Milestones',
    'Break down my big goal "[GOAL]" over the next [WEEKS] weeks into clear weekly milestones and 30-minute daily action steps so I can make steady progress without feeling overwhelmed.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Decision Matrix & Trade-Off Scorer',
    'Help me decide between [OPTION 1], [OPTION 2], and [OPTION 3]. Define 5 weighted decision criteria relevant to [CONTEXT], score each option objectively, highlight hidden risks, and recommend a choice.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Weekly Review & Reflection Template',
    'Guide me through a 15-minute Friday weekly review based on these notes: what went well, what slipped, what drained energy, and what my top 3 outcomes should be for next week.\n\nNotes:\n[PASTE NOTES]',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Brain-Dump Organizer & Action Extractor',
    'Turn this unstructured brain dump into clean categories: Actionable Tasks (with next physical step), Waiting On Others, Reference Notes, and Ideas for Later.\n\nBrain Dump:\n[PASTE TEXT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Gemini',
    NULL,
    NULL,
    FALSE
),
(
    'Effective Meeting Agenda & Pre-Read Writer',
    'Create a tight [30/45]-minute meeting agenda for "[MEETING TOPIC]" with [PARTICIPANTS]. Include the single desired decision/outcome, timed discussion blocks, and a 3-bullet pre-read so the meeting finishes early.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Habit Stacking & Friction-Reduction Plan',
    'I want to build the habit of [NEW HABIT] consistently. Design a habit-stacking plan anchored to my existing routine ([EXISTING ROUTINE]), identify 3 likely friction points, and suggest simple environment tweaks to stay consistent.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Long Document TL;DR & Key Takeaways',
    'Condense the following long document into: 1) A 2-sentence TL;DR, 2) 5 key takeaways in bullet form, and 3) Any deadlines, numbers, or decisions buried in the text.\n\nDocument:\n[PASTE TEXT]',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Claude',
    NULL,
    NULL,
    FALSE
),
(
    'Standard Operating Procedure (SOP) Writer',
    'Turn these rough steps for [RECURRING TASK] into a clean, repeatable Standard Operating Procedure (SOP) with Purpose, Prerequisites, Numbered Steps, Common Mistakes to Avoid, and a Verification Checklist.\n\nRough Steps:\n[PASTE STEPS]',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Procrastination Unblocker (5-Minute Starter)',
    'I am procrastinating on [TASK] because it feels [REASON, e.g., vague/intimidating]. Break the very first step down into a tiny, zero-friction 5-minute action I can start right now, and give me a simple checklist for the first 25-minute Pomodoro.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'ChatGPT',
    NULL,
    NULL,
    FALSE
),
(
    'Personal Knowledge Base Tagging Taxonomy',
    'Help me design a clean, minimal folder and tag taxonomy for organizing my notes and bookmarks in [TOOL, e.g., Notion/Obsidian] across these areas: [LIST AREAS]. Keep it flat enough to maintain effortlessly.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Any',
    NULL,
    NULL,
    FALSE
),
(
    'Email Inbox Zero Batch-Reply Drafter',
    'Draft short, clear replies (under 60 words each) for these 5 pending emails so I can clear my inbox quickly without losing warmth or clarity.\n\nEmails:\n[PASTE EMAILS]',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Text',
    'Gemini',
    NULL,
    NULL,
    FALSE
),
(
    'Pre-Mortem Risk Analysis Facilitator',
    'Imagine it is 3 months from now and my project "[PROJECT NAME]" failed or missed its deadline. List the 6 most likely reasons why, rate their likelihood, and suggest one preventive safeguard for each today.',
    (SELECT category_id FROM Categories WHERE category_name = 'Productivity'),
    'Productivity',
    'Claude',
    NULL,
    NULL,
    FALSE
);
