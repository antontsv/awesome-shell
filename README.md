Awesome shell collection
========================

Collection of utilities used in terminal

Installation
============

```sh
./INSTALL
```

This will add init block to your .bashrc or .zshrc
Those are two shells supported at the moment

Usage
=====

Once installed you can use scripts and includes in

* Terminal via `awesome_shell_include [name-of-the-file-in-shell-libs]`

* In your scripts:

```sh
#!/bin/bash -i
awesome_shell_include help
awesome_shell_help <<_HELP_
Script help to be displayed upon use of -h or --help CLI switches

_HELP_
```

Example above assumes prior installation in your .bashrc file
