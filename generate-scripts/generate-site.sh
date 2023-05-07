#!/bin/sh

# == Markdown source to HTML ==

mkdir -p public
./ssg "$SOURCE_FOLDER" public "$SSG_TITLE" "$SSG_BASE_URL"

# == Editing HTML with AWK ==

createAWKscript() {
	# "librarires"
	find "$AWK_FOLDER" -type f -name "#*.awk"     -exec cat {} +  > "script.awk"
	# Scripts (before print)
	find "$AWK_FOLDER" -type f -name "[A-Z]*.awk" -exec cat {} + >> "script.awk"
	# Line print
	echo '{if ($0 != 0) print}' >> "script.awk"
	# Post-print scripts
	find "$AWK_FOLDER" -type f -name "[a-z]*.awk" -exec cat {} + >> "script.awk"
}
runAWKscript() {
	for file in $(find './public' -type f -name "*.html"); do
		awk -f 'script.awk' "$file" > tmp && mv -f tmp "$file"
	done
}

createAWKscript
runAWKscript
