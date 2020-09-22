#!/bin/bash

# Get Google Cloud project id
PROJECT_ID=$(gcloud config get-value project)

# Make bucket
gsutil mb gs://${PROJECT_ID}-tfstate
gsutil versioning set on gs://${PROJECT_ID}-tfstate

# Replace bucket name in code
# Mac
if [ "$(uname)" = "Darwin" ]; then
    echo "Mac"
    sed -i "" -e s/PROJECT_ID/$PROJECT_ID/g environments/*/terraform.tfvars
    sed -i "" -e s/PROJECT_ID/$PROJECT_ID/g environments/*/backend.tf
fi
# Linux
if [ "$(uname)" = "Linux" ]; then
    echo "Linux"
    sed -i s/PROJECT_ID/$PROJECT_ID/g environments/*/terraform.tfvars
    sed -i s/PROJECT_ID/$PROJECT_ID/g environments/*/backend.tf
fi