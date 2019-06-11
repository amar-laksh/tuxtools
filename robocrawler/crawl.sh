#!/bin/bash
# File              : crawl.sh
# Author            : Amar Lakshya <amar.lakshya@xaviers.edu.in>
# Date              : 11.06.2019
# Last Modified Date: 11.06.2019
# Last Modified By  : Amar Lakshya <amar.lakshya@xaviers.edu.in>

set -o nounset                                  # Treat unset variables as an error
if [ $# -ne 2 ]
then
	echo "Usage: crawl.sh url allow/disallow/all/comments/sitemap"
	exit 0
fi

url=$1
baseurl=$(echo $url | cut -d '/' -f1,3)
content=$(echo curl -s $url)

print_allow() {
	while IFS= read -r line;
	do
		echo "$baseurl$line"
	done <<< $($content | grep  "^[Aa]llow:.*" | cut -d ' ' -f2)
}

print_disallow() {
	while IFS= read -r line;
	do
		echo "$baseurl$line"
	done <<< $($content | grep  "^[Dd]isallow:.*" | cut -d ' ' -f2)
}


print_all() {
	echo "Allow:"
	print_allow
	echo "Disallow:"
	print_disallow
}

print_comments() {
	comments=$($content | grep -i "#.*")
	while IFS= read -r line;do
		echo $line
	done <<< "$comments"
}

print_sitemap() {
	echo  $($content | grep  "[sS]itemap.*")
}


case "$2" in
	"allow")
		print_allow
		;;
	"disallow")
		print_disallow
		;;
	"all")
		print_all
		;;
	"comments")
		print_comments
		;;
	"sitemap")
		print_sitemap
		;;
	*)
		echo "didn't get your command"
		;;
esac




