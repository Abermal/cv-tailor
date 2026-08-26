# CV Tailoring Project Rules

- Treat `cv/master_cv.tex` as the only source of truth for the candidate's experience, education, skills, achievements, languages, and credentials.
- Never invent experience, responsibilities, seniority, metrics, technologies, customer work, architecture ownership, certifications, projects, or outcomes.
- Tailor wording, ordering, and emphasis to the supplied position description, but preserve factual meaning.
- Keep the submitted CV approximately one page and preserve the existing LaTeX macros and overall structure.
- Return the complete tailored CV, not a diff or excerpt.
- Preserve valid LaTeX: escape textual `&` as `\&` and `%` as `\%`, use balanced braces, and use valid `\href{url}{text}` syntax.
- Compile or otherwise validate the LaTeX whenever the required compiler and supporting class/macros are available.
- Keep generated vacancy-specific files under `output/`; do not overwrite the source-of-truth CV.
