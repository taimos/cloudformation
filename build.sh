#!/usr/bin/env bash

cd ecr-clean
./build.sh

cd rolling-update-notifier
./build.sh