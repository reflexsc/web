#!/bin/bash

git clean -xdf
git pull
/home/svc-user/bin/jekyll build
