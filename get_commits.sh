#!/bin/bash

# List all non merge commits between tags v5.7 and v5.8
# --no-merges option excludes merge commits
# pretty format: 
#  %H  -> commit hash
#  %an -> author name

git log v5.7...v5.8 --no-merges --pretty=format:"%H %an" > commits.txt

