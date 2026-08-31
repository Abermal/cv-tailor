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
4. Use the vacancy to select the most relevant story, not as a source of prose or a checklist of keywords.

## Using the vacancy without copying its voice

- Do not copy or closely paraphrase the vacancy's phrases, clause structure, slogans, or lists of responsibilities. Preserve only unavoidable items such as the role title, proper nouns, and precise technical terms.
- Translate a relevant requirement into the candidate's own reason for caring about the work or into concrete evidence from their background. If it cannot be made personal or specific, omit it instead of restating the employer's goal.
- Do not stack several vacancy terms into one polished summary sentence. This often produces generic language that sounds like the advertisement, even when no full sentence was copied.
- Treat generic or AI-like vacancy language as meaning to understand, not wording to reuse. Reduce it to the plain underlying idea before drafting. For example, a genuine preference for working with messy data and building software that survives production is stronger than a formal paraphrase about transforming unstructured inputs and continuously ensuring model quality.
- Before finalizing, compare the letter with the vacancy and rewrite any sentence that could plausibly appear in the advertisement itself. This check is for prose and sentence shape, not necessary technical vocabulary.

## Positioning and structure

- Put the company name and address at the top left in a conventional business-letter recipient block. If the user provides a recruiter or contact person, include their name and team there and address them directly in the salutation, for example `Dear Mr Müller,`. If no name is provided, use a neutral team salutation.
- Keep the letter deliberately short: usually about 250--350 words and two or three compact body paragraphs, plus a one-sentence closing. The rendered letter should leave comfortable white space and should not visually fill the page. Do not lengthen the text merely because more space is available.
- Usually use one opening paragraph. Split it into two short introductory paragraphs only when the technical motivation or a genuinely important domain motivation needs separate room.
- Use this default narrative order for every cover letter: a brief opening that states why the candidate is applying and what about the role's work is interesting; one or two evidence paragraphs showing why the candidate is qualified; then a distinct final body paragraph explaining why this specific company is appealing; and finally the formal closing.
- Prefer the direct opening "I am applying for [role] because..." The clause after "because" should name one or two specific technical challenges in the actual work and connect them to the kind of work the candidate genuinely enjoys. Express those challenges in the candidate's language, not as a list of themes copied from the vacancy.
- Use this opening logic rather than a fixed script: application and technical motivation first; a brief, down-to-earth reference to the domain or mission only when it genuinely adds motivation; then "I believe my experience..." or an equally direct sentence explaining why the candidate can contribute. The qualification sentence should point to a few relevant areas of evidence, not repeat the vacancy's requirements or inventory tools.
- It is fine for the technical motivation to begin with a broad, lasting interest such as applying ML or computer vision to real-world problems, but pair it with something distinctive about this position. Do not force technical motivation, mission, and qualification into one overloaded sentence; two or three natural sentences are usually clearer.
- Use the main evidence paragraph to develop the strongest role-specific example, or at most two closely related examples, showing why the candidate is qualified. Prefer depth and relevance over covering the full CV.
- Use an additional paragraph only when it earns its space. If the vacancy emphasizes a distinct non-technical requirement such as German proficiency, stakeholder communication, teaching, or coordination, address it with concrete evidence. Otherwise, use a short, specific reason for wanting to join the company or team and what the candidate hopes to contribute; do not pad the letter with generic excitement.
- Avoid framing the employer mainly as a career benefit or "next step."
- Build a coherent career story: explain how earlier clinical or research exposure led to the present role, rather than listing every project.
- For medical-imaging or medtech roles, make the motivation concrete: explain why working on problems with direct patient and clinical impact is meaningful to the candidate, then connect that motivation to clinical collaboration, validation, deployment, and the real use of the system. Prefer one or two developed examples over a catalogue.
- When the position involves a new technical challenge, modality, domain, or data type, express genuine interest, name the specific challenges that make it interesting, and connect concrete transferable methods from the candidate's background. Do not volunteer a list of missing qualifications. Acknowledge a knowledge boundary only when needed to avoid a misleading equivalence, and state it neutrally rather than as a self-disqualifying disclaimer.
- Address model families, tools, and methods through concrete work. Distinguish hands-on production or implementation experience from methods encountered through coursework, independent study, or adjacent projects.
- Preserve chronology. If one project preceded another, say "prior to this work" or otherwise make the sequence explicit; do not use "alongside" unless the work was genuinely concurrent.
- End the body with two or three short sentences explaining why the candidate is interested in this specific company. Ground the answer in the employer's work, operating context, domain, product, or technical challenge and connect it briefly to what the candidate wants to contribute. Write this paragraph even when the application does not explicitly ask for it, and keep the normal closing sentence separate.
- Close plainly and professionally.
- Only after the letter's content is finalized, search the company's official website for its legal notice/Impressum. Add the confirmed legal company name and postal address to the recipient block. Prefer the official site over job boards or aggregators; if the Impressum cannot be found, state the uncertainty and use only an address confirmed by an official company page.

## Voice and editing

- Sound like a real engineer: direct, thoughtful, specific, and modestly confident.
- Prefer conversational professional language over abstract recruiting language. Read each motivation sentence as something the candidate might naturally say aloud; rewrite dry formulations built from nouns such as "quality assurance," "continuous development," "productive implementation," or similar employer terminology unless concrete context makes them necessary.
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
- Prefer a clean `.tex` source and PDF when the local LaTeX toolchain is available; the raw `.txt` remains required even when rendering succeeds. Render the finalized `.tex` source through `$render-latex` using `.agents/skills/render-latex/scripts/render_cover_letter.ps1`; do not invoke `pdflatex.exe` directly.
- After the final version is accepted, remove superseded PDF variants and LaTeX `.aux`, `.log`, and `.out` files from the vacancy directory. Retain the final PDF and editable `.tex` and `.txt` sources. If an open PDF forces a temporary alternate filename, clean the obsolete variants after the lock is released or the user approves the alternate final name.
- If the user asks for a hyperlink to external project material, verify the URL first and attach it to a factual project reference. Do not add external links merely for decoration.
