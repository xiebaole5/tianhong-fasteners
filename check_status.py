#!/usr/bin/env python3
"""
Check GitHub Actions deployment status
"""

import requests
import time

TOKEN = "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"
USERNAME = "xiebaole5"
REPO_NAME = "tianhong-fasteners"

def check_actions_status():
    """Check GitHub Actions workflow status"""
    headers = {
        "Authorization": f"token {TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    print("Checking GitHub Actions deployment status...\n")
    
    # Get workflow runs
    response = requests.get(
        f"https://api.github.com/repos/{USERNAME}/{REPO_NAME}/actions/runs",
        headers=headers
    )
    
    if response.status_code == 200:
        runs = response.json().get('workflow_runs', [])
        
        if runs:
            latest_run = runs[0]
            print(f"✓ Latest Workflow: {latest_run['name']}")
            print(f"  Status: {latest_run['status']}")
            print(f"  Conclusion: {latest_run.get('conclusion', 'N/A')}")
            print(f"  Run Number: #{latest_run['run_number']}")
            print(f"  Created: {latest_run['created_at']}")
            
            if latest_run.get('html_url'):
                print(f"\n  View Details: {latest_run['html_url']}")
            
            return latest_run
        else:
            print("No workflow runs found yet.")
            return None
    else:
        print(f"✗ Failed to get workflow status: {response.status_code}")
        return None

def check_pages_status():
    """Check GitHub Pages status"""
    headers = {
        "Authorization": f"token {TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    print("\n" + "=" * 70)
    print("GitHub Pages Status")
    print("=" * 70)
    
    response = requests.get(
        f"https://api.github.com/repos/{USERNAME}/{REPO_NAME}/pages",
        headers=headers
    )
    
    if response.status_code == 200:
        data = response.json()
        print(f"✓ Pages Status: {data.get('status', 'unknown')}")
        
        if data.get('html_url'):
            print(f"\n🎉 Website URL: {data['html_url']}")
        
        if data.get('custom_environments'):
            print(f"\nCustom Environments:")
            for env in data['custom_environments']:
                print(f"  - {env['name']}: {env.get('url', 'N/A')}")
        
        return data
    else:
        print(f"✗ Could not get Pages status: {response.status_code}")
        return None

def print_summary():
    """Print deployment summary"""
    print("\n" + "=" * 70)
    print("Deployment Summary")
    print("=" * 70)
    print(f"\nRepository: https://github.com/{USERNAME}/{REPO_NAME}")
    print(f"GitHub Pages: https://{USERNAME}.github.io/{REPO_NAME}/")
    print(f"\nNext Steps:")
    print("1. Wait for GitHub Actions to complete deployment")
    print("2. Check GitHub Actions tab for build status")
    print("3. Once deployed, visit your GitHub Pages URL")
    print("4. (Optional) Configure Cloudflare Pages for faster global access")

if __name__ == "__main__":
    print("=" * 70)
    print("GitHub Deployment Status Monitor")
    print("=" * 70)
    
    check_actions_status()
    check_pages_status()
    print_summary()
