import AppKit
import Foundation

let args = CommandLine.arguments
if args.count < 3 {
  print("\(args[0]) APP_NAME [KEY KEY ...]")
  print("APP_NAME: an executable file name (not a path)")
  print("KEY:      a key or key combination (e.g. a, cmd+a, alt+shift+e)")
  exit(1)
}

let appName = args[1]
let keyStrokes = Array(args[2...])

let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

func getKeyCode(name: String) -> CGKeyCode? {
  return keyNameToCode[name.lowercased()]
}

func postKeyUpDownEvent(pid: pid_t, keyName: String, flags: CGEventFlags) {
  if let keyCode = getKeyCode(name: keyName) {
    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
    keyDown?.flags = flags
    keyDown?.postToPid(pid)
    usleep(1000)  // sometimes required, but why...?

    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
    keyUp?.postToPid(pid)
    usleep(1000)  // sometimes required, but why...?
  } else {
    print("unsupported key name: \(keyName)")
  }
}

func postKeyConvination(pid: pid_t, keyConvination: String) {
  let keys = keyConvination.components(separatedBy: "+")
  var mask: CGEventFlags = []

  for k in keys {
    switch k {
    case "shift": mask.insert(CGEventFlags.maskShift)
    case "cmd": mask.insert(CGEventFlags.maskCommand)
    case "opt": mask.insert(CGEventFlags.maskAlternate)
    case "ctl": mask.insert(CGEventFlags.maskControl)
    default: break
    }
  }

  if let lastKey = keys.last {
    postKeyUpDownEvent(pid: pid, keyName: lastKey, flags: mask)
  }
}

func postKeyStrokes(pid: pid_t, keyStrokes: [String]) {
  for k in keyStrokes {
    postKeyConvination(pid: pid, keyConvination: k)
  }
}

func getPidByName(executableFileName: String) -> pid_t? {
  let apps = NSWorkspace.shared.runningApplications
  for a in apps {
    if a.executableURL?.lastPathComponent == executableFileName {
      return a.processIdentifier
    }
  }
  return nil
}

if let pid = getPidByName(executableFileName: appName) {
  postKeyStrokes(pid: pid, keyStrokes: keyStrokes)
} else {
  print("executable '\(appName)' not found in user processes")
}
