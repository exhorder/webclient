#!/bin/bash -x

# Get the current branch
currentBranch=$(git rev-parse --abbrev-ref HEAD)

# Checkout the translations branch
git checkout translations

# Make sure it's up to date
git pull

# Change to the lang directory
cd $(dirname $BASH_SOURCE)/../lang

# Remove all files in the language directory (in case we removed some languages in the code)
rm *.json
rm lang.tar.gz

# Fetch the latest translations from Babel
data=$(php -f ./translation.php);
wget --post-data='u=Jq1EXnelOeQpj7UCaBa1&id=fetch&s=6&ids='$data https://babel.mega.co.nz -O lang.tar.gz

# Extract the tar.gz file
tar xfvz lang.tar.gz

# Delete it
rm lang.tar.gz

# Add the .json files
git add *.json

# Commit it
git commit -m 'Updated strings from Babel'

# Push it to the translations branch
git push

# Check out the previous branch again
git checkout $currentBranch

# Merge translations branch into the current branch
git merge translations -m "Merge branch 'translations' into $currentBranch"