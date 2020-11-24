import AppKit
import ArgumentParser

enum AppError: Error {
  case targetProcessNotFound(_ target: String)
  case unsupportedKeyName(_ keyName: String)
  case unsupportedModifierKeyName(_ keyName: String)
  case syntaxError(_ reason: String)
}

struct SendKeyToApp: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Send key strokes to a specific application."
  )

  @Option(name: .shortAndLong, help: "Specify target by pid.")
  var pid: pid_t?

  @Option(
    name: .shortAndLong,
    help:
      ArgumentHelp(
        "Specify target by an executable file name (not a path).",
        valueName: "name"
      )
  )
  var appName: String?

  @Option(
    name: [.customShort("t"), .long],
    help: ArgumentHelp(
      """
      Time duration(seconds) per each key input.
      Some application requires appropreate this value to detect keys and action.
      """,
      valueName: "sec"
    )
  )
  var interval: Float = 0.01

  @Argument(help: "A key or a key with modifiers (eg: a, cmd+a, alt+shift+e).")
  var keys: [String]

  func validate() throws {
    guard pid != nil || appName != "" else {
      throw ValidationError("Ether <pid> or <app-name> is required.")
    }
  }

  func getPid() throws -> pid_t {
    guard let appName = appName else {
      return pid!
    }
    return try getPidByName(appName)
  }

  mutating func run() throws {
    let sender = KeySender(pid: try getPid(), keyIntervalUsec: UInt32(interval * 1000_000))
    try sender.postKeyStrokes(keys)
  }
}

SendKeyToApp.main()
