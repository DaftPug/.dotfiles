#!/bin/bash
echo "Enter directory name:"
read dirname
mkdir -p $dirname
touch $dirname/index.html
touch $dirname/myScript.js
