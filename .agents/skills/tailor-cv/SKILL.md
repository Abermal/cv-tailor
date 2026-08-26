---
name: tailor-cv
description: "Tailor the body of a LaTeX CV to a pasted job description using cv/master_cv.tex as the factual source of truth, then invoke the local render-latex skill to prepend the stable header, compile the merged PDF, and save all vacancy-specific artifacts in a dedicated output subdirectory. Keep the Professional Summary high-level and package-free: never list specific programming languages, libraries, frameworks, tools, platforms, or technologies there. Use when the user asks to adapt, optimize, or customize this CV for a vacancy."
---

# Tailor CV

Use a body-first workflow. For job matching, read the complete position description and `cv/master_cv.tex`. Do not load `cv/header_cv.tex` into the tailoring context unless build troubleshooting requires it.

`cv/master_cv.tex` is the only source of truth for factual CV body content. `cv/header_cv.tex` is a stable build prefix containing the document class, packages, macros, layout, and contact header. Keep it unchanged during vacancy tailoring.

## Workflow

1. Read the complete position description and `cv/master_cv.tex`.
2. Extract core responsibilities, mandatory requirements, preferred requirements, ATS keywords, and the employer's actual priority.
3. Map each important requirement to **strong match**, **partial match**, or **gap/unsupported**.
4. Identify adjacent technologies or skills already supported by the master but not explicitly emphasized. Ask the user about each high-value plausible omission before claiming it in the CV. Do not ask about clearly unrelated requirements; classify those as gaps.
5. Create a sanitized vacancy directory under `output/`, using a stable employer-role name such as `output/Acme_ML_Engineer/`. Copy the complete body of `cv/master_cv.tex` into that directory as `master-tailored-body.tex` and tailor only that copy. Never overwrite `cv/master_cv.tex`.
6. Rephrase, compress or expand, or highlight the relevant parts of the supported material to emphasize the strongest matches. Preserve factual meaning, existing macros, section structure, useful bold emphasis, and keep one-page density.
   You can adjust job titles based on the position. For example: Research Engineer (Data Science Research Group) is a so called Wissenschaftlicher Mitarbeiter, which can correspond to Research Scientist or Research Assitant based on the best CV-poistion match.
   Or "Freelance Computer Vision Engineer" cab become "Freelance Developr" if the target position is more focused on backend for example.
7. Invoke `$render-latex` (the local skill at `.agents/skills/render-latex/SKILL.md`) with the exact body path, vacancy directory, and standard document name `CV_Kostiantyn_Pysanyi`. Let its deterministic render script merge the stable header, tailored body, and final `\end{document}` into a self-contained source. Do not reproduce its merge, compiler discovery, page-count, or file-versioning logic.
8. `$render-latex` must compile from the vacancy directory, return actionable LaTeX errors for repair, and rerender until successful. Use the exact `.tex` and `.pdf` paths it returns; when the standard artifacts are locked, these may use a `_versionN` suffix. Do not finalize or clean versioned artifacts until the user clearly accepts a version.
9. Check the PDF page count and, when rendering tools are available, inspect for overflow, clipping, broken glyphs, or an unintended second page.
10. Return the match assessment, complete merged tailored LaTeX source, and exact generated PDF path. Do not return only the body fragment or a diff. After the user accepts a version, invoke `$render-latex` finalization and return the standard `CV_Kostiantyn_Pysanyi.pdf` path plus any cleanup status.

### Pagination and experience preservation

- Do not remove, hide, or silently omit an experience entry merely to force the CV onto one page. Preserve the complete experience history from `cv/master_cv.tex`, including internships, unless the user explicitly authorizes an omission.
- If the tailored CV becomes longer than the master or spills onto a second page, compare the tailored body with `cv/master_cv.tex` section by section to identify where content or vertical space increased.
- Recover space by tightening the longest sections according to relevance and importance: first compress repetitive wording, redundant qualifiers, and low-priority detail; then reduce unnecessary spacing or consolidate overlapping bullets while preserving factual meaning.
- Keep the strongest vacancy-relevant evidence in full. Prefer compact technical-skills phrasing, concise publication/award lines, and shorter lower-priority bullets over deleting experience.
- Preserve coherent Technical Skills taxonomy. Each subgroup should represent one consistent dimension, such as programming languages, backend/API tools, experimentation/tracking, data/workflow, infrastructure/deployment, or ML/CV. Do not combine programming languages with technologies or experimentation with infrastructure merely to insert job-description keywords.
- Do not edit, rename, split, merge, or reorder the Technical Skills subcategories by default. The master CV's subgrouping is already deliberately organized; change it only when there is a strong, vacancy-specific reason and the resulting categories are clearly more coherent. Never make a change merely to fit keywords or save a line.
- When changing skill subgroups, compare against the master CV's organization and adjust labels only when the new taxonomy is at least as logical and internally consistent. Preserve the original subgrouping when it is already coherent.
- Keep Technical Skills concrete and tool-focused: list programming languages, frameworks, libraries, platforms, and named tools. Do not list generic activities, outcomes, or process phrases such as automated evaluation or production deployment as skills.
- In Technical Skills, selectively bold the small set of supported packages, frameworks, programming languages, platforms, or technologies that are explicit or central ATS keywords for the vacancy. Apply `\textbf{}` to the exact relevant terms, keep the emphasis sparse, and do not bold unsupported or merely adjacent items.
- Avoid duplicating domain capabilities as standalone skill categories when the experience section can show them with evidence. Prefer bolding substantiated capabilities such as segmentation, detection, registration, or landmark localization in the relevant dated experience bullets.
- Treat fitting as an iterative process. Start with the smallest safe change—such as removing an unnecessary blank line, line break, or local vertical-space command—then rebuild and recheck the page count before making a larger edit.
- Re-render after each fitting iteration, stopping as soon as the CV fits cleanly and remains readable. Verify after every iteration that no experience entry disappeared and that factual meaning was preserved.

## Tailoring boundaries

- Never invent experience, responsibilities, seniority, metrics, technologies, customer work, architecture ownership, certifications, projects, or outcomes.
- Do not turn a skill listing into project experience.
- Keep the Professional Summary high-level and concise, generally one or two sentences. Never list specific programming languages, packages, libraries, frameworks, tools, platforms, or technologies in the summary; keep them in Technical Skills or substantiated experience bullets. Describe only the candidate's professional identity, broad domain, research or delivery orientation, and vacancy-relevant focus.
- Structure a two-sentence Professional Summary as complementary layers: use the first sentence for the candidate's high-level professional identity and broad evidence, then use the second sentence for the vacancy-specific focus or emphasis. Avoid repeating the same domain, modality, or outcome in both sentences; the first sentence should not already duplicate the tailored focus. For example: `Machine Learning Engineer with a strong research foundation and hands-on experience delivering robust end-to-end ML systems. Experienced in applying deep learning and computer vision to medical imaging, with a focus on production-ready solutions.`
- Before rendering, proofread the Professional Summary for stylistic repetition: check for repeated words, near-synonyms, duplicated concepts, awkward phrasing, and redundant claims across sentences. Revise the summary until the two sentences are complementary and read naturally, while preserving factual meaning.
- Preserve the existing `Languages` section as the only location for language information. Never add `Spoken Languages`, `Languages & Communication`, or similar duplicates.
- Do not modify `cv/header_cv.tex` for vacancy-specific changes. Header/contact changes require an explicit user request.
- Do not modify `cv/master_cv.tex` when tailoring a vacancy.

## LaTeX safeguards

- Escape textual ampersands as `\&` and percent signs as `\%`.
- Keep every command's braces balanced.
- Use valid `\href{url}{text}` syntax; never paste Markdown links into LaTeX.
- Use `--` for date and numeric ranges where appropriate.
- Preserve the existing macros and document class.
- Do not conclude that rendering is unavailable merely because the default sandbox cannot access `pdflatex`. Invoke `$render-latex` through its repository script and, if required, use approved external execution of that exact script command. Do not independently search for MiKTeX or install Python packages for PDF page counting.

## Response format

First provide a concise assessment of strongest matches, meaningful gaps, and recommended positioning. Then provide the vacancy directory, complete merged tailored LaTeX CV, and generated PDF. Mention any unanswered user questions or genuinely unavailable validation.
