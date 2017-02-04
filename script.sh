#!/bin/bash
BRANCH_NAME=$(head -20 /dev/urandom | md5)
git checkout origin master
git checkout -b $BRANCH_NAME -t origin/master
git add script.sh
git commit -c "Bump."
git push origin $BRANCH_NAME
echo "pushed branch $BRANCH_NAME"
curl --header "Authorization: token $TOKEN" -XPOST https://api.github.com/repos/sampwing/make_pr/pulls --data "{\"title\": \"bump version\", \"head\": \"$BRANCH_NAME\", \"base\": \"master\"}" 
# curl --header "Authorization: token $TOKEN" -XPOST https://api.github.com/repos/sampwing/make_pr/pulls --data "{\"title\": \"bump version\", \"base\": \"$BRANCH_NAME\", \"head\": \"master\"}" 
