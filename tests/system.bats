#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/setup"


@test 'system required_utility does command lookup' {
    local script_name="system_script"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_message="Can use git"
    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("system") # system should include "messages"
    TEST_FILE_BODY="set -e; required_utility git; msg '$test_message'"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    [[ "$output" = "$test_message" ]]

    TEST_FILE_MODULES=()
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 127 ]
    [[ "$output" = *"required_utility: command not found"* ]]

}

@test 'system required_utility terminates script if command not found' {
    local script_name="system_script"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_message="Should not see this"
    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("messages" "system")
    TEST_FILE_BODY="required_utility git; required_utility something_else; msg '$test_message'"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 1 ]
    [[ "$output" = *"Was not able to find required 'something_else' utility in the PATH" ]]
    [[ "$output" != *"$test_message"* ]]
    [[ "$output" != *"git"* ]]

}


