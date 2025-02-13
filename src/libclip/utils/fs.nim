import os
import strutils
import strformat


proc which*(fname: string): string =
  ## Find a given file in the PATH and return its full path.
  ##
  ## If not found, return an empty string.
  let
    sep = if defined(windows): ";" else: ":"
    dirs = getEnv("PATH").split(sep)

  for dir in dirs:
    let path = joinPath(dir, fname)
    if fileExists(path):
      return path
  #
  return ""    # not found

proc check_required_programs*(programs: seq[string], halt: bool = false) =
  ## Check if the given programs are available in the PATH.
  ##
  ## If not found, return an empty string.
  for prg in programs:
    let msg = if halt: "Error" else: "Warning"
    if which(prg) == "":
      echo &"{msg}: the program '{prg}' was not found"
      if halt:
        quit(1)
