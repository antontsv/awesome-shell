#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/setup"

@test 'awesome_shell_help adds support for -h and --help switches' {
    local script_name="validate_help"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_help_message='Testing help module'
    local test_script_body_message='Script Body'
    TEST_FILE_HELP="$test_help_message"
    TEST_FILE_BODY="echo '$test_script_body_message'"
    _create_test_script_file "$script_name"
    run "$script_path"
    [ "$status" -eq 0 ]
    [[ "$output" = *"$test_script_body_message"* ]]

    run $script_path -h
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Usage: $script_name [-h|--help]" ]
    [ "${lines[1]}" = "    $test_help_message" ]
    [[ "$output" != *"$test_script_body_message"* ]]
    local h_output="$output"
    
    run $script_path --help
    [ "$status" -eq 0 ]
    [ -n "$output" ]
    [ "$output" = "$h_output" ]
    
}

