import Foundation

class D28BookChain {
    static func isSupported() -> Bool {
        let current = Utils.buildToUInt64(UIDevice.current.buildVersion)
        let firstPatchedBuild = Utils.buildToUInt64("23C5033h")
        return current < firstPatchedBuild
    }
    
    static func replaceMobileGestalt(udid: String, path: String) {
        guard isSupported() else {
            print("Not supported on this iOS version.")
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let d28LocalPath = documentsDirectory.appendingPathComponent("downloads.28.sqlitedb").path
        if !FileManager.default.fileExists(atPath: d28LocalPath) {
            print("downloads.28.sqlitedb not found in Documents folder.")
            return
        }
        
        let filesToTransfer = [
            "Downloads/downloads.28.sqlitedb": d28LocalPath,
            "Downloads/downloads.28.sqlitedb-shm": d28LocalPath + "-shm",
            "Downloads/downloads.28.sqlitedb-wal": d28LocalPath + "-wal"
            
        ]
        print("TODO")
        /*
        MobileDevice.requireAppleFileConduitService(udid: udid) { client in
            for (remotePath, localPath) in filesToTransfer {
                print("Transferring \(localPath) to \(remotePath)...")
                
                var handle: UInt64 = 0
                let err = afc_file_open(client, remotePath, AFC_FOPEN_WRONLY, &handle)
                guard err == AFC_E_SUCCESS else {
                    print("Failed to open \(remotePath) for writing: \(err.rawValue)")
                    return
                }
                
                let data = try! Data(contentsOf: URL(fileURLWithPath: localPath))
                _ = data.withUnsafeBytes({ (pdata) -> UInt32 in
                    var bytesWritten: UInt32 = 0
                    let pdata = pdata.baseAddress?.bindMemory(to: Int8.self, capacity: data.count)
                    let error = afc_file_write(client, handle, pdata, UInt32(data.count), &bytesWritten)
                    if error != AFC_E_SUCCESS {
                        print("Failed to write data to \(remotePath): \(error.rawValue)")
                    } else {
                        print("Replaced \(remotePath)")
                    }
                    return bytesWritten
                })
                afc_file_close(client, handle)
            }
        }
         */
    }
}
