#!/usr/bin/env bats

export AWESOME_SHELL_REPO_DIR=$(cd "${BATS_TEST_DIRNAME}/.."; printf "$(pwd)")
export AWESOME_BASH="$AWESOME_SHELL_REPO_DIR/awesome-bash"

@test 'awesome-bash is executable' {
    [ -x "$AWESOME_BASH" ]
}

@test 'awesome-bash --version prints commit hash' {
    hash=$(cd "$AWESOME_SHELL_REPO_DIR" && git log --format='%h' -1)
    [[ $("$AWESOME_BASH" --version) = *"version: $hash"* ]]
}

@test 'awesome-bash --update pulls latest changes' {
    current_hash=$(cd "$AWESOME_SHELL_REPO_DIR" && git reset -q --hard HEAD^1 && git log --format='%h' -1)
    [[ $("$AWESOME_BASH" --version) = *"version: $current_hash"* ]]
    origin_master_hash=$(cd "$AWESOME_SHELL_REPO_DIR" && git log --format='%h' -1 origin/master)
    [ "$current_hash" != "$origin_master_hash" ]
    [[ $("$AWESOME_BASH" --update) = *"version: $origin_master_hash"* ]]
}

@test 'awesome-bash --list-libraries prints shell-libs files' {
    local lib_dirname="shell-libs/"
    local fake_lib_name="dummy-fake-library"
    [ -d "$AWESOME_SHELL_REPO_DIR/$lib_dirname" ]
    touch "$AWESOME_SHELL_REPO_DIR/$lib_dirname/$fake_lib_name"
    libs=$(cd "$AWESOME_SHELL_REPO_DIR" && git ls-tree --name-only HEAD "$lib_dirname") 
    list=$("$AWESOME_BASH" --list-libraries)
    [ -n "$list" ]
    [ -n "$libs" ]
    for lib in $libs;do
        lib=${lib:${#lib_dirname}}
        [[ "$list" = *"$lib"* ]]
    done;
    ! [[ "$list" = *"$fake_lib_name"* ]]
    rm "$AWESOME_SHELL_REPO_DIR/$lib_dirname/$fake_lib_name"
}
