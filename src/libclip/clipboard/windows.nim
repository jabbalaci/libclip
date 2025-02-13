import pkg/winim/lean


proc setClipboardText*(text: string): bool =
  ## Copies the given Unicode text to the clipboard.
  ## Returns `true` if successful, `false` otherwise.

  # Open the clipboard
  if OpenClipboard(0) == FALSE:
    return false

  # Empty the clipboard
  if EmptyClipboard() == FALSE:
    CloseClipboard()
    return false

  # Allocate global memory for the text
  let textLen = text.len + 1  # Include space for the null terminator
  let clipbuffer = GlobalAlloc(GHND or GMEM_SHARE, textLen * sizeof(WCHAR))
  if clipbuffer == 0:  # Compare to 0 instead of nil
    CloseClipboard()
    return false

  # Lock the global memory and copy the text into it
  let szClipboard = cast[ptr WCHAR](GlobalLock(clipbuffer))
  if szClipboard == nil:
    GlobalFree(clipbuffer)
    CloseClipboard()
    return false

  # Convert the Nim string to a wide string (UTF-16)
  let wideText = newWideCString(text)
  let wideTextPtr = cast[pointer](wideText[0].addr)  # Get a pointer to the wide string
  copyMem(szClipboard, wideTextPtr, textLen * sizeof(WCHAR))
  discard GlobalUnlock(clipbuffer)

  # Set the clipboard data
  if SetClipboardData(CF_UNICODETEXT, clipbuffer) == 0:  # Compare to 0 instead of nil
    GlobalFree(clipbuffer)
    CloseClipboard()
    return false

  # Close the clipboard
  CloseClipboard()
  return true


proc getClipboardText*(): string =
  ## Reads Unicode text from the clipboard.
  ## Returns the text as a Nim string, or an empty string if no text is available.

  # Open the clipboard
  if OpenClipboard(0) == FALSE:
    return ""

  # Get the clipboard data in CF_UNICODETEXT format
  let clipData = GetClipboardData(CF_UNICODETEXT)
  if clipData == 0:  # Compare to 0 instead of nil
    CloseClipboard()
    return ""

  # Lock the global memory and get a pointer to the data
  let szClipboard = cast[ptr WCHAR](GlobalLock(clipData))
  if szClipboard == nil:
    CloseClipboard()
    return ""

  # Convert the wide string (UTF-16) to a Nim string (UTF-8)
  result = $szClipboard

  # Unlock the global memory
  discard GlobalUnlock(clipData)

  # Close the clipboard
  CloseClipboard()
