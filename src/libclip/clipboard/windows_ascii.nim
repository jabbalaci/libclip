# It works with ASCII characters but not with Unicode.
# Unicode characters are screwed up.

type
  HANDLE = int
  HWND = HANDLE
  UINT = cuint
  LPCSTR = cstring
  BOOL = int32
  SIZE_T = uint

const
  CF_TEXT = 1
  GMEM_MOVEABLE = 0x0002

{.push stdcall, dynlib: "user32", importc.}
proc OpenClipboard(hWndNewOwner: HWND): BOOL
proc CloseClipboard(): BOOL
proc GetClipboardData(uFormat: UINT): HANDLE
proc EmptyClipboard(): BOOL
proc IsClipboardFormatAvailable(format: UINT): BOOL
proc SetClipboardData(uFormat: UINT, hMem: HANDLE): HANDLE
{.pop.}

{.push stdcall, dynlib: "kernel32", importc.}
proc GlobalLock(hMem: HANDLE): pointer
proc GlobalUnlock(hMem: HANDLE): BOOL
proc GlobalAlloc(uFlags: UINT, dwBytes: SIZE_T): HANDLE
proc GlobalFree(hMem: HANDLE): HANDLE
proc lstrcpyA(lpString1: pointer, lpString2: LPCSTR): LPCSTR {.importc: "lstrcpyA".}
{.pop.}


proc getClipboardText*(): string =
  if OpenClipboard(0) != 0:
    try:
      if IsClipboardFormatAvailable(CF_TEXT) != 0:
        let hData = GetClipboardData(CF_TEXT)
        if hData != 0:
          let pszText = cast[cstring](GlobalLock(hData))
          if pszText != nil:
            result = $pszText
            discard GlobalUnlock(hData)
    finally:
      discard CloseClipboard()


proc setClipboardText*(text: string): bool =
  result = false
  # Add 1 for null terminator
  let textLen = text.len + 1
  let hMem = GlobalAlloc(GMEM_MOVEABLE, textLen.SIZE_T)

  if hMem != 0:
    let pszData = GlobalLock(hMem)
    if pszData != nil:
      # Copy the string to the allocated memory
      discard lstrcpyA(pszData, text.cstring)
      discard GlobalUnlock(hMem)

      if OpenClipboard(0) != 0:
        discard EmptyClipboard()
        if SetClipboardData(CF_TEXT, hMem) != 0:
          result = true
        discard CloseClipboard()

    # If we failed, free the memory
    if not result:
      discard GlobalFree(hMem)
