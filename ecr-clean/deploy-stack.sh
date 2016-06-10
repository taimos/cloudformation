#!/bin/bash

set -e

REGION=${1:?MISSING REGION}

export AWS_DEFAULT_REGION=${REGION}

cfn-include -t -m ecr-clean.template > dist/ecr-clean.compiled.template

STACKNAME=ecr-clean

if ! aws cloudformation describe-stacks --stack-name ${STACKNAME} > /dev/null 2>&1; then
  aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name ${STACKNAME} --template-body file://dist/ecr-clean.compiled.template
else
  aws cloudformation update-stack --capabilities CAPABILITY_IAM --stack-name ${STACKNAME} --template-body file://dist/ecr-clean.compiled.template || echo "No Update"
fi

cfn-tail ${STACKNAME}