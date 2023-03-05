#!/bin/sh

export SOURCE_FOLDER=.
export AWK_FOLDER=awk-scripts
export SSG_TITLE=John
export SSG_BASE_URL=https://john.doe


[ ! -f 'ssg' ] \
	&& ./generate-scripts/get-ssg.sh

[ ! -f 'lowdown/lowdown' -a ! -f '/usr/local/bin/lowdown' ] \
	&& ./generate-scripts/get-lowdown.sh                    \
	&& mv ./lowdown/lowdown /usr/local/bin/

./generate-scripts/generate-site.sh
