#!/usr/bin/env bash

set -e

VERSION=$(git rev-list --all --count)

npm install

rm -rf dist
mkdir dist

zip -r dist/ecr-clean.zip index.js node_modules

sed "s/%%VERSION%%/${VERSION}/g" ecr-clean.yaml > dist/ecr-clean.yaml

# Global files
aws s3 --region eu-central-1 cp dist/ecr-clean.yaml s3://taimos-cfn-public/templates/ecr-clean.yaml

# Regional files
array=( eu-west-1 eu-central-1 )
for i in "${array[@]}"
do
    aws s3 --region ${i} cp dist/ecr-clean.zip s3://taimos-lambda-public-${i}/ecr-clean-${VERSION}.zip
done
