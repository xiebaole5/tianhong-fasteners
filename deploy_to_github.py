#!/usr/bin/env python3
"""
GitHub Repository Creation and Deployment Script
Creates tianhong-fasteners repository and pushes local code
"""

import requests
import subprocess
import json
import os
import sys

# GitHub Token
TOKEN = "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"
GITHUB_API = "https://api.github.com"
REPO_NAME = "tianhong-fasteners"
USERNAME = "xiebaole5"

def create_github_repo():
    """Create GitHub repository"""
    headers = {
        "Authorization": f"token {TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    data = {
        "name": REPO_NAME,
        "description": "浙江天宏紧固件有限公司 - 外贸独立站 | Tianhong Fasteners Co., Ltd. - International Trade Website",
        "homepage": "https://tianhong-fasteners.pages.dev",
        "private": False,
        "has_issues": True,
        "has_projects": True,
        "has_wiki": False,
        "auto_init": False
    }
    
    print(f"Step 1: Creating repository: {REPO_NAME}")
    response = requests.post(f"{GITHUB_API}/user/repos", headers=headers, json=data)
    
    if response.status_code == 201:
        repo_url = response.json()["html_url"]
        print(f"✓ Repository created successfully!")
        print(f"  URL: {repo_url}")
        return repo_url
    elif response.status_code == 422:
        print(f"⚠ Repository might already exists")
        return f"https://github.com/{USERNAME}/{REPO_NAME}"
    else:
        print(f"✗ Failed to create repository: {response.status_code}")
        print(f"  Response: {response.text}")
        return None

def push_to_github(repo_url):
    """Push local code to GitHub"""
    if not repo_url:
        return False
    
    try:
        # Check if remote exists
        result = subprocess.run(
            ["git", "remote", "get", "origin"],
            capture_output=True,
            text=True,
            cwd=os.getcwd()
        )
        
        if result.returncode != 0:
            subprocess.run(
                ["git", "remote", "add", "origin", repo_url],
                check=True,
                cwd=os.getcwd()
            )
            print(f"✓ Added remote origin")
        
        # Push to GitHub
        print(f"Step 2: Pushing code to GitHub...")
        subprocess.run(
            ["git", "push", "-u", "origin", "master"],
            check=True,
            cwd=os.getcwd()
        )
        print("✓ Code pushed successfully!")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"✗ Git push failed: {e}")
        return False

if __name__ == "__main__":
    print("=" * 70)
    print("GitHub Repository Creation and Deployment")
    print("=" * 70)
    
    # Create repository
    repo_url = create_github_repo()
    
    if repo_url:
        # Push to GitHub
        success = push_to_github(repo_url)
        
        if success:
            print("\n" + "=" * 70)
            print("✓ Deployment initiated successfully!")
            print("=" * 70)
            print(f"\nRepository URL: {repo_url}")
            print(f"GitHub Pages URL: https://{USERNAME}.github.io/{REPO_NAME}/")
            print(f"\nNext Steps:")
            print("1. Visit the repository URL")
            print("2. Go to Settings → Pages")
            print("3. Enable GitHub Pages from 'master' branch")
            print("4. Your site will be live at the URL above")
