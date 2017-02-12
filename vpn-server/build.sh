#!/usr/bin/env bash

set -e

aws s3 --region eu-central-1 cp vpn-server.yaml s3://taimos-cfn-public/templates/vpn-server.yaml