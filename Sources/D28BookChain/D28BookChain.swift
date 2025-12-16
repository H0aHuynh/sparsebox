import Foundation

class D28BookChain {
    static func isSupported() -> Bool {
        let current = Utils.buildToUInt64(UIDevice.current.buildVersion)
        let firstPatchedBuild = Utils.buildToUInt64("23C5033h")
        return current < firstPatchedBuild
    }
    
    static func replaceMobileGestalt(udid: String, path: String) {
        guard isSupported() else {
            print("Tính năng này không được hỗ trợ trên phiên bản iOS này.")
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let d28LocalPath = documentsDirectory.appendingPathComponent("downloads.28.sqlitedb").path
        if !FileManager.default.fileExists(atPath: d28LocalPath) {
            print("downloads.28.sqlitedb Không tìm thấy trong thư mục Tài liệu.")
            return
        }
        
        let filesToTransfer = [
            "Downloads/downloads.28.sqlitedb": d28LocalPath,
            "Downloads/downloads.28.sqlitedb-shm": d28LocalPath + "-shm",
            "Downloads/downloads.28.sqlitedb-wal": d28LocalPath + "-wal"  
        ]
        print("TODO")
    }
}
