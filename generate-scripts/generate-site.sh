#!/bin/sh

mkdir -p public
./ssg "$SOURCE_FOLDER" public "$SSG_TITLE" "$SSG_BASE_URL"

find "$AWK_FOLDER" -type f -name "[A-Z]*.awk" -exec cat {} +  > ./script.awk
find "$AWK_FOLDER" -type f -name "_*.awk"     -exec cat {} + >> ./script.awk
find "$AWK_FOLDER" -type f -name "[a-z]*.awk" -exec cat {} + >> ./script.awk
for file in $(find './public' -type f -name "*.html"); do awk -f 'script.awk' "$file" > tmp && mv -f tmp "$file"; done
