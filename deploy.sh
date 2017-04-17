#!/bin/bash
hexo clean
hexo generate
cp -R public/* .deploy/mengbaby.github.io
cd .deploy/mengbaby.github.io
git add .
git commit -m “update”
git push origin master