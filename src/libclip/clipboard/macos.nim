import osproc
import streams

import libclip/process

proc setClipboardText*(text: string): bool =
  let p = startProcess("pbcopy", options = {poUsePath, poStderrToStdout})
  p.inputStream.write(text)
  p.inputStream.close()
  let exitCode = p.waitForExit()
  p.close()
  return exitCode == 0

proc getClipboardText*(): string =
  let cmd = "pbpaste"
  get_simple_cmd_output(cmd, right_strip = true)
