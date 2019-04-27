# tmux-paste

Tmux plugin for pasting from the system clipboard.  Works on OSX, Linux, Cygwin, and WSL (Windows Subsystem For Linux).

## Overview

The yang to [tmux-yank's](https://github.com/tmux-plugins/tmux-yank/) yin.  Copy from the system
clipboard into [`tmux`](https://tmux.github.io/).

Supports

- Linux
- macOS
- Cygwin
- Windows Subsystem for Linux (WSL)

## Installing

### Via TPM (recommended)

The easiest way to install `tmux-paste` is via the [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm).

1.  Add plugin to the list of TPM plugins in `.tmux.conf`:

    ``` tmux
    set -g @plugin 'brennanfee/tmux-paste'
    ```

2.  Use <kbd>prefix</kbd>-<kbd>I</kbd> install `tmux-paste`.  You should now be able to `tmux-paste` immediately.
3.  When you want to update `tmux-paste` use <kbd>prefix</kbd>-<kbd>U</kbd>.

### Manual Installation

1.  Clone the repository

    ``` sh
    $ git clone https://github.com/brennanfee/tmux-paste ~/clone/path
    ```

2.  Add this line to the bottom of `.tmux.conf`

    ``` tmux
    run-shell ~/clone/path/paste.tmux
    ```

3.  Reload the `tmux` environment

    ``` sh
    # type this inside tmux
    $ tmux source-file ~/.tmux.conf
    ```

You should now be able to use `tmux-paste` immediately.

## Requirements

In order for `tmux-paste` to work, there must be a program that can get data
from the system clipboard.

### macOS

-   [`reattach-to-user-namespace`](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard)

**Note**: Some versions of macOS (aka OS X) have been reported to work
without `reattach-to-user-namespace`. It doesn't hurt to have it installed.

-   OS X 10.8: Mountain Lion – *required*
-   OS X 10.9: Mavericks – *required*
-   OS X 10.10: Yosemite – *not required*
-   OS X 10.11: El Capitan – *not required*
-   macOS 10.12: Sierra – *required*

The easiest way to use `reattach-to-user-namespace` with `tmux` is to
use the [`tmux-sensible`](https://github.com/tmux-plugins/tmux-sensible)
plugin.

To use it manually, use:

``` tmux
# ~/.tmux.conf
set-option -g default-command "reattach-to-user-namespace -l $SHELL"
```

#### [HomeBrew](https://brew.sh/) (recommended)

``` sh
$ brew install reattach-to-user-namespace
```

#### MacPorts

``` sh
$ sudo port install tmux-pasteboard
```

### Linux

-   `xsel` (recommended) or `xclip`.

#### Debian & Ubuntu

``` sh
$ sudo apt-get install xsel # or xclip
```

#### RedHat & CentOS

``` sh
$ sudo yum install xsel # or xclip
```

### Cygwin

-  (*optional*) `getclip` which is part of the `cygutils-extra` package.

### Windows Subsystem for Linux (WSL)

Microsoft helpfully provides clip.exe as part of the Windows installation.  However, they do not
include the counterpart (paste.exe).  But, have no fear, the open-source community has you covered.

You can download a paste.exe command from [here](https://www.c3scripts.com/tutorials/msdos/paste.html).
This file must be copied into the C:\Windows\System32 folder, not just merely on your path (I believe
for permissions reasons).  While the source site says any place on the path *should* work, in my
experience it only works if it is in C:\Windows\System32.

If you have concerns about downloading an EXE from the internet and putting it into your system
directory that is understandable.  The source code (a simple C# file) is available on the site and
you can download that, inspect it, and compile it yourself.

## Configuration

### Key bindings

By default, this overrides the default <kbd>prefix</kbd>-<kbd>]</kbd> and maps the
`MouseUp2Pane` mouse action to perform the paste.  In essence, what happens is that BEFORE the
standard `tmux paste-buffer` command is executed, we first execute the OS specific clipboard
command to read the system clipboard into the paste buffer.

If you wish to override the key or mouse action you can set `@paste_key` or `@paste_mouse_key`
respectively.  To prevent a mapping entirely just set the value to a blank string.

### Default and Preferred Clipboard Programs

tmux-paste does its best to detect a reasonable choice for a clipboard
program on your OS.

If tmux-paste can't detect a known clipboard program then it uses the
`@custom_paste_command` tmux option as your clipboard program if set.

If you need to always override tmux-paste's choice for a clipboard program,
then you can set `@override_paste_command` to force tmux-paste to use whatever
you want.

Note that both programs _must_ output to `STDOUT` for the text to be imported correctly.

An example of setting `@override_paste_command`:

``` tmux
# ~/.tmux.conf

set -g @custom_paste_command 'my-clipboard-paste --some-arg'
# or
set -g @override_paste_command 'my-clipboard-paste --some-arg'
```

### Linux Clipboards

Linux has several cut-and-paste clipboards: `primary`, `secondary`, and
`clipboard` (default in tmux-paste is `clipboard`).

You can change this by setting `@paste_selection`:

``` tmux
# ~/.tmux.conf

set -g @paste_selection 'primary' # or 'secondary' or 'clipboard'
```

There is a separate option for a mouse paste, `@paste_selection_mouse`.

### Other great tmux plugins

-   [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat) - a plugin
    for regular expression searches in tmux and fast match selection
-   [tmux-open](https://github.com/tmux-plugins/tmux-open) - a plugin for
    quickly opening highlighted file or a URL
-   [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) -
    automatic restoring and continuous saving of tmux environment.

## A Thank You

I want to express my personal thanks to the folks behind [tmux-plugins](https://github.com/tmux-plugins).
I patterned this plugin and its structure heavily off [tmux-yank](https://github.com/tmux-plugins/tmux-yank).
Your example led my way and I am grateful for your plugins and your example.

## License

[MIT](license) © 2019 [Brennan Fee](https://github.com/brennanfee)
