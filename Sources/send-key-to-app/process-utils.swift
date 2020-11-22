import AppKit

func getPidByName(_ executableFileName: String) throws -> pid_t {
  let apps = NSWorkspace.shared.runningApplications
  for a in apps {
    if a.executableURL?.lastPathComponent == executableFileName {
      return a.processIdentifier
    }
  }
  throw AppError.targetProcessNotFound("executableFileName: \(executableFileName)")
}
