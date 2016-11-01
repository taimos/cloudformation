#!/usr/bin/env bash

cd ecr-clean
./build.sh
cd ..

cd rolling-update-notifier
./build.sh
cd ..

cd mongodb
./build.sh
cd ..