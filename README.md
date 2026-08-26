# CV Tailoring with Codex

A private, LaTeX-based CV workspace with reusable Codex skills for tailoring a factual master CV to job descriptions, compiling the result, handling locked PDFs, and finalizing an accepted version.

## Repository structure

```text
cv/
  master_cv.tex       Factual source of truth for CV content
  header_cv.tex       Stable LaTeX preamble, macros, layout, and contact header
.agents/skills/
  tailor-cv/          Vacancy analysis and CV-tailoring workflow
  render-latex/       Deterministic rendering, validation, versioning, and cleanup
  cover-letter/       Grounded cover-letter workflow
output/               Vacancy-specific LaTeX sources and generated PDFs
```

Generated vacancy files stay under `output/`. Temporary validation images and LaTeX intermediate files are ignored by Git, while final `.tex` and `.pdf` artifacts are retained.

## Requirements

- Codex opened with this repository as its working directory
- PowerShell 5.1 or newer
- A working `pdflatex` installation, such as MiKTeX

The rendering script resolves `pdflatex` in this order: an explicit path, the `CV_PDFLATEX` environment variable, `PATH`, and the standard local MiKTeX installation path.

## Tailor a CV

Open Codex in the repository and provide the complete vacancy description:

```text
Use the tailor-cv skill.

Tailor my CV to this position:

[paste the complete position description]
```

The workflow:

1. Uses `cv/master_cv.tex` as the only factual source.
2. Assesses strong matches, partial matches, and unsupported gaps.
3. Creates a vacancy-specific directory under `output/`.
4. Tailors a copied CV body without modifying the master CV.
5. Merges the stable header, compiles the PDF, and checks its page count.
6. Returns the exact generated `.tex` and `.pdf` paths.

## Locked PDF and version handling

If the standard PDF is open in a viewer and cannot be overwritten, rendering automatically creates a numbered file such as:

```text
CV_Kostiantyn_Pysanyi_version1.pdf
CV_Kostiantyn_Pysanyi_version2.pdf
```

Further revisions continue the sequence. The skill keeps these versions until you explicitly approve one.

When the result is satisfactory, say for example:

```text
This version is good. Finalize it.
```

The finalizer publishes the latest successfully compiled version as `CV_Kostiantyn_Pysanyi.pdf`, verifies the published files, and removes obsolete `_versionN` build artifacts. If the standard PDF is still locked, it leaves all files untouched and asks you to close it before retrying.

## Render manually

The deterministic renderer can also be called directly:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\.agents\skills\render-latex\scripts\render_cv.ps1" `
  -BodyPath ".\output\<vacancy-slug>\master-tailored-body.tex" `
  -OutputDirectory ".\output\<vacancy-slug>" `
  -DocumentName "CV_Kostiantyn_Pysanyi"
```

Finalize the latest accepted version with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\.agents\skills\render-latex\scripts\finalize_cv.ps1" `
  -OutputDirectory ".\output\<vacancy-slug>" `
  -DocumentName "CV_Kostiantyn_Pysanyi"
```

Both scripts return structured JSON. Page count is read from the LaTeX log, so no Python packages or separate PDF parsing library are needed.

## Data integrity

- Add only verified facts to `cv/master_cv.tex`.
- Never invent experience, responsibilities, metrics, technologies, or credentials.
- Keep vacancy-specific edits in `output/`; do not overwrite the master CV.
- Preserve valid LaTeX and the existing document structure.
- Keep the repository private because CVs and cover letters contain personal information.
