# libclip

A Nim **clip**board **lib**rary.

`libclip` is a cross-platform Nim library for reading text from the clipboard and writing text to the clipboard.

## Installation

```bash
# install:
$ nimble install libclip

# remove:
$ nimble uninstall libclip
```

To install the latest development version:

```bash
# install:
$ nimble install "https://github.com/jabbalaci/libclip@#head"

# remove:
$ nimble uninstall "https://github.com/jabbalaci/libclip@#head"
```

## Usage

After importing `libclip/clipboard`, you get two
functions:

```nim
# copy text to clipboard
proc setClipboardText(text: string): bool

# read text from clipboard
proc getClipboardText(): string =
```

## Example

```nim
import strformat

import libclip/clipboard


proc main() =
  let text = "hello nim"
  let backup = getClipboardText()
  #
  echo &"Original content of the clipboard: '{backup}'"
  echo "---"
  echo &"Writing the following text to the clipboard: '{text}'"
  discard setClipboardText(text)
  let content = getClipboardText()
  echo &"Current content of the clipboard: '{content}'"
  #
  echo &"Restoring the original content of the clipboard: '{backup}'"
  if setClipboardText(backup):
    echo "# success"
  else:
    echo "# failed"

# ############################################################################

when isMainModule:
  main()
```

## Supported platforms

It was tested under **Linux** and **Windows**. Under Linux
you must have the command `xsel` (install it with your
package manager).

I also added **MacOS** support, but I couldn't try it.
Please send me a feedback if it works under Mac.
Under Mac you must have the programs `pbcopy` and
`pbpaste`.

## Links

This clipboard library is part of my larger
[NimPyKot](https://github.com/jabbalaci/nimpykot) library.
