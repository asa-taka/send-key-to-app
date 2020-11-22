import AppKit
import ArgumentParser

enum AppError: Error {
  case targetProcessNotFound(_ target: String)
  case unsupportedKeyName(_ keyName: String)
  case unsupportedModifierKeyName(_ keyName: String)
}

struct SendKeyToApp: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Send key strokes to specific application."
  )

  @Option(name: .shortAndLong, help: "specify target by pid")
  var pid: pid_t?

  @Option(name: .shortAndLong, help: "specify target by an executable file name (not a path)")
  var appName: String?

  @Argument(help: "a key or key with modifiers (eg: a, cmd+a, alt+shift+e)")
  var keys: [String]

  func validate() throws {
    guard pid != nil || appName != "" else {
      throw ValidationError("Ether <pid> or <app-name> is required")
    }
  }

  func getPid() throws -> pid_t {
    if let appName = appName {
      if let pid = getPidByName(appName) {
        return pid
      } else {
        throw AppError.targetProcessNotFound("executableFileName: \(appName)")
      }
    } else {
      return pid!
    }
  }

  mutating func run() throws {
    try postKeyStrokes(pid: try getPid(), keyStrokes: keys)
  }
}

SendKeyToApp.main()
