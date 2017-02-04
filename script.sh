#!/bin/bash
BRANCH_NAME=$(head -20 /dev/urandom | md5)
git checkout origin master
git checkout -b $BRANCH_NAME -t origin/master
echo $BRANCH_NAME > branch.file
git add branch.file
git commit -m "Bump."
git push origin $BRANCH_NAME
echo "pushed branch $BRANCH_NAME"
PR=$(curl -H "Authorization: token $TOKEN" -XPOST https://api.github.com/repos/sampwing/make_pr/pulls --data "{\"title\": \"bump version\", \"head\": \"$BRANCH_NAME\", \"base\": \"master\"}")
git checkout master
git branch -d $BRANCH_NAME

echo "PR: $PR"
PR_NUMBER=$(python -c 'import sys, json; print json.load(sys.stdin)["number"]' <<< $PR)
echo "pr is: $PR_NUMBER"

echo "CREATING REVIEW"
REVIEW=$(curl -H "Authorization: token $TOKEN;Accept: application/vnd.github.black-cat-preview+json" -XPOST https://api.github.com/repos/sampwing/make_pr/pulls/$PR_NUMBER/reviews --data "{\"body\": \"bump version\", \"event\": \"APPROVE\"}")
echo "REVIEW: $REVIEW"

# PR_NUMBER=$(python -c 'import sys, json; print json.load(sys.stdin)["number"]' <<< $PR)
# echo "pr is: $PR_NUMBER"

MERGE=$(curl -H "Authorization: token $TOKEN;" -XPUT https://api.github.com/repos/sampwing/make_pr/pulls/$PR_NUMBER/merge ) # --data "{\"body\": \"bump version\", \"event\": \"APPROVE\"}")
echo "MERGE: $MERGE"

git push origin :$BRANCH_NAME
# curl --header "Authorization: token $TOKEN" -XPOST https://api.github.com/repos/sampwing/make_pr/pulls --data "{\"title\": \"bump version\", \"base\": \"$BRANCH_NAME\", \"head\": \"master\"}" 
