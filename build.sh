#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix deps.get
MIX_ENV=prod mix compile

# Compile assets
npm install --prefix ./assets
mix phx.digest

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite
