#!/bin/sh

set -e

nl='
'


IFS="$nl"

string=$@

[ "$string" == "" ] && read -p "Type string to search on crossref: " string
str=$(printf "$string" | tr ' ' '+')
[ -d "$HOME/.cache/bibaric" ] || mkdir "$HOME/.cache/bibaric"
CACHE="$HOME/.cache/bibaric/${str}"

[ -f "$CACHE" ] || curl -s "https://api.crossref.org/works?query.bibliographic=${str}&select=indexed,title,author,type,DOI,published-print,published-online,container-title" > "$CACHE"

awk -v RS='"indexed"' -v FS='[][\"}{]' '{
    for (i = 7; i<=NF; i++) {
        if ($(i-3) == "title") { title = sprintf("Title: %s", $i) }
        if ($(i-3) == "container-title") { journal = sprintf("\tJournal: %s", $i) }
        if ($(i-2) == "type") { category = sprintf("\tCategory: %s", $i) }
        if ($(i-2) == "DOI") {
            gsub(/\\/, "", $i)
            doi = sprintf("\tDOI: %s", $i)
        }
        if ($(i-6) == "published-print") {
            gsub(/,/, "/", $i)
            date = sprintf("\tDate: %s", $i)
        }
        else if ($(i-6) == "published-online") {
            gsub(/,/, "/", $i)
            date = sprintf("\tDate: %s", $i)
        }
        if ($(i-2) == "given") { given = $i }
        if ($(i-2) == "family") {
            family = $i
            if (author == "") { author = sprintf("\tAuthor(s): %s %s", given, family) }
            else { author = author " and " given " " family }
        }
    }
    if (title != "" && author != "") { printf title "\n" category "\n" date "\n" \
       journal "\n" author "\n" doi "\f" }
    author = ""
}' "$CACHE"

unset IFS
