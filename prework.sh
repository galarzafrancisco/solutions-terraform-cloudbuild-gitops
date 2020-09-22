#!/bin/bash

# Based on Managing Infrastructure as Code, by Google
# https://cloud.google.com/solutions/managing-infrastructure-as-code

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


# Grant permissions to the Cloud Build service account
CLOUDBUILD_SA="$(gcloud projects describe $PROJECT_ID \
    --format 'value(projectNumber)')@cloudbuild.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$CLOUDBUILD_SA --role roles/editor