#!/usr/bin/env python3
"""Publish a validated versioned CV under its standard name on Linux."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import sys
import tempfile
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[4]
OUTPUT_ROOT = (REPOSITORY_ROOT / "output").resolve()
PUBLISHABLE = {"pdf", "tex", "log", "aux", "out", "toc", "fls", "fdb_latexmk", "synctex.gz"}


def emit(result: dict, exit_code: int = 0) -> None:
    print(json.dumps(result, separators=(",", ":")))
    raise SystemExit(exit_code)


def page_count(path: Path) -> int | None:
    if not path.is_file():
        return None
    match = re.search(r"Output written on .+? \((\d+) pages?[,)]", path.read_text(encoding="utf-8", errors="replace"), re.DOTALL)
    return int(match.group(1)) if match else None


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            value.update(chunk)
    return value.hexdigest()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-directory", required=True)
    parser.add_argument("--document-name", default="CV_Kostiantyn_Pysanyi")
    parser.add_argument("--version", type=int)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]*", args.document_name) or re.search(r"_version\d+$", args.document_name):
        raise ValueError("document-name must be a safe base filename and must not end with _versionN")
    if args.version is not None and args.version < 1:
        raise ValueError("version must be a positive integer")

    directory_arg = Path(args.output_directory).expanduser()
    directory = (directory_arg if directory_arg.is_absolute() else REPOSITORY_ROOT / directory_arg).resolve()
    if directory != OUTPUT_ROOT and OUTPUT_ROOT not in directory.parents:
        raise ValueError(f"The output directory must be located under {OUTPUT_ROOT}")
    if not directory.is_dir():
        raise FileNotFoundError(f"Output directory not found: {directory}")

    pattern = re.compile(rf"^{re.escape(args.document_name)}_version(\d+)\.(.+)$", re.IGNORECASE)
    versioned: list[tuple[Path, int, str]] = []
    for item in directory.iterdir():
        match = pattern.match(item.name) if item.is_file() else None
        if match:
            versioned.append((item, int(match.group(1)), match.group(2)))

    standard_pdf = directory / f"{args.document_name}.pdf"
    standard_tex = directory / f"{args.document_name}.tex"
    standard_pages = page_count(directory / f"{args.document_name}.log")
    standard_valid = standard_pdf.is_file() and standard_tex.is_file() and standard_pages is not None
    if not versioned:
        if standard_valid:
            emit({"status": "already_standard", "pdf_path": str(standard_pdf), "tex_path": str(standard_tex), "page_count": standard_pages, "cleanup": "not_needed"})
        raise FileNotFoundError(f"No validated standard PDF or versioned artifacts were found for {args.document_name}")

    versions = sorted({version for _, version, _ in versioned})
    successful = [version for version in versions if (directory / f"{args.document_name}_version{version}.pdf").is_file() and (directory / f"{args.document_name}_version{version}.tex").is_file() and page_count(directory / f"{args.document_name}_version{version}.log") is not None]
    if not successful:
        raise ValueError(f"No successfully compiled version was found for {args.document_name}")
    selected = args.version if args.version is not None else max(successful)
    if selected not in successful:
        raise ValueError(f"Version {selected} is not a successfully compiled version of {args.document_name}")

    stem = f"{args.document_name}_version{selected}"
    selected_files = [(path, extension) for path, version, extension in versioned if version == selected and extension in PUBLISHABLE]
    candidate_pdf = directory / f"{stem}.pdf"
    candidate_tex = directory / f"{stem}.tex"
    pages = page_count(directory / f"{stem}.log")

    with tempfile.TemporaryDirectory(prefix=".publish-", dir=directory) as staging_name:
        staging = Path(staging_name)
        for source, extension in selected_files:
            shutil.copy2(source, staging / f"{args.document_name}.{extension}")
        for staged in staging.iterdir():
            staged.replace(directory / staged.name)

    if digest(candidate_pdf) != digest(standard_pdf) or digest(candidate_tex) != digest(standard_tex):
        raise RuntimeError("Published standard files failed hash verification")

    cleanup_failures = []
    for path, _, _ in versioned:
        try:
            path.unlink()
        except OSError:
            cleanup_failures.append(str(path))
    status = "cleanup_pending" if cleanup_failures else "success"
    emit({"status": status, "selected_version": selected, "pdf_path": str(standard_pdf), "tex_path": str(standard_tex), "page_count": pages, "approximately_one_page": pages == 1, "cleanup_failures": cleanup_failures})


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        emit({"status": "error", "error": str(error)}, 2)
