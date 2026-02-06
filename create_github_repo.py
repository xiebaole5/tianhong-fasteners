#!/usr/bin/env python3
"""
GitHub Repository Creation Script
Creates tianhong-fasteners repository and pushes local code
"""

import requests
import subprocess
import json
import os

# GitHub Token (use with caution)
TOKEN = "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"
GITHUB_API = "https://api.github.com"
REPO_NAME = "tianhong-fasteners"

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
    
    print(f"Creating repository: {REPO_NAME}")
    response = requests.post(f"{GITHUB_API}/user/repos", headers=headers, json=data)
    
    if response.status_code == 201:
        print(f"✓ Repository created successfully!")
        repo_url = response.json()["html_url"]
        print(f"  URL: {repo_url}")
        return repo_url
    elif response.status_code == 422:
        print(f"⚠ Repository might already exist. Error: {response.json()}")
        return f"{GITHUB_API}/xiebaole5/{REPO_NAME}"
    else:
        print(f"✗ Failed to create repository: {response.status_code}")
        print(f"  Response: {response.text}")
        return None

def push_to_github(repo_url):
    """Push local code to GitHub"""
    if not repo_url:
        return False
    
    try:
        # Add remote if not exists
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
            print(f"✓ Added remote origin: {repo_url}")
        
        # Push to GitHub
        subprocess.run(
            ["git", "push", "-u", "origin", "master"],
            check=True,
            cwd=os.getcwd()
        )
        print("✓ Code pushed to GitHub successfully!")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"✗ Git push failed: {e}")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("GitHub Repository Creation and Deployment")
    print("=" * 60)
    
    # Create repository
    repo_url = create_github_repo()
    
    if repo_url:
        # Push to GitHub
        push_to_github(repo_url)
        
        print("\n" + "=" * 60)
        print("Next Steps:")
        print("=" * 60)
        print(f"1. Visit: {repo_url}")
        print("2. Go to Settings → Pages")
        print("3. Enable GitHub Pages from 'main' branch")
        print("4. Your site will be live at:")
        print(f"   https://xiebaole5.github.io/{REPO_NAME}/")
