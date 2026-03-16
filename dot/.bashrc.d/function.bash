generate-bash-completion() {
    local file="$1"
    local command="$2"

    if [[ -z "$file" || -z "$command" ]]; then
        echo "usage: generate-bash-completion <file> <command>" >&2
        echo "example: generate-bash-completion mycmd '_mycmd_completion'" >&2
        return 1
    fi

    local completion_dir="${HOME}/.local/share/bash-completion/completions"
    local completion_file="$(realpath -m "${completion_dir}/${file}")"

    if [[ -d "$completion_dir" && ! -w "$completion_dir" ]]; then
        echo "ERROR: has no permission to write to directory '${completion_dir}'" >&2
        return 1
    fi

    if [[ ! -f "$completion_file" ]]; then
        if ! mkdir -p "$completion_dir"; then
            echo "ERROR: cannot create directory '$completion_dir'" >&2
            return 1
        fi

        if ! bash -c "$command" > "$completion_file"; then
            echo "ERROR: failed to execute command '$command'" >&2
            rm -f "$completion_file"
            return 1
        fi
    fi
}

add-to-path() {
    if [[ $# -eq 0 ]]; then
        echo "usage: add-to-path <path1> [path2 ...]" >&2
        echo "example: add-to-path /usr/local/bin /tmp/my-dir" >&2
        return 1
    fi

    local -a dirs=("$@")
    local dir
    local dir_normalized
    local new_path="$PATH"

    for dir in "${dirs[@]}"; do
        [[ -z "$dir" ]] && continue

        dir_normalized="${dir%/}"
        if [[ ! -d "$dir_normalized" ]]; then
            echo "WARNING: '${dir}' is not a valid directory, skipped." >&2
            continue
        fi

        case ":${new_path}:" in
            *":${dir_normalized}:"*) ;;
            *)
                new_path="${dir_normalized}${new_path:+:}${new_path}"
                ;;
        esac
    done

    if [[ "$new_path" != "$PATH" ]]; then
        export PATH="$new_path"
    fi
}

remove-from-path() {
    if [[ $# -eq 0 ]]; then
        echo "usage: remove-from-path <path1> [path2 ...]" >&2
        echo "example: remove-from-path /usr/local/bin /tmp/my-dir" >&2
        return 1
    fi

    local original_ifs="$IFS"

    local -a remove_paths=("$@")
    local new_path=""
    local path
    local remove_path
    local path_normalized
    local remove_path_normalized
    local -i keep_path=1     # 1=keep, 0=remove

    IFS=':'
    for path in $PATH; do
        [[ -z "$path" ]] && continue

        path_normalized="${path%/}" # remove / at tail
        keep_path=1

        for remove_path in "${remove_paths[@]}"; do
            remove_path_normalized="${remove_path%/}"
            if [[ "$path_normalized" == "$remove_path_normalized" ]]; then
                keep_path=0
                break
            fi
        done

        if [[ $keep_path -eq 1 ]]; then
            new_path="${new_path}${new_path:+:}${path}"
        fi
    done
    IFS="$original_ifs"

    export PATH="${new_path}"
}

show-path() {
    echo "$PATH" | tr ':' '\n' | nl -w2 -s'. '
}

unhash-command-in-dirs() {
    if [[ $# -eq 0 ]]; then
        echo "usage: unhash-command-in-dir <dir1> [dir2 ...]" >&2
        echo "example: unhash-command-in-dir ~/.local/bin/ ~/.volta/bin/" >&2
        return 1
    fi

    local -a dirs=("$1")
    local dir
    local dir_normalized
    local file_path
    local filename
    for dir in "${dirs[@]}"; do
        [[ -z "$dir" || ! -d "$dir" ]] && continue

        dir_normalized="${dir%/}"

        for file_path in "$dir_normalized"/*; do
            [[ ! -f "$file_path" || ! -x "$file_path" ]] && continue

            filename="$(basename "$file_path")"
            hash -d "$filename" 2>/dev/null
        done
    done
}
