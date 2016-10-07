#!/usr/bin/env bash

set -e

VERSION=$(git rev-list --all --count)

npm install

rm -rf dist
mkdir dist

zip -r dist/rolling-update-notifier.zip index.js node_modules

sed "s/%%VERSION%%/${VERSION}/g" rolling-update-notifier.yaml > dist/rolling-update-notifier.yaml

# Global files
aws s3 --region eu-central-1 cp dist/rolling-update-notifier.yaml s3://taimos-cfn-public/templates/rolling-update-notifier.yaml

# Regional files
array=( eu-west-1 eu-central-1 )
for i in "${array[@]}"
do
    aws s3 --region ${i} cp dist/rolling-update-notifier.zip s3://taimos-lambda-public-${i}/rolling-update-notifier-${VERSION}.zip
done
