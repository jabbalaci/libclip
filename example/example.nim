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
