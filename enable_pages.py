#!/usr/bin/env python3
"""
Enable GitHub Pages via API
"""

import requests

TOKEN = "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"
USERNAME = "xiebaole5"
REPO_NAME = "tianhong-fasteners"

def enable_github_pages():
    """Enable GitHub Pages for the repository"""
    headers = {
        "Authorization": f"token {TOKEN}",
        "Accept": "application/vnd.github.v3+json",
        "Content-Type": "application/json"
    }
    
    # First, get the current settings
    print("Getting current repository settings...")
    response = requests.get(
        f"https://api.github.com/repos/{USERNAME}/{REPO_NAME}/pages",
        headers=headers
    )
    
    if response.status_code == 200:
        print("✓ GitHub Pages is already enabled!")
        print(f"  Status: {response.json().get('status', 'unknown')}")
        return response.json()
    elif response.status_code == 404:
        # Pages not configured, let's configure it
        print("Configuring GitHub Pages...")
        data = {
            "source": {
                "branch": "master",
                "path": "/"
            }
        }
        
        response = requests.post(
            f"https://api.github.com/repos/{USERNAME}/{REPO_NAME}/pages",
            headers=headers,
            json=data
        )
        
        if response.status_code in [201, 202]:
            print("✓ GitHub Pages enabled successfully!")
            return response.json()
        else:
            print(f"✗ Failed to enable Pages: {response.status_code}")
            print(f"  Response: {response.text}")
            return None
    else:
        print(f"✗ Error checking Pages: {response.status_code}")
        return None

def get_deployment_status():
    """Check deployment status"""
    headers = {
        "Authorization": f"token {TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    print("\nChecking deployment status...")
    response = requests.get(
        f"https://api.github.com/repos/{USERNAME}/{REPO_NAME}/pages",
        headers=headers
    )
    
    if response.status_code == 200:
        data = response.json()
        print("✓ Deployment Status:")
        print(f"  Status: {data.get('status', 'unknown')}")
        print(f"  URL: {data.get('url', 'N/A')}")
        
        if data.get('html_url'):
            print(f"\n🎉 Your website is live at:")
            print(f"   {data['html_url']}")
        
        return data
    else:
        print(f"✗ Could not get deployment status: {response.status_code}")
        return None

if __name__ == "__main__":
    print("=" * 70)
    print("GitHub Pages Configuration")
    print("=" * 70)
    
    # Enable Pages
    result = enable_github_pages()
    
    if result:
        # Get final status
        get_deployment_status()
        
        print("\n" + "=" * 70)
        print("✓ GitHub Pages setup initiated!")
        print("=" * 70)
        print("\nYour site will be deployed automatically by GitHub Actions.")
        print("This may take a few minutes.")
        print(f"\nGitHub Pages URL: https://{USERNAME}.github.io/{REPO_NAME}/")
