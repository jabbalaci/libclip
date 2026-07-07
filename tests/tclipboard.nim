import std/unittest

import libclip/clipboard


# ##############
suite "clipboard":
# ##############
  test "read_write":
    let backup = getClipboardText()
    #
    let text1 = "hello nim"
    discard setClipboardText(text1)
    check getClipboardText() == text1
    #
    let text2 = "Hello, 世界! 👍"
    for i in 1..5:
      discard setClipboardText(text2)
      check getClipboardText() == text2
      discard setClipboardText("Laci")
      check getClipboardText() == "Laci"
      discard setClipboardText("Éva")
      check getClipboardText() == "Éva"
    #
    discard setClipboardText("")
    check getClipboardText().len == 0
    #
    discard setClipboardText(backup)
    check getClipboardText() == backup
