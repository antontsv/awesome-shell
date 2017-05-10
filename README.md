Awesome shell collection
========================

[![Build Status](https://img.shields.io/travis/antontsv/awesome-shell.svg?label=tests)](https://travis-ci.org/antontsv/awesome-shell)
[![MIT License](https://img.shields.io/github/license/antontsv/awesome-shell.svg?label=👍 )](https://github.com/antontsv/awesome-shell/blob/master/LICENSE)

This repo offers `awesome-bash` shebang
interpreter that is passing code to `bash` and
offers quick one-line access to the set of libraries and functions

![demo](https://cloud.githubusercontent.com/assets/4912269/18118251/8a3eef2e-6f08-11e6-91e0-66ea3f8c33df.gif)

Installation
============

```sh
./INSTALL
```

This will try to install awesome-bash into one of
/usr/local/bin, /usr/bin or ~/bin

It will perform install if one of these locations are
in your `PATH`

Usage
=====

Once installed you can use scripts and includes in your scripts:

```sh
#!/usr/bin/env awesome-bash
# vim: ft=sh:

awesome_shell_help <<_HELP_
Script help to be displayed upon use of -h or --help CLI switches

_HELP_

awesome_shell_include messages

msg_inline "Simple test..."
verbose_exit_code

```

`vim: ft=sh:` will help with syntax highlighting on GitHub,
and in vim on your computer if modeline is enabled

Add `awesome_shell_include [name-of-the-file-in-shell-libs]`
if you need function from specific collection/library


If your script is stable and finalized and you do not want
it to break due to updates to this repo, than you can lock
down the commit version from this repo by using 'awesome-shell ref'
as follows:

```sh
#!/usr/bin/env awesome-bash

#awesome-shell ref:737c1ca
awesome_shell_help <<_HELP_
Script help to be displayed upon use of -h or --help CLI switches

This help will produced by help module from commit
737c1ca691d5a98652415c406a40668b25a42045

_HELP_

```
If you have multiple '#awesome-shell ref:' tags, only first one is honored.
Reference speficied in that tag affects all `awesome_shell_include`

Updates
=======

If you get a script that references a version that you do not have,
than awesome-bash will try to fetch an update automatically.

Also if you would like to fetch updates manually, there is a short-cut:
```sh
    $ awesome-bash --update
```

To get list of available modules & functions, run
```sh
    $ awesome-bash --list-libraries
```

Example
====

Preview above uses the following code snippet:
```sh
#!/usr/bin/env awesome-bash

awesome_shell_help <<_HELP_
This script demostrates abilities of help and messages module

Usage: $awesome_shell_script_name [-h|--help]

Options:
    -h, --help this help

_HELP_

awesome_shell_include messages

header 'Messages module showcase'

silent_exec_with_title "Check if /usr/bin is writable by $USER..." '[ -w /usr/bin/ ]'
pause_with_delay_in_seconds 3
ask_to_confirm 'Perform github.com status check?' && \
silent_exec_with_title 'Check if github.com is up...' 'curl -f https://github.com'
fatal_if_any_error 'Github.com is down. Terminating script.'
msg # just empty line
msg "Use verbose_exec to print command, its output and return status"
verbose_exec 'ls non-existing-file'
header 'Have fun!'
```







