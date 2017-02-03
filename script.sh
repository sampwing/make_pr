#!/bin/bash
BRANCH_NAME=$(head -20 /dev/urandom | md5)
git checkout -b $BRANCH_NAME
git add .
git push origin $BRANCH_NAME
echo "pushed branch $BRANCH_NAME"
curl --user "$USERNAME:$PASSWORD" -XPOST https://api.github.com/repos/sampwing/make_pr/pulls --data "{\"title\": \"bump version\", \"head\": \"$BRANCH_NAME\", \"base\": \"master\"}"
