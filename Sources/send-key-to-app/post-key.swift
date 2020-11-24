import AppKit
import Foundation

let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

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

  // parse modifier+key
  func postKeyCombination(_ keyCombination: String) throws {
    let keys = keyCombination.components(separatedBy: "+")
    let modifierKeys = keys[..<(keys.count - 1)]

    var mask: CGEventFlags = []
    for k in modifierKeys {
      mask.insert(try getModifierKeyFlag(k))
    }

    if let mainKey = keys.last {
      try postKeyUpDownEvent(mainKey, flags: mask)
    }
  }

  // parse key=count
  func postKeystroke(_ keyStroke: String) throws {
    let keyAndCount = keyStroke.components(separatedBy: "^")
    let k = keyAndCount[0]

    guard let n = keyAndCount.count == 2 ? Int(keyAndCount[1]) : 1 else {
      throw AppError.syntaxError("could not parse repeat times: \(keyStroke)")
    }

    for _ in 1...n {
      try postKeyCombination(k)
    }
  }

  func postKeyStrokes(_ keyStrokes: [String]) throws {
    for k in keyStrokes {
      try postKeystroke(k)
    }
  }
}
