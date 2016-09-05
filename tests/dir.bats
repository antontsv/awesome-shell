#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/setup"


@test 'dir module supports abs_path' {
    local script_name="dir_script"
    local script_path="$BATS_TMPDIR/$script_name"
    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("dir")
    TEST_FILE_BODY="cd $BATS_TMPDIR; abs_path '$script_name'"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    [ -f "$output" ]
    [[ "$output" = "/"* ]]
    [[ "$output" = *"/$script_name" ]]
    [[ "$output" != *"."* ]]

    TEST_FILE_BODY="cd $BATS_TMPDIR; abs_path '.'"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    [ -d "$output" ]
    [[ "$output" = "/"* ]]
    [[ "$output" != *"."* ]]
    [[ "$output" != *"/" ]]
}
