# pdftools-globs.sh — shared path expansion for pdftools suite members.
# Vendor an identical copy into each tool repo; source it after option parsing.
# Compatible with bash 3.2 (macOS /bin/bash).
#
# Requires: TOOL_NAME (e.g. pdfa4) set before calling.
#
# pdftools_expand_args ARRAY_NAME
#   Mutates the named array in place: expands globs, filters to .pdf/.PDF
#   regular files, deduplicates. Warnings go to stderr.
#   Sets PDFTOOLS_EXPAND_STATUS to 0 on full success, 1 if any skip/failure.
#   Return status matches PDFTOOLS_EXPAND_STATUS.

pdftools_is_glob() {
    case "$1" in
        *\**|*\?*|*[*) return 0 ;;
        *) return 1 ;;
    esac
}

pdftools_is_pdf() {
    case "$1" in
        *.pdf|*.PDF) return 0 ;;
        *) return 1 ;;
    esac
}

# Expand patterns containing ** via find (bash 3.2 has no globstar).
# Supports: **/name, dir/**/name, dir/**, **
pdftools_globstar_expand() {
    local pattern="$1"
    local root="." namepat="*"

    case "$pattern" in
        \*\*/*)
            root="."
            namepat="${pattern#**/}"
            ;;
        */\*\*/*)
            root="${pattern%%/\*\*/*}"
            namepat="${pattern#*/**/}"
            ;;
        */\*\*)
            root="${pattern%/\*\*}"
            namepat="*"
            ;;
        \*\*)
            root="."
            namepat="*"
            ;;
        *)
            return 0
            ;;
    esac

    [ -d "$root" ] || return 0
    # shellcheck disable=SC2016
    find "$root" -type f -name "$namepat" | sed 's|^\./||'
}

# Expand a single glob pattern; print matches one per line.
pdftools_glob_expand() {
    local pattern="$1"
    case "$pattern" in
        *\*\**)
            pdftools_globstar_expand "$pattern"
            return
            ;;
    esac
    (
        shopt -s nullglob
        # Intentional unquoted expansion so the pattern globs.
        # shellcheck disable=SC2086
        set -- $pattern
        if [ "$#" -eq 0 ]; then
            exit 0
        fi
        printf '%s\n' "$@"
    )
}
# pdftools_array_append ARRAY_NAME value
pdftools_array_append() {
    local __an="$1"
    local __val="$2"
    eval "$__an+=(\"\$__val\")"
}

# pdftools_array_len ARRAY_NAME → echoes length
pdftools_array_len() {
    eval "echo \${#$1[@]}"
}

# pdftools_array_get ARRAY_NAME index → echoes element
pdftools_array_get() {
    eval "echo \"\${$1[$2]}\""
}

# Returns 0 if path already in ARRAY_NAME
pdftools_array_contains() {
    local __an="$1"
    local __val="$2"
    local __i __len __cur
    __len="$(pdftools_array_len "$__an")"
    __i=0
    while [ "$__i" -lt "$__len" ]; do
        __cur="$(pdftools_array_get "$__an" "$__i")"
        if [ "$__cur" = "$__val" ]; then
            return 0
        fi
        __i=$((__i + 1))
    done
    return 1
}

# Accept one candidate into seen/out array names.
pdftools_accept_path() {
    local path="$1"
    local seen_name="$2"
    local out_name="$3"

    if [ ! -f "$path" ]; then
        echo "${TOOL_NAME}: '$path' not found, skipping" >&2
        PDFTOOLS_EXPAND_STATUS=1
        return
    fi
    if ! pdftools_is_pdf "$path"; then
        echo "${TOOL_NAME}: '$path' not a PDF, skipping" >&2
        PDFTOOLS_EXPAND_STATUS=1
        return
    fi
    if pdftools_array_contains "$seen_name" "$path"; then
        echo "${TOOL_NAME}: '$path' specified more than once, skipping duplicate" >&2
        PDFTOOLS_EXPAND_STATUS=1
        return
    fi
    pdftools_array_append "$seen_name" "$path"
    pdftools_array_append "$out_name" "$path"
}

pdftools_expand_args() {
    local array_name="$1"
    local arg matches match
    local -a _pdftools_seen=()
    local -a _pdftools_out=()
    local __i __len __cur

    PDFTOOLS_EXPAND_STATUS=0

    if [ -z "${TOOL_NAME:-}" ]; then
        echo "pdftools-globs: TOOL_NAME is not set" >&2
        PDFTOOLS_EXPAND_STATUS=1
        eval "$array_name=()"
        return 1
    fi

    __len="$(pdftools_array_len "$array_name")"
    __i=0
    while [ "$__i" -lt "$__len" ]; do
        arg="$(pdftools_array_get "$array_name" "$__i")"
        if pdftools_is_glob "$arg"; then
            matches="$(pdftools_glob_expand "$arg")"
            if [ -z "$matches" ]; then
                echo "${TOOL_NAME}: pattern '$arg' matched no files, skipping" >&2
                PDFTOOLS_EXPAND_STATUS=1
            else
                while IFS= read -r match; do
                    [ -z "$match" ] && continue
                    pdftools_accept_path "$match" _pdftools_seen _pdftools_out
                done <<EOF
$matches
EOF
            fi
        else
            pdftools_accept_path "$arg" _pdftools_seen _pdftools_out
        fi
        __i=$((__i + 1))
    done

    # Copy _pdftools_out back into the caller's array
    eval "$array_name=()"
    __len="$(pdftools_array_len _pdftools_out)"
    __i=0
    while [ "$__i" -lt "$__len" ]; do
        __cur="$(pdftools_array_get _pdftools_out "$__i")"
        pdftools_array_append "$array_name" "$__cur"
        __i=$((__i + 1))
    done

    return "$PDFTOOLS_EXPAND_STATUS"
}
