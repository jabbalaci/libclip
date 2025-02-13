import osproc
import strformat
import strings

## Working with processes, e.g. launch an external command.


# #######
# Procs #
# #######

proc execute_command*(cmd: string, debug = true): int =
  ## Execute a simple external command and return its exit status.
  if debug:
    echo &"# {cmd}"

  execCmd(cmd)

proc get_simple_cmd_output*(cmd: string, right_strip: bool = false): string =
  ## Execute a simple external command and return its output.
  var text = execProcess(cmd)
  if right_strip:
    text = text.rstrip()
  #
  text
