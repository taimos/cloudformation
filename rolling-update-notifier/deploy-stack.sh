#!/bin/bash

set -e

REGION=${1:?MISSING REGION}

export AWS_DEFAULT_REGION=${REGION}

STACKNAME=rolling-update-notifier

if ! aws cloudformation describe-stacks --stack-name ${STACKNAME} > /dev/null 2>&1; then
  aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name ${STACKNAME} --template-body file://rolling-update-notifier.yaml
else
  aws cloudformation update-stack --capabilities CAPABILITY_IAM --stack-name ${STACKNAME} --template-body file://rolling-update-notifier.yaml || echo "No Update"
fi

cfn-tail ${STACKNAME}