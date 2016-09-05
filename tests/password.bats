#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/setup"


@test 'password module keep_sudo_alive terminates if incorrect password is given' {
    local script_name="password_script"
    local script_path="$BATS_TMPDIR/$script_name"
    local test_script_body_message='You can use msg_inline method!'
    TEST_FILE_HELP=""
    TEST_FILE_MODULES=("password")
    TEST_FILE_BODY='sudo -K; keep_sudo_alive; echo "Password is correct"'
    _create_test_script_file "$script_name"
    out=$(cat <<EXPCT | expect -f -
     set timeout 2
     spawn $script_path 
     for {set i 0} {\$i < 3} {incr i} {
      expect "password" {} default {exit 3}
      send "wrong password\n"
     }
     expect eof {} default {exit 3}
     catch wait result
     puts -nonewline "Exit code:"
     puts [lindex \$result 3]
EXPCT
    )
    [[ "$out" = *"Cannot get correct sudo password"* ]]
    [[ "$out" != *"Password is correct"* ]]
    [[ "$out" = *"Exit code:1"* ]]

}

