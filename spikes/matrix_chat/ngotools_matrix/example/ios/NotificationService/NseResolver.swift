import Foundation
import ngotools_matrix_core

/// Shared by the Notification Service Extension and the spike's `nse-cli`
/// (which runs the same code as a separate simulator process, because
/// `simctl push` does not invoke service extensions).
enum NseResolver {
    static let appGroup = "group.tools.ngo.spike.matrix"

    /// Resolves the pushed event through the Rust facade and records the
    /// result (duration, memory footprint) in the App Group container.
    static func resolve(groupDirectory: URL, roomId: String, eventId: String) -> [String: Any] {
        guard let config = try? String(contentsOf: groupDirectory.appendingPathComponent("nse-config.json"), encoding: .utf8) else {
            return ["ok": false, "error": "missing nse-config.json"]
        }

        let footprintBefore = physicalFootprint()
        var resultJson = "{}"
        if let raw = ngotools_nse_get_notification(config, roomId, eventId) {
            resultJson = String(cString: raw)
            ngotools_nse_string_free(raw)
        }

        var result = (try? JSONSerialization.jsonObject(with: Data(resultJson.utf8))) as? [String: Any] ?? [:]
        result["footprint_before_bytes"] = footprintBefore
        result["footprint_after_bytes"] = physicalFootprint()
        result["event_id"] = eventId

        if let data = try? JSONSerialization.data(withJSONObject: result) {
            let name = "nse-result-\(eventId.replacingOccurrences(of: "$", with: "")).json"
            try? data.write(to: groupDirectory.appendingPathComponent(name))
        }

        return result
    }

    static func physicalFootprint() -> UInt64 {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
        let status = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        return status == KERN_SUCCESS ? info.phys_footprint : 0
    }
}
