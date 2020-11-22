import AppKit
import Foundation

let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

func getKeyCode(_ name: String) throws -> CGKeyCode {
  guard let keyCode = keyNameToCode[name.lowercased()] else {
    throw AppError.unsupportedKeyName(name)
  }
  return keyCode
}

func postKeyUpDownEvent(pid: pid_t, keyName: String, flags: CGEventFlags, durationSec: Float) throws
{
  let keyCode = try getKeyCode(keyName)

  let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
  keyDown?.flags = flags
  keyDown?.postToPid(pid)
  usleep(UInt32(durationSec * 1000_000))  // sometimes required, but why...?

  let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
  keyUp?.postToPid(pid)
}

func postKeyConvination(pid: pid_t, keyConvination: String, intervalSec: Float) throws {
  let keys = keyConvination.components(separatedBy: "+")
  var mask: CGEventFlags = []

  let modifierKeys = keys[..<(keys.count - 1)]
  for k in modifierKeys {
    switch k {
    case "shift": mask.insert(CGEventFlags.maskShift)
    case "cmd": mask.insert(CGEventFlags.maskCommand)
    case "opt": mask.insert(CGEventFlags.maskAlternate)
    case "ctl": mask.insert(CGEventFlags.maskControl)
    default:
      throw AppError.unsupportedModifierKeyName(k)
    }
  }

  if let lastKey = keys.last {
    try postKeyUpDownEvent(pid: pid, keyName: lastKey, flags: mask, durationSec: intervalSec)
  }
}

func postKeyStrokes(pid: pid_t, keyStrokes: [String], intervalSec: Float) throws {
  for k in keyStrokes {
    try postKeyConvination(pid: pid, keyConvination: k, intervalSec: intervalSec)
  }
}
