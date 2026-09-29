import Foundation

// Usage: nse-cli <app-group-directory> <room-id> <event-id>
// Runs the Notification Service Extension logic as its own process.
let arguments = CommandLine.arguments
guard arguments.count == 4 else {
    FileHandle.standardError.write(Data("usage: nse-cli <group-dir> <room-id> <event-id>\n".utf8))
    exit(2)
}

let result = NseResolver.resolve(
    groupDirectory: URL(fileURLWithPath: arguments[1]),
    roomId: arguments[2],
    eventId: arguments[3]
)
var printable = result
printable.removeValue(forKey: "body")
print(printable)
exit(result["ok"] as? Bool == true ? 0 : 1)
