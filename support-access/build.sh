#!/usr/bin/env bash

set -e

aws s3 --region eu-central-1 cp support-access.yaml s3://taimos-cfn-public/templates/support-access.yaml