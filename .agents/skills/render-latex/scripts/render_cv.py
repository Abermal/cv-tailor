#!/usr/bin/env python3
"""Merge and compile a vacancy-specific CV on Linux."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[4]
OUTPUT_ROOT = (REPOSITORY_ROOT / "output").resolve()
HEADER_PATH = REPOSITORY_ROOT / "cv" / "header_cv.tex"


def emit(result: dict, exit_code: int = 0) -> None:
    print(json.dumps(result, separators=(",", ":")))
    raise SystemExit(exit_code)


def repository_path(value: str) -> Path:
    path = Path(value).expanduser()
    return (path if path.is_absolute() else REPOSITORY_ROOT / path).resolve()


def require_under_output(path: Path, description: str) -> None:
    if path != OUTPUT_ROOT and OUTPUT_ROOT not in path.parents:
        raise ValueError(f"{description} must be located under {OUTPUT_ROOT}")


def resolve_pdflatex(configured: str | None) -> str:
    candidate = configured or os.environ.get("CV_PDFLATEX")
    if candidate:
        resolved = shutil.which(candidate)
        if resolved:
            return resolved
        path = Path(candidate).expanduser()
        if path.is_file() and os.access(path, os.X_OK):
            return str(path.resolve())
        source = "CV_PDFLATEX" if configured is None else "configured pdflatex"
        raise FileNotFoundError(f"{source} executable does not exist: {candidate}")

    resolved = shutil.which("pdflatex")
    if resolved:
        return resolved
    raise FileNotFoundError(
        "pdflatex was not found. Install a TeX Live distribution, put pdflatex "
        "on PATH, set CV_PDFLATEX, or pass --pdflatex-path."
    )


def first_latex_error(log: str) -> str | None:
    error = re.search(r"^!\s+(.+)$", log, re.MULTILINE)
    if not error:
        return None
    line = re.search(r"^l\.(\d+)\s*(.*)$", log[error.start() :], re.MULTILINE)
    if line:
        return f"{error.group(1).strip()} at line {line.group(1)}: {line.group(2).strip()}"
    return error.group(1).strip()


def page_count(log: str) -> int | None:
    match = re.search(r"Output written on .+? \((\d+) pages?[,)]", log, re.DOTALL)
    return int(match.group(1)) if match else None


def version_numbers(directory: Path, document_name: str) -> list[int]:
    pattern = re.compile(rf"^{re.escape(document_name)}_version(\d+)\.", re.IGNORECASE)
    return [int(match.group(1)) for item in directory.iterdir() if item.is_file() and (match := pattern.match(item.name))]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--body-path", required=True)
    parser.add_argument("--output-directory", required=True)
    parser.add_argument("--document-name", default="CV_Kostiantyn_Pysanyi")
    parser.add_argument("--pdflatex-path")
    parser.add_argument("--passes", type=int, choices=(1, 2), default=1)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]*", args.document_name) or re.search(
        r"_version\d+$", args.document_name
    ):
        raise ValueError("document-name must be a safe base filename and must not end with _versionN")

    body_path = repository_path(args.body_path)
    output_directory = repository_path(args.output_directory)
    require_under_output(body_path, "The tailored body")
    require_under_output(output_directory, "The output directory")
    if not HEADER_PATH.is_file():
        raise FileNotFoundError(f"Stable LaTeX header not found: {HEADER_PATH}")
    if not body_path.is_file():
        raise FileNotFoundError(f"Tailored body not found: {body_path}")
    output_directory.mkdir(parents=True, exist_ok=True)

    versions = version_numbers(output_directory, args.document_name)
    version = max(versions) + 1 if versions else None
    artifact_stem = f"{args.document_name}_version{version}" if version else args.document_name
    version_reason = "existing_version_sequence" if version else None

    tex_path = output_directory / f"{artifact_stem}.tex"
    pdf_path = output_directory / f"{artifact_stem}.pdf"
    log_path = output_directory / f"{artifact_stem}.log"
    merged = HEADER_PATH.read_text(encoding="utf-8").rstrip() + "\n\n"
    merged += body_path.read_text(encoding="utf-8").rstrip() + "\n\n\\end{document}\n"
    tex_path.write_text(merged, encoding="utf-8", newline="\n")

    compiler = resolve_pdflatex(args.pdflatex_path)
    exit_code = 0
    for _ in range(args.passes):
        process = subprocess.run(
            [compiler, "-interaction=nonstopmode", "-halt-on-error", tex_path.name],
            cwd=output_directory,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )
        exit_code = process.returncode
        if exit_code:
            break

    log = log_path.read_text(encoding="utf-8", errors="replace") if log_path.is_file() else ""
    result = {
        "status": "success" if exit_code == 0 and pdf_path.is_file() else "error",
        "body_path": str(body_path),
        "tex_path": str(tex_path),
        "pdf_path": str(pdf_path) if pdf_path.is_file() else None,
        "log_path": str(log_path) if log_path.is_file() else None,
        "compiler": compiler,
        "compiler_exit_code": exit_code,
        "artifact_stem": artifact_stem,
        "standard_document_name": args.document_name,
        "version": version,
        "version_reason": version_reason,
        "page_count": page_count(log),
    }
    result["approximately_one_page"] = result["page_count"] == 1
    if result["status"] == "error":
        result["first_actionable_error"] = first_latex_error(log)
        emit(result, 1)
    emit(result)


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        emit({"status": "error", "error": str(error)}, 2)
