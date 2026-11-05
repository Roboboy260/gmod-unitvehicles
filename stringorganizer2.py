#!/usr/bin/env python3
"""
sync_localizations.py
"""

import os
import shutil
import tkinter as tk
from tkinter import simpledialog, messagebox

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

ROOT = os.path.join(SCRIPT_DIR, "resource", "localization")
BACKUP_ROOT = os.path.join(SCRIPT_DIR, "resource_bak", "localization")
DEV_BACKUP_ROOT = os.path.join(SCRIPT_DIR, "_for developers", "Localization Backup")

EXCLUDE_DIR = "en"
ENCODING = "utf-8"


# ---------------------------------------------------------------------
# Utility
# ---------------------------------------------------------------------

def read_lines(path):
    with open(path, "r", encoding=ENCODING, errors="replace") as f:
        return [line.rstrip("\n") for line in f.readlines()]


def write_lines(path, lines):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding=ENCODING, newline="\r\n") as f:
        for ln in lines:
            f.write(ln + "\n")


def is_comment_or_blank(line):
    s = line.strip()
    return s == "" or s.startswith("#")


def parse_key_values(lines):
    result = {}
    for ln in lines:
        stripped = ln.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if "=" in ln:
            k, v = ln.split("=", 1)
            result[k.strip()] = v.strip()
    return result


# ---------------------------------------------------------------------
# English structure parsing
# ---------------------------------------------------------------------

def parse_english_sequence(lines):
    seq = []
    effective = lines[2:] if len(lines) >= 2 else lines[:]
    buf_comments = []

    for line in effective:
        if is_comment_or_blank(line):
            buf_comments.append(line)
            continue

        if "=" in line:
            if buf_comments:
                seq.append(("comment", list(buf_comments)))
                buf_comments = []
            key = line.split("=", 1)[0].strip()
            seq.append(("key", key, line))
        else:
            buf_comments.append(line)

    if buf_comments:
        seq.append(("comment", list(buf_comments)))

    return seq


def build_english_context_map(base_sequence):
    context_map = {}
    last_comments = []

    for item in base_sequence:
        if item[0] == "comment":
            last_comments = item[1]
        elif item[0] == "key":
            key = item[1]
            context_map[key] = list(last_comments)

    return context_map


# ---------------------------------------------------------------------
# Target parsing
# ---------------------------------------------------------------------

def parse_target_file(lines):
    first_two = lines[:2] if len(lines) >= 2 else lines[:]

    active = {}
    commented = {}

    for ln in lines:
        stripped = ln.strip()
        if not stripped:
            continue

        if stripped.startswith("#"):
            after = stripped.lstrip("#").lstrip()
            if "=" in after:
                k = after.split("=", 1)[0].strip()
                commented[k] = ln
            continue

        if "=" in ln:
            k, v = ln.split("=", 1)
            active[k.strip()] = v.strip()

    return first_two, active, commented


# ---------------------------------------------------------------------
# English backup comparison
# ---------------------------------------------------------------------

def detect_changed_english_keys(filename, base_lines):
    dev_en_dir = os.path.join(DEV_BACKUP_ROOT, "en")
    os.makedirs(dev_en_dir, exist_ok=True)
    backup_path = os.path.join(dev_en_dir, filename)

    if not os.path.isfile(backup_path):
        write_lines(backup_path, base_lines)
        return set(), {}, False

    old_lines = read_lines(backup_path)
    old_map = parse_key_values(old_lines)
    new_map = parse_key_values(base_lines)

    changed = set()
    renamed = {}

    # Build reverse maps
    old_values_to_keys = {}
    for k, v in old_map.items():
        old_values_to_keys.setdefault(v.strip(), []).append(k)

    new_values_to_keys = {}
    for k, v in new_map.items():
        new_values_to_keys.setdefault(v.strip(), []).append(k)

    for new_key, new_value in new_map.items():
        new_value = new_value.strip()

        # Case 1: Same key but value changed
        if new_key in old_map:
            if old_map[new_key] != new_value and new_value:
                changed.add(new_key)

        # Case 2: Possible rename
        else:
            if (
                new_value in old_values_to_keys
                and len(old_values_to_keys[new_value]) == 1
                and len(new_values_to_keys[new_value]) == 1
            ):
                old_key = old_values_to_keys[new_value][0]

                if old_key not in new_map:
                    renamed[old_key] = new_key

    write_lines(backup_path, base_lines)
    return changed, renamed, True

# ---------------------------------------------------------------------
# OLD file management
# ---------------------------------------------------------------------

def append_to_old_file(lang_dir, filename, key, localized_value,
                       context_map, base_sequence):

    old_filename = filename.replace(".properties", "_old.properties")
    old_path = os.path.join(lang_dir, old_filename)

    if os.path.isfile(old_path):
        old_lines = read_lines(old_path)
    else:
        old_lines = []

    existing_keys = set()
    for ln in old_lines:
        stripped = ln.strip()
        if stripped.startswith("#") and "=" in stripped:
            k = stripped.lstrip("#").lstrip().split("=", 1)[0].strip()
            existing_keys.add(k)

    if key in existing_keys:
        return  # do not duplicate

    insertion_index = len(old_lines)

    english_key_order = [
        item[1] for item in base_sequence if item[0] == "key"
    ]

    if key in english_key_order:
        key_pos = english_key_order.index(key)
        for i, ln in enumerate(old_lines):
            stripped = ln.strip()
            if stripped.startswith("#") and "=" in stripped:
                existing_key = stripped.lstrip("#").lstrip().split("=", 1)[0].strip()
                if existing_key in english_key_order:
                    if english_key_order.index(existing_key) > key_pos:
                        insertion_index = i
                        break

    block = []

    comments = context_map.get(key, [])
    for c in comments:
        if c not in old_lines:
            block.append(c)

    block.append(f"# {key}={localized_value}")

    if insertion_index < len(old_lines):
        new_lines = (
            old_lines[:insertion_index]
            + block
            + [""]
            + old_lines[insertion_index:]
        )
    else:
        if old_lines and old_lines[-1].strip():
            old_lines.append("")
        new_lines = old_lines + block + [""]

    write_lines(old_path, new_lines)


# ---------------------------------------------------------------------
# Sync logic
# ---------------------------------------------------------------------

def sync_file(base_sequence, base_lines, target_path,
              rel_lang_folder, filename,
              changed_keys, renamed_keys, context_map):

    print(f"Processing {rel_lang_folder}/{filename} ...")

    target_lines = read_lines(target_path)
    first_two, active_values, commented_key_lines = parse_target_file(target_lines)
    
    # -------------------------------------------------
    # Apply key renames (same value, different key name)
    # -------------------------------------------------
    for old_key, new_key in renamed_keys.items():
        if old_key in active_values:
            active_values[new_key] = active_values.pop(old_key)
        if old_key in commented_key_lines:
            commented_key_lines[new_key] = commented_key_lines.pop(old_key)

    out_lines = []
    removed_keys = []

    if first_two:
        out_lines.extend(first_two)
    else:
        out_lines.extend(base_lines[:2])

    for item in base_sequence:
        if item[0] == "comment":
            out_lines.extend(item[1])
            continue

        _, key, english_line = item

        if key in changed_keys:
            if key in active_values:
                removed_keys.append((key, active_values[key]))
            out_lines.append("# " + english_line)
            continue

        if key in active_values:
            out_lines.append(f"{key}={active_values[key]}")
        elif key in commented_key_lines:
            out_lines.append("# " + english_line)
        else:
            out_lines.append("# " + english_line)

    ensure_backup(target_path, rel_lang_folder, filename)
    write_lines(target_path, out_lines)

    if removed_keys:
        lang_dir = os.path.dirname(target_path)
        for key, value in removed_keys:
            append_to_old_file(
                lang_dir,
                filename,
                key,
                value,
                context_map,
                base_sequence
            )

    print(f" → Updated {rel_lang_folder}/{filename}")


def ensure_backup(target_path, rel_lang_folder, filename):
    backup_dir = os.path.join(BACKUP_ROOT, rel_lang_folder)
    os.makedirs(backup_dir, exist_ok=True)
    shutil.copy2(target_path, os.path.join(backup_dir, filename))


# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------

def main():
    root = tk.Tk()
    root.withdraw()

    fname = simpledialog.askstring(
        "Localization sync",
        "Enter base filename (without .properties):",
        initialvalue="unitvehicles",
        parent=root,
    )

    if not fname:
        return

    filename = fname.strip() + ".properties"
    base_path = os.path.join(ROOT, "en", filename)

    if not os.path.isfile(base_path):
        messagebox.showerror("File not found", base_path)
        return

    base_lines = read_lines(base_path)
    base_sequence = parse_english_sequence(base_lines)
    context_map = build_english_context_map(base_sequence)

    changed_keys, renamed_keys, has_backup = detect_changed_english_keys(filename, base_lines)

    langs = [
        name for name in os.listdir(ROOT)
        if os.path.isdir(os.path.join(ROOT, name)) and name != EXCLUDE_DIR
    ]

    os.makedirs(BACKUP_ROOT, exist_ok=True)

    for lang in sorted(langs):
        target_file = os.path.join(ROOT, lang, filename)
        if not os.path.isfile(target_file):
            continue

        sync_file(
            base_sequence,
            base_lines,
            target_file,
            lang,
            filename,
            changed_keys if has_backup else set(),
            renamed_keys if has_backup else {},
            context_map
        )

    messagebox.showinfo("Completed", "Localization sync complete.")


if __name__ == "__main__":
    main()