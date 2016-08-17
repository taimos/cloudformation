#!/usr/bin/env bash

set -e

VERSION=$(jp -f package.json -u "version")

npm install

rm -rf dist
mkdir dist

zip -r dist/ecr-clean.zip index.js node_modules

cfn-include -t -m ecr-clean.template > dist/ecr-clean.compiled.template

# Global files
aws s3 --region eu-central-1 cp dist/ecr-clean.compiled.template s3://taimos-cfn-public/templates/ecr-clean.template

# Regional files
array=( eu-west-1 eu-central-1 )
for i in "${array[@]}"
do
    aws s3 --region ${i} cp dist/ecr-clean.zip s3://taimos-lambda-public-${i}/ecr-clean-${VERSION}.zip
done
