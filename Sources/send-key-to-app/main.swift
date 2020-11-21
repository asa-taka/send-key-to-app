import Foundation
import AppKit

let args = CommandLine.arguments
if args.count != 3 {
  print("\(args[0]) [APP_NAME] [KEY_CODE]")
  print("APP_NAME: an executable file name (not a path)")
  print("KEY_CODE: a number such as 123(LEFT), 124(RIGHT), ...")
  exit(1)
}

let appName = args[1]
let keyCode = UInt16(args[2]) ?? 0

let src = CGEventSource(stateID: CGEventSourceStateID.combinedSessionState)

func sendKeyStroke(pid: pid_t, keyCode: UInt16) {
  let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
  keyUp?.postToPid(pid)
  usleep(1000) // required, but why...?
  let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
  keyDown?.postToPid(pid)
}

func getPidByName(executableFileName: String) -> Optional<pid_t> {
  let apps = NSWorkspace.shared.runningApplications
  for a in apps {
    if a.executableURL?.lastPathComponent == executableFileName {
      return a.processIdentifier
    }
  }
  return nil
}

if let pid = getPidByName(executableFileName: appName) {
  sendKeyStroke(pid: pid, keyCode: keyCode)
} else {
  print("executable '\(appName)' not found in user processes")
}
