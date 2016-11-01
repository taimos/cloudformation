#!/usr/bin/env bash

set -e

aws s3 --region eu-central-1 cp mongodb-cluster.yaml s3://taimos-cfn-public/templates/mongodb-cluster.yaml
aws s3 --region eu-central-1 cp mongodb-node.yaml s3://taimos-cfn-public/templates/mongodb-node.yaml