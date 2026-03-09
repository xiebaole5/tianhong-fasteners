#!/usr/bin/env python3
"""
replace-placeholder-images.py
──────────────────────────────────────────────────────────────────────────────
Automation script for replacing placeholder product category images with real
photos once the user uploads them.

Usage:
  python3 scripts/replace-placeholder-images.py --help
  python3 scripts/replace-placeholder-images.py --list
  python3 scripts/replace-placeholder-images.py --replace <category> <image_path>
  python3 scripts/replace-placeholder-images.py --replace-all <mapping_file>

Examples:
  # List all current placeholder mappings
  python3 scripts/replace-placeholder-images.py --list

  # Replace a single category image (e.g., Nuts)
  python3 scripts/replace-placeholder-images.py --replace 螺母类 /path/to/real-nuts-photo.jpg

  # Replace all categories from a JSON mapping file
  python3 scripts/replace-placeholder-images.py --replace-all my_images.json

Mapping file format (JSON):
  {
    "螺母类":   "images/products/real-nuts.jpg",
    "螺栓类":   "images/products/real-bolts.jpg",
    "螺钉类":   "images/products/real-screws.jpg",
    "铆钉类":   "images/products/real-rivets.jpg",
    "铅封螺钉": "images/products/real-security-screws.jpg",
    "非标件":   "images/products/real-custom.jpg",
    "嵌件类":   "images/products/real-inserts.jpg",
    "套管类":   "images/products/real-sleeves.jpg",
    "销轴类":   "images/products/real-pins.jpg"
  }
──────────────────────────────────────────────────────────────────────────────
"""

import argparse
import json
import os
import shutil
import sys
from pathlib import Path

# ── Paths ──────────────────────────────────────────────────────────────────
REPO_ROOT = Path(__file__).resolve().parent.parent
DATA_FILE = REPO_ROOT / "data" / "products_data.json"
PRODUCTS_IMG_DIR = REPO_ROOT / "images" / "products"

# ── Current placeholder mapping (category_zh → placeholder image path) ────
PLACEHOLDERS = {
    "螺母类":   "images/products/stainless-nuts.jpg",
    "螺栓类":   "images/products/hex-bolt-1.png",
    "铆钉类":   "images/products/fastener-assembly.jpg",
    "螺钉类":   "images/products/hex-socket-screw.webp",
    "铅封螺钉": "images/products/dacromet-bolt.webp",
    "非标件":   "images/products/custom-fasteners.jpg",
    "嵌件类":   "images/products/special-fasteners.jpg",
    "套管类":   "images/products/stainless-hex-bolt.jpg",
    "销轴类":   "images/products/zinc-plated-bolt.jpg",
}


def load_data():
    with open(DATA_FILE, encoding="utf-8") as f:
        return json.load(f)


def save_data(data):
    with open(DATA_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"✅ Saved: {DATA_FILE}")


def list_placeholders():
    """Print current category → placeholder image mapping."""
    print("\nCurrent placeholder image mapping:")
    print(f"{'Category (ZH)':<16} {'Current Image':<45} {'File exists?'}")
    print("-" * 80)
    for cat, img_path in PLACEHOLDERS.items():
        full_path = REPO_ROOT / img_path
        exists = "✅" if full_path.exists() else "❌ MISSING"
        print(f"{cat:<16} {img_path:<45} {exists}")
    print()


def copy_image(src_path: Path, dest_dir: Path, dest_filename: str) -> str:
    """Copy an image to the products directory and return the relative web path."""
    dest_dir.mkdir(parents=True, exist_ok=True)
    dest_path = dest_dir / dest_filename
    shutil.copy2(src_path, dest_path)
    rel_path = f"images/products/{dest_filename}"
    print(f"  Copied: {src_path} → {dest_path}")
    return rel_path


def replace_category(category_zh: str, new_image_path: str, data: dict) -> dict:
    """
    Replace the placeholder image for one category.
    Updates both the category metadata and all products in that category.
    """
    src = Path(new_image_path).resolve()
    if not src.exists():
        print(f"❌ Error: Image not found: {src}", file=sys.stderr)
        sys.exit(1)

    # Determine destination filename
    dest_filename = f"{category_zh.replace('/', '-')}{src.suffix}"
    rel_path = copy_image(src, PRODUCTS_IMG_DIR, dest_filename)

    # Update category metadata
    updated_cats = 0
    for cat in data["meta"]["categories"]:
        if cat["zh"] == category_zh:
            cat["image"] = rel_path
            updated_cats += 1

    # Update all products in this category
    updated_prods = 0
    old_placeholder = PLACEHOLDERS.get(category_zh, "")
    for p in data["products"]:
        if p.get("category_zh") == category_zh:
            # Only replace if still using the placeholder
            if not old_placeholder or p.get("image") == old_placeholder:
                p["image"] = rel_path
                updated_prods += 1

    if updated_cats == 0:
        print(f"⚠️  Warning: Category '{category_zh}' not found in metadata.")
    else:
        print(f"  Updated category metadata: {updated_cats} entry")
    print(f"  Updated product records: {updated_prods} items")

    return data


def replace_all(mapping_file: str):
    """Replace all category images from a JSON mapping file."""
    mp = Path(mapping_file).resolve()
    if not mp.exists():
        print(f"❌ Error: Mapping file not found: {mp}", file=sys.stderr)
        sys.exit(1)

    with open(mp, encoding="utf-8") as f:
        mapping = json.load(f)

    data = load_data()
    for cat_zh, img_path in mapping.items():
        print(f"\n🔄 Replacing image for: {cat_zh}")
        data = replace_category(cat_zh, img_path, data)

    save_data(data)
    print(f"\n✅ Done. Replaced {len(mapping)} category images.")
    print("\n📌 Next steps:")
    print("   1. Verify the new images in your browser")
    print("   2. Commit and push: git add data/products_data.json images/products/ && git commit -m 'chore: replace placeholder images with real product photos'")


def replace_single(category_zh: str, image_path: str):
    """Replace image for a single category."""
    print(f"\n🔄 Replacing image for: {category_zh}")
    data = load_data()
    data = replace_category(category_zh, image_path, data)
    save_data(data)
    print("\n✅ Done.")
    print("\n📌 Next steps:")
    print("   1. Verify the new image in your browser")
    print(f"   2. Commit: git add data/products_data.json images/products/ && git commit -m 'feat: replace {category_zh} placeholder with real photo'")


def generate_sample_mapping():
    """Print a sample mapping JSON that the user can fill in."""
    sample = {cat: f"/path/to/real-{cat.replace('/', '-')}-photo.jpg" for cat in PLACEHOLDERS}
    print("\nSample mapping file (save as my_images.json and fill in real paths):\n")
    print(json.dumps(sample, ensure_ascii=False, indent=2))
    print()


def main():
    parser = argparse.ArgumentParser(
        description="Replace placeholder product images with real photos.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--list", action="store_true", help="List current placeholder mappings")
    group.add_argument("--replace", nargs=2, metavar=("CATEGORY_ZH", "IMAGE_PATH"),
                       help="Replace a single category image")
    group.add_argument("--replace-all", metavar="MAPPING_JSON",
                       help="Replace all category images from a JSON mapping file")
    group.add_argument("--sample-mapping", action="store_true",
                       help="Print a sample mapping JSON template")

    args = parser.parse_args()

    if args.list:
        list_placeholders()
    elif args.replace:
        replace_single(args.replace[0], args.replace[1])
    elif args.replace_all:
        replace_all(args.replace_all)
    elif args.sample_mapping:
        generate_sample_mapping()


if __name__ == "__main__":
    main()
