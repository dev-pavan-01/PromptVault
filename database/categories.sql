USE promptvault;

-- Insert initial categories (INSERT IGNORE skips any existing category_name)
INSERT IGNORE INTO Categories (category_name, description) VALUES
    ('Programming & Development', 'Prompts for coding, debugging, code reviews, and software architecture.'),
    ('AI & Automation', 'Prompts for building AI agents, workflows, and task automation.'),
    ('Photo Editing & AI Art', 'Prompts for image generation, photo retouching, and visual design.'),
    ('Students & Education', 'Prompts for studying, summarizing notes, exam prep, and tutoring.'),
    ('Business & Marketing', 'Prompts for copywriting, strategy, sales, and market research.'),
    ('Career & Professional', 'Prompts for resumes, cover letters, interview prep, and workplace communication.'),
    ('Social Media & Content Creation', 'Prompts for captions, video scripts, blogs, and content calendars.'),
    ('Productivity', 'Prompts for time management, planning, brainstorming, and daily organization.');
