#!/usr/bin/env bash
set -euo pipefail

APP_NAME="$1"
APP_DIR="${PWD}/fleet-applications/${APP_NAME}"
REPO_DIR="${PWD}/fleet-repos"
DIRECTORIES=(
  "app"
  "config"
  "deps"
)

echo -e "\n🆕 Creating application directory template: $APP_NAME..."
for dir in "${DIRECTORIES[@]}"; do
  mkdir -p "${APP_DIR}/${dir}"
  touch "${APP_DIR}/${dir}/fleet.yaml"  # This creates a file named "fleet.yaml" in each directory
done

touch "${REPO_DIR}/repository-values/${APP_NAME}.yaml"  # This creates a file named "repository-values/${APP_NAME}.yaml" in the repo directory

echo "✅ Directory template for APP '$APP_NAME' created successfully"
echo ""
echo "Created the following structure:"
tree "$APP_DIR" 2>/dev/null || find "$APP_DIR" -type f | sort