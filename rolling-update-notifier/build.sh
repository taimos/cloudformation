#!/usr/bin/env bash

set -e

aws s3 --region eu-central-1 cp rolling-update-notifier.yaml s3://taimos-cfn-public/templates/rolling-update-notifier.yaml