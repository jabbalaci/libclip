import strutils


func rstrip*(s: string, chars: set[char] = Whitespace): string =
  ## Strips trailing chars from ``s`` and returns the resulting string.
  ##
  ## If ``chars`` are not specified, trailing whitespaces are removed.
  ## Specify ``chars`` as a set of chars (bitset).
  runnableExamples:
    doAssert "  ab  ".rstrip() == "  ab"

  s.strip(leading=false, trailing=true, chars=chars)

func rstrip*(s: string, chars: string): string =
  ## Strips trailing ``chars`` from ``s`` and returns the resulting string.
  ##
  ## Specify ``chars`` in a string. The string is treated as a set of chars,
  ## just like Python's ``rstrip()``.
  runnableExamples:
    doAssert "  ab\n".rstrip("\n") == "  ab"
    doAssert "  ab\t\n".rstrip("\n") == "  ab\t"
    doAssert "  ab\t\n".rstrip("\n\t") == "  ab"
    doAssert "  ab\t\n".rstrip("\t\n") == "  ab"
    doAssert "  ab  \t\n".rstrip("\t\n") == "  ab  "

  var bs: set[char] = {}
  for c in chars:
    bs = bs + {c}
  s.strip(leading=false, trailing=true, chars=bs)
