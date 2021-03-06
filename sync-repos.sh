#!/bin/sh

SOURCE_REPOSITORY_NAME=cytroconnect.com
SOURCE_URL=git@bitbucket.org:consultconnect/$SOURCE_REPOSITORY_NAME
TARGET_URL=git@github.com:cytroconnect/cytroconnect.github.io.git

eval "$(ssh-agent)"

echo "adding previously exported private key (from environment variable)"
ssh-add ~/.ssh/id_rsa
if [ "$?" != "0" ]; then
  echo "Failed to load source ssh key"
  exit 1
fi

echo "Deleting any old source that may exist"
rm -rf $SOURCE_REPOSITORY_NAME

echo "Checking out the source repository"
git clone $SOURCE_URL

if [ "$?" != "0" ]; then
  echo "Failed to clone source"
  exit 1
fi

echo "Entering the checked out repository"
cd $SOURCE_REPOSITORY_NAME

echo "Downloading the source repository"
git fetch origin --tags

if [ "$?" != "0" ]; then
  echo "Failed to fetch origin"
  exit 1
fi

echo "Adding the target as mirror remote"
git remote add --mirror=fetch target $TARGET_URL

if [ "$?" != "0" ]; then
  echo "Failed to add target as remote: $TARGET_URL"
  exit 1
fi

echo "Copying all data from the source to the target repository"
git push target --all --force

if [ "$?" != "0" ]; then
  echo "Failed to push to target"
  exit 1
fi

cd ..

echo "Deleting any old source that may exist"
rm -rf $SOURCE_REPOSITORY_NAME