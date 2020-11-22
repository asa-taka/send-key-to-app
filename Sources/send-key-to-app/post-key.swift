import AppKit
import Foundation

let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

func getKeyCode(_ name: String) throws -> CGKeyCode {
  guard let keyCode = keyNameToCode[name.lowercased()] else {
    throw AppError.unsupportedKeyName(name)
  }
  return keyCode
}

class KeySender {
  var keyIntervalUsec: UInt32
  var pid: pid_t

  init(pid: pid_t, keyIntervalUsec: UInt32) {
    self.pid = pid
    self.keyIntervalUsec = keyIntervalUsec
  }

  func postKeyUpDownEvent(_ keyName: String, flags: CGEventFlags) throws {
    let keyCode = try getKeyCode(keyName)

    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
    keyDown?.flags = flags
    keyDown?.postToPid(pid)
    usleep(self.keyIntervalUsec)

    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
    keyUp?.postToPid(pid)
  }

  func postKeyCombination(_ keyCombination: String) throws {
    let keys = keyCombination.components(separatedBy: "+")
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
      try postKeyUpDownEvent(lastKey, flags: mask)
    }
  }

  func postKeyStrokes(_ keyStrokes: [String]) throws {
    for k in keyStrokes {
      try postKeyCombination(k)
    }
  }
}
