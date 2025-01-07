#!/bin/bash

# release-script.sh
# This script follows GitLab flow for releasing a Node.js application.
# It updates the version in package.json and package-lock.json files,
# creates a release branch, tags the release, and merges changes back to main.

set -e # Exit immediately if a command exits with a non-zero status

# Function to display usage information
usage() {
    echo "Usage: $0 <release-version>"
    echo "Example: $0 1.2.3"
    exit 1
}

# Function to validate the release version format
validate_version() {
    if ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Invalid version format. Please use semantic versioning (e.g., 1.2.3)"
        exit 1
    fi
}

# Check if a release version is provided
if [ $# -ne 1 ]; then
    usage
fi

RELEASE_VERSION=$1

# Validate the release version
validate_version $RELEASE_VERSION

# Ensure we're on the main branch
if [ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]; then
    echo "Error: Not on main branch. Please switch to main branch before running this script."
    exit 1
fi

# Ensure the working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "Error: Working directory is not clean. Please commit or stash your changes."
    exit 1
fi

# Pull the latest changes from the remote main branch
echo "Pulling latest changes from remote main branch..."
git pull origin main

# Create a new release branch
RELEASE_BRANCH="release-$RELEASE_VERSION"
echo "Creating release branch: $RELEASE_BRANCH"
git checkout -b $RELEASE_BRANCH

# Update the version in package.json and package-lock.json
echo "Updating version to $RELEASE_VERSION in package.json and package-lock.json..."
npm version $RELEASE_VERSION --include-workspace-root --workspaces --no-git-tag-version

# Commit the version update
git add .
git commit -m "Bump version to $RELEASE_VERSION"

# Push the release branch to remote
echo "Pushing release branch to remote..."
git push -u origin $RELEASE_BRANCH

# Create and push the release tag
echo "Creating and pushing release tag..."
git tag -a "v$RELEASE_VERSION" -m "Release $RELEASE_VERSION"
git push origin "v$RELEASE_VERSION"

# Checkout the releases branch and merge the release
echo "Merging release into releases branch..."
git checkout releases
git pull origin releases
git merge --no-ff $RELEASE_BRANCH -m "Merge release $RELEASE_VERSION into releases"
git push origin releases

# Merge changes back to main
echo "Merging changes back to main branch..."
git checkout main
git merge --no-ff $RELEASE_BRANCH -m "Merge release $RELEASE_VERSION into main"
git push origin main

# Clean up: delete the local release branch
echo "Cleaning up: deleting local release branch..."
git branch -d $RELEASE_BRANCH

echo "Release $RELEASE_VERSION completed successfully!"
