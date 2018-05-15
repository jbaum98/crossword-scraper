#!/usr/bin/env bash
# URL=https://web.archive.org/web/20121119013907/http://puzzles.about.com/od/beginnersxwords/a/eznytcrosswords.htm
# OUTDIR=monday

# URL=https://web.archive.org/web/20130429112304/http://puzzles.about.com/od/beginnersxwords/a/tuenytxwords.htm
# OUTDIR=tuesday

export URL=https://web.archive.org/web/20130424092900/http://puzzles.about.com/od/beginnersxwords/a/wednytxwords.htm
export OUTDIR=wednesday

dl() {
    wget -nc -q --retry-connrefused "$@"
}
export -f dl

dlStdout() {
    dl -O - "$@"
}
export -f dlStdout

dlFile() {
    dl -P "$OUTDIR" $@
}
export -f dlFile

puzzlePage() {
    local puzzleUrl=$(dlStdout $1 | ./FindPuzzleLink)
    dlFile "$puzzleUrl"
}
export -f puzzlePage

mkdir -p "$OUTDIR"
dlStdout "$URL" | ./FindLinks "Previous Wednesday Crosswords" | parallel --bar -n 1 puzzlePage
exit 0
