#!/usr/bin/env bash

set -e

aws s3 --region eu-central-1 cp static-website.yaml s3://taimos-cfn-public/templates/static-website.yaml