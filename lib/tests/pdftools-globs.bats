#!/usr/bin/env bats

HELPER="$BATS_TEST_DIRNAME/../pdftools-globs.sh"

setup() {
    cd "$BATS_TEST_TMPDIR"
    # shellcheck source=/dev/null
    source "$HELPER"
    TOOL_NAME=testtool
}

make_pdf() {
    local name="${1:-test.pdf}"
    mkdir -p "$(dirname "$name")"
    printf '%%PDF-1.4\ntest\n' > "$name"
}

@test "literal PDF path is kept" {
    make_pdf a.pdf
    files=(a.pdf)
    pdftools_expand_args files
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 0 ]]
    [[ "${#files[@]}" -eq 1 ]]
    [[ "${files[0]}" == a.pdf ]]
}

@test "literal missing path is skipped" {
    files=(missing.pdf)
    pdftools_expand_args files || true
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 1 ]]
    [[ "${#files[@]}" -eq 0 ]]
}

@test "literal non-PDF is skipped" {
    echo hi > note.txt
    files=(note.txt)
    pdftools_expand_args files || true
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 1 ]]
    [[ "${#files[@]}" -eq 0 ]]
}

@test "expands quoted *.pdf" {
    make_pdf a.pdf
    make_pdf b.pdf
    echo x > c.txt
    files=('*.pdf')
    pdftools_expand_args files
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 0 ]]
    [[ "${#files[@]}" -eq 2 ]]
}

@test "empty glob warns and skips" {
    files=('*.pdf')
    run bash -c '
        source "$1"
        TOOL_NAME=testtool
        files=("*.pdf")
        pdftools_expand_args files
        echo "STATUS=$PDFTOOLS_EXPAND_STATUS"
        echo "COUNT=${#files[@]}"
    ' _ "$HELPER"
    [[ "$status" -eq 1 ]]
    [[ "$output" == *"matched no files"* ]]
    [[ "$output" == *"STATUS=1"* ]]
    [[ "$output" == *"COUNT=0"* ]]
}

@test "expands ** recursively" {
    make_pdf top.pdf
    make_pdf sub/nested.pdf
    files=('**/*.pdf')
    pdftools_expand_args files
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 0 ]]
    [[ "${#files[@]}" -eq 2 ]]
}

@test "glob non-PDF matches are skipped" {
    make_pdf a.pdf
    echo x > a.txt
    files=('a.*')
    pdftools_expand_args files || true
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 1 ]]
    [[ "${#files[@]}" -eq 1 ]]
    [[ "${files[0]}" == a.pdf ]]
}

@test "deduplicates paths" {
    make_pdf a.pdf
    files=(a.pdf a.pdf)
    pdftools_expand_args files || true
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 1 ]]
    [[ "${#files[@]}" -eq 1 ]]
}

@test "accepts .PDF extension" {
    make_pdf Report.PDF
    files=(Report.PDF)
    pdftools_expand_args files
    [[ "$PDFTOOLS_EXPAND_STATUS" -eq 0 ]]
    [[ "${#files[@]}" -eq 1 ]]
}

@test "warns on stderr for empty glob" {
    files=('no-such-*.pdf')
    run bash -c '
        source "$1"
        TOOL_NAME=testtool
        cd "$2"
        files=("no-such-*.pdf")
        pdftools_expand_args files
    ' _ "$HELPER" "$BATS_TEST_TMPDIR"
    [[ "$status" -eq 1 ]]
    [[ "$output" == *"matched no files"* ]]
}
