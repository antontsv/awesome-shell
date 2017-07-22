#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/setup"

@test 'awesome-bash is executable' {
    [ -x "$AWESOME_BASH" ]
}

@test 'awesome-bash --version prints commit hash' {
    hash=$(cd "$AWESOME_SHELL_REPO_DIR" && git log --format='%h' -1)
    [[ $("$AWESOME_BASH" --version) = *"version: $hash"* ]]
}

@test 'awesome-bash --update pulls latest changes' {
    local cloned_repo="$BATS_TMPDIR/cloned"
    local cloned_awesome_bash="$cloned_repo/awesome-bash"
    [ ! -d "$cloned_repo" ] &&  cp -r "$AWESOME_SHELL_REPO_DIR" "$cloned_repo"
    [ -x "$cloned_awesome_bash" ]
    current_hash=$(cd "$cloned_repo" && git reset -q --hard HEAD^1 && git log --format='%h' -1)
    [[ $("$cloned_awesome_bash" --version) = *"version: $current_hash"* ]]
    origin_master_hash=$(cd "$cloned_repo" && git log --format='%h' -1 origin/master)
    [ "$current_hash" != "$origin_master_hash" ]
    [[ $("$cloned_awesome_bash" --update) = *"version: $origin_master_hash"* ]]
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

@test 'awesome-bash fails on unknown CLI switches' {
    run "$AWESOME_BASH" --some-fake-switch
    [ "$status" -eq 1 ]
    [[ "$output" = "Unknown option: --some-fake-switch" ]]
}

