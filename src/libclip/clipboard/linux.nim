import osproc
import streams

import libclip/utils/process

proc setClipboardText*(text: string): bool =
  let p = startProcess("xsel", args = ["-bi"], options = {poUsePath, poStderrToStdout})
  p.inputStream.write(text)
  p.inputStream.close()
  let exitCode = p.waitForExit()
  p.close()
  return exitCode == 0

proc getClipboardText*(): string =
  let cmd = "xsel -bo"
  get_simple_cmd_output(cmd, right_strip = true)
