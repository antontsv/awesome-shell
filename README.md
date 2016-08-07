Awesome shell collection
========================

This repo offers `awesome-bash` shebang
interpreter that is passing code to `bash` as well
offering quick one-line access to the set of libraries and functions 

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

awesome_shell_help <<_HELP_
Script help to be displayed upon use of -h or --help CLI switches

_HELP_

awesome_shell_include messages

msg_inline "Simple test..."
verbose_exit_code

```

Add `awesome_shell_include [name-of-the-file-in-shell-libs]`
if you need function from specific collection/library


If your script is stable and finalized and you do not want
it to break due to updates to this repo, than you can lock
down the commit version from this repo by using '--ref'
as follows:

```sh
#!/usr/bin/env awesome-bash --ref 737c1ca

awesome_shell_help <<_HELP_
Script help to be displayed upon use of -h or --help CLI switches

This help will produced by help module from commit
737c1ca691d5a98652415c406a40668b25a42045

_HELP_

```
Reference speficied in `--ref` option affects all `awesome_shell_include`



