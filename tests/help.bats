#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/setup"

@test 'awesome_shell_help add support for  -h and --help switches' {
    local script_name="validate_help"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_help_message='Testing help module'
    cat > "$script_path" <<_CONTENT_
#!/usr/bin/env awesome-bash

awesome_shell_help <<_HELP_
Usage: \$awesome_shell_script_name [-h|--help]
    $test_help_message
_HELP_

_CONTENT_
    chmod u+x "$script_path"
    run "$script_path"
    [ "$status" -eq 0 ]

    run $script_path -h
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "Usage: $script_name [-h|--help]" ]
    [ "${lines[1]}" = "    $test_help_message" ]
    local h_output="$output"
    
    run $script_path --help
    [ "$status" -eq 1 ]
    [ -n "$output" ]
    [ "$output" = "$h_output" ]
    
}

