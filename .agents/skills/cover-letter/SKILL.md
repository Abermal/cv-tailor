---
name: cover-letter
description: Write or revise concise, grounded cover letters using cv/master_cv.tex, the vacancy, and reusable career context. Present a direct statement of fit, relevant evidence, and genuine motivation for the employer.
---

# Cover Letter

Write in the candidate's voice: a thoughtful engineer using clear, natural, professional language. Make a direct case for fit, support it with concrete experience, and explain why the candidate wants to join.

## Sources and factual boundaries

1. Read the complete vacancy, `cv/master_cv.tex`, and [career context](references/career-context.md). The context holds background, motivations, and project-specific interpretation; this skill defines the letter's structure and voice.
2. Treat the master CV as the factual source of truth for CV facts. Use the additional user-provided context only as recorded, without strengthening it into unsupported responsibilities or achievements. Flag source conflicts; omit uncertain details or ask for confirmation when they are essential.
3. Never invent experience, seniority, ownership, metrics, clinical adoption, collaborators, publications, implementation details, credentials, or motivations. Distinguish personal contributions from team work, and hands-on implementation from study or familiarity. Preserve chronology; use "alongside" only for genuinely concurrent work.
4. For a new modality, domain, or method, connect relevant transferable experience and genuine interest without implying direct expertise. Do not list missing qualifications; state a knowledge boundary neutrally only when needed to avoid a misleading claim.

## Using the vacancy

- Use the vacancy to select relevant evidence and motivation. Do not blindly copy or closely paraphrase its promotional phrases, slogans, sentence structure, or lists of responsibilities. Explain the match in the candidate's own language; ordinary professional wording and precise technical terms are fine.
- Turn requirements into supported examples, not a checklist or a sentence stacked with vacancy terms. Mention technologies when they explain the work, a decision, or relevance; avoid tool inventories.
- Ground company-specific statements in the vacancy or verified official material. Do not assume culture, technical maturity, or responsibility from company size or marketing tone alone.

## Letter structure

Usually write about 250--350 words in three or four compact body paragraphs, followed by a one-sentence closing. This is a target, not a minimum. Keep the letter comfortably within one page with white space. Use the following order unless the user or application specifies otherwise.

### 1. Opening: a direct statement of fit

State the role and why the candidate believes their experience makes them well suited to it, usually in one or two sentences. For example: "I am applying for [role] because I believe my experience in computer vision and software engineering makes me well suited to the position." Adapt the substance to the actual fit; no fixed wording or number of qualifications is required. Leave the developed explanation of motivation for the final body paragraph.

### 2. Evidence: substantiate the claim

- Use one or two paragraphs to develop the strongest relevant examples. Explain the problem or constraint, the candidate's contribution or decision, and the supported outcome or significance. Make the connection to the role clear. A useful decision or responsibility can be evidence without a numerical metric.
- Select the angle that best demonstrates fit: technical depth, ownership, engineering judgment, research and validation, or collaboration. Do not require all of them. Let the actual work guide the selection; engineering maturity can matter in medical imaging, too.
- Develop achievements already in the CV by adding context, reasoning, responsibility, or relevance. Do not merely reproduce its bullets. Include a brief career trajectory only when it strengthens the case; the medical-imaging progression is available in career context.

### 3. Final body paragraph: why this employer

Use two or three short sentences to explain what genuinely appeals about this company's work, product, mission, or team environment and what the candidate would like to contribute. Keep this distinct paragraph even when company motivation is not explicitly requested.

Select and connect motivations the candidate has actually expressed. Interests in meaningful products, mature engineering, or ownership are valid; do not invent enthusiasm to mirror the vacancy. If little is known about the company, make a modest connection to the advertised work.

Do not describe the role as a "next step" (including "a strong next step for me") or a career stepping stone. Professional aspirations are welcome when tied to the work and contribution; avoid presenting the employer mainly as a means of career advancement.

### Relevant additional information and closing

Address important requirements such as German proficiency, stakeholder communication, teaching, or coordination with concrete evidence when relevant. Put substantial evidence in the middle; brief practical information can sit near the end or in a short separate paragraph. Do not overload the motivation paragraph or add these points automatically. End with one plain sentence welcoming a conversation and a professional sign-off.

## Voice and final review

- Use familiar words, straightforward sentences, and precise technical terms that the candidate could naturally use in an interview. Keep correct grammar; do not simulate non-native mistakes. Be specific and modestly confident, without ornate language, idioms, sales language, or generic enthusiasm.
- Explain significance through what was built, who it served, what constraint mattered, or what changed. Avoid abstract recruiting language, vague claims such as "immediate real-world importance," and unsupported labels such as "state of the art."
- Before finalizing, check that the opening states fit, the evidence supports it, and the final paragraph adds genuine employer motivation. Remove repeated ideas and awkward transitions; rewrite advertisement-like phrasing and generic sentences. Check factual support and chronology. Keep internal files, drafting notes, and unresolved source questions out of the letter.

## Presentation and output

- During sentence-level exploration, discuss wording in chat and show the full revised draft when requested. Do not repeatedly edit or render files until the user asks to finalize or render. Save deliverables and rendered artifacts in the vacancy's `output/` directory.
- For the formatted letter, put the company name and address at the top left. Include a supplied contact person's name and team and address them directly; otherwise use a neutral team salutation. After content is finalized, verify the legal company name and postal address on the official Impressum or another official company page. If unavailable, tell the user and include only confirmed details.
- When saving the letter, always include a clean raw `.txt` version for online forms, preserving paragraph breaks and removing LaTeX commands and formatting markup.
- Prefer a clean `.tex` source and PDF when the local LaTeX toolchain is available; the raw `.txt` remains required even when rendering succeeds. Render the finalized `.tex` source through `$render-latex` using `.agents/skills/render-latex/scripts/render_cover_letter.ps1`; do not invoke `pdflatex.exe` directly.
- After the final version is accepted, remove superseded PDF variants and LaTeX `.aux`, `.log`, and `.out` files from the vacancy directory. Retain the final PDF and editable `.tex` and `.txt` sources. If an open PDF forces a temporary alternate filename, clean the obsolete variants after the lock is released or the user approves the alternate final name.
- If the user asks for a hyperlink to external project material, verify the URL first and attach it to a factual project reference. Do not add external links merely for decoration.
