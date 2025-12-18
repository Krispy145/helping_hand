#!/bin/bash

# Usage: ./scripts/deploy.sh [dev|staging|prod]

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./scripts/deploy.sh [dev|staging|prod]"
  exit 1
fi

if [ "$ENV" == "dev" ]; then
  echo "Triggering Release: Dev..."
  gh workflow run release_dev.yml
elif [ "$ENV" == "staging" ]; then
  echo "Triggering Release: Staging..."
  gh workflow run release_staging.yml
elif [ "$ENV" == "prod" ]; then
  echo "Triggering Release: Production..."
  gh workflow run release_prod.yml
else
  echo "Invalid environment. Use dev, staging, or prod."
  exit 1
fi
