#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/setup"


@test 'message module supports msg_inline' {
    local script_name="messages_script"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_script_body_message='You can use msg_inline method!'
    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("messages")
    TEST_FILE_BODY="msg_inline '$test_script_body_message'"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    [[ "$output" = "$test_script_body_message" ]]

    # if messages module is not included, we should see error
    TEST_FILE_MODULES=()
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 127 ]
    [[ "$output" = *"msg_inline: command not found"* ]]


}

@test 'message module supports msg_min_len from version a41195b22' {
    local script_name="min_len_presence_script"
    local script_path="$BATS_TMPDIR/$script_name"
    local message="Supported!"
    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("messages")
    local nl=$'\n'
    TEST_FILE_BODY="set -e${nl}msg_min_len 30${nl}msg_inline '$message'"
    TEST_FILE_REF='a41195b22'

    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    [[ "$output" = "$message" ]]

    TEST_FILE_REF=$(cd $BATS_TEST_DIRNAME && git log -1 --format='%h' $TEST_FILE_REF^)
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 127 ]
    [[ "$output" = *"msg_min_len: command not found"* ]]
}

@test 'message module msg_inline and msg fills in messages with ellipsis' {
    local script_name="messages_script"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_script_body_message='Something is in progress...'
    local test_command="msg_inline '$test_script_body_message'"

    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("messages")
    TEST_FILE_BODY="$test_command"
    _create_test_script_file "$script_name"

    # Expected message filled-in with dots up to a default min len of 50
    run $script_path
    [ "$status" -eq 0 ]
    expected_default="$test_script_body_message"
    expected_default+=$(printf "%0.s." $(seq 1 $((50 - ${#test_script_body_message}))))
    [[ "$output" = "$expected_default" ]]    
     
    # Expected message filled-in with dots up to a declared min len of 60
    run $script_path
    nl=$'\n'
    TEST_FILE_BODY="msg_min_len 60$nl$test_command"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    expected_60="$test_script_body_message"
    expected_60+=$(printf "%0.s." $(seq 1 $((60 - ${#test_script_body_message}))))
    [[ "$output" = "$expected_60" ]]    
    
    # For long messages we should output as is
    len=$((${#test_script_body_message} -1))
    run $script_path
    TEST_FILE_BODY="msg_min_len $len$nl$test_command"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    [[ "$output" = "$test_script_body_message" ]]

    # msg_min_len applies for consequent messages only, allowing variation at
    # any time
    test_command="msg '$test_script_body_message'"
    run $script_path
    TEST_FILE_BODY="$test_command${nl}msg_min_len 60$nl$test_command$nl$test_command"
    TEST_FILE_BODY="$TEST_FILE_BODY${nl}msg_min_len 70$nl$test_command${nl}msg_min_len $len$nl$test_command"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" = "$expected_default" ]]
    [[ "${lines[1]}" = "$expected_60" ]]
    [[ "${lines[2]}" = "$expected_60" ]]
    expected_70="$test_script_body_message"
    expected_70+=$(printf "%0.s." $(seq 1 $((70 - ${#test_script_body_message}))))
    [[ "${lines[3]}" = "$expected_70" ]]
    [[ "${lines[4]}" = "$test_script_body_message" ]]

    test_script_body_message='Regular message..'
    test_command="msg_inline '$test_script_body_message'"

    TEST_FILE_BODY="$test_command"
    _create_test_script_file "$script_name"

    # Message without ellipsis gets printed as is
    run $script_path
    [ "$status" -eq 0 ]
    [[ "$output" = "$test_script_body_message" ]]

}

@test 'message module supports fatal to terminate script' {
    local script_name="messages_script"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_error_message='Test error has been triggered'
    local test_script_body_message='Should not see this message'
    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("messages")
    TEST_FILE_BODY="fatal '$test_error_message'; msg_inline '$test_script_body_message'"
    _create_test_script_file "$script_name"
    run $script_path
    [ "$status" -eq 1 ]
    [[ "$output" = "❌  Fatal error: $test_error_message" ]]
}



