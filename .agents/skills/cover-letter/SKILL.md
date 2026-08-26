---
name: cover-letter
description: Write concise, grounded cover letters for job applications using cv/master_cv.tex, the vacancy description, and the reusable career context file. Use when Codex needs to create or revise a cover letter that connects a candidate's experience, motivation, and career trajectory to a specific role.
---

# Cover Letter

Write as an experienced recruiter helping a strong candidate communicate clearly. Use simple, natural language and concrete details. Avoid inflated claims, ornate wording, generic enthusiasm, and CV-like bullet-point recitation.

## Sources and factual boundaries

1. Read the complete vacancy, `cv/master_cv.tex`, and the bundled `references/career-context.md` relative to this skill.
2. Treat the master CV as the factual source of truth for CV facts. The career context stores additional user-provided context and motivation; use it only as recorded, and never strengthen it into a claim the context does not support.
3. Do not invent responsibilities, metrics, clinical adoption, collaborators, publications, implementation details, or motivations. If a detail is valuable but uncertain, omit it or mark it for user confirmation.
5. Use the vacancy to select the most relevant story, not to force every keyword into the letter.

## Positioning and structure

- Put the company name and address at the top left in a conventional business-letter recipient block. If the user provides a recruiter or contact person, include their name and team there and address them directly in the salutation, for example `Dear Mr Müller,`. If no name is provided, use a neutral team salutation.
- Usually write 4--6 short paragraphs and keep the letter to roughly 350--550 words unless the user asks otherwise.
- Prefer a direct opening of the form "I am applying for [role] because..." that connects genuine interest in the technical challenge with the employer's mission. Follow it with a broad statement of relevant experience and the contribution the candidate believes they can make. Avoid framing the employer mainly as a career benefit or "next step."
- Build a coherent career story: explain how earlier clinical or research exposure led to the present role, rather than listing every project.
- For medical-imaging or medtech roles, make the motivation concrete: explain why working on problems with direct patient and clinical impact is meaningful to the candidate, then connect that motivation to clinical collaboration, validation, deployment, and the real use of the system. Prefer one or two developed examples over a catalogue.
- When the position involves a new technical challenge, modality, domain, or data type, express genuine interest, name the specific challenges that make it interesting, and connect concrete transferable methods from the candidate's background. Do not volunteer a list of missing qualifications. Acknowledge a knowledge boundary only when needed to avoid a misleading equivalence, and state it neutrally rather than as a self-disqualifying disclaimer.
- Address model families, tools, and methods through concrete work. Distinguish hands-on production or implementation experience from methods encountered through coursework, independent study, or adjacent projects.
- Preserve chronology. If one project preceded another, say "prior to this work" or otherwise make the sequence explicit; do not use "alongside" unless the work was genuinely concurrent.
- Make the final paragraph specific to the employer and role: explain why the company's clinical setting, modality, product maturity, or interdisciplinary work is a logical next step.
- Close plainly and professionally.
- Only after the letter's content is finalized, search the company's official website for its legal notice/Impressum. Add the confirmed legal company name and postal address to the recipient block. Prefer the official site over job boards or aggregators; if the Impressum cannot be found, state the uncertainty and use only an address confirmed by an official company page.

## Voice and editing

- Sound like a real engineer: direct, thoughtful, specific, and modestly confident.
- Explain significance in plain language. Replace broad claims with what was built, who it served, what constraint mattered, or what changed.
- Do not simply repeat CV bullets. Use the letter for motivation, context, trajectory, decisions, and lessons.
- Match the angle to the role. For research or medical-imaging roles, foreground clinical motivation, interdisciplinary work, scientific development, validation, and translational impact. Reserve backend architecture, maintainability, CI/CD, hardware specifications, compliance-driven deployment, and replacement of unreliable legacy implementations for engineering-heavy, platform, backend, or non-medtech roles unless the vacancy clearly asks for them.
- Avoid repeated words and concepts, especially in adjacent sentences. Before finalizing, proofread for repetition, generic phrases, awkward transitions, unsupported superlatives, and sentences that merely restate the CV.
- Do not replace evidence with a generic inventory of languages, packages, or infrastructure. Mention a technology when it clarifies what was built, how a constraint was handled, or why the experience matches the role.
- Let later motivation paragraphs deepen the opening rather than restating the same "technical challenge plus mission" formula. When the employer's mission has a concrete personal connection, explain that connection plainly and without generic mission rhetoric.
- Avoid self-focused or inflated phrases such as "a strong next step for me," vague claims such as "immediate real-world importance," and unqualified labels such as "state of the art" when a more precise description is available.
- Do not mention internal drafting files, the skill, or unverified source notes.

## Output

- Save the letter and all rendered artifacts in the vacancy's `output/` directory.
- During sentence-level exploration, discuss wording in chat and show the full revised draft when requested. Do not repeatedly edit or render files until the user asks to finalize or render.
- Always save a clean raw `.txt` version suitable for online application forms, preserving paragraph breaks but removing LaTeX commands and formatting markup.
- Prefer a clean `.tex` source and PDF when the local LaTeX toolchain is available; the raw `.txt` remains required even when rendering succeeds.
- After the final version is accepted, remove superseded PDF variants and LaTeX `.aux`, `.log`, and `.out` files from the vacancy directory. Retain the final PDF and editable `.tex` and `.txt` sources. If an open PDF forces a temporary alternate filename, clean the obsolete variants after the lock is released or the user approves the alternate final name.
- If the user asks for a hyperlink to external project material, verify the URL first and attach it to a factual project reference. Do not add external links merely for decoration.
