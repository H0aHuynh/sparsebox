//
//  Databases.swift
//  SparseBox
//
//  Created by Duy Tran on 20/11/25.
//

import Foundation
import SQLite3

class Databases {
    static func patchDatabase(dbPath: String, uuid: String, ip: String, port: UInt16) throws {
        var db: OpaquePointer?
        
        // Open database
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            throw NSError(domain: "SQLite", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to open DB"])
        }
        defer { sqlite3_close(db) }
        
        let bldbLocalPrefix =
        "/private/var/containers/Shared/SystemGroup/\(uuid)/Documents/BLDatabaseManager/BLDatabaseManager.sqlite"
        let sql1 = """
        UPDATE asset
        SET local_path = CASE
            WHEN local_path LIKE '%/BLDatabaseManager.sqlite'
                THEN '\(bldbLocalPrefix)'
            WHEN local_path LIKE '%/BLDatabaseManager.sqlite-shm'
                THEN '\(bldbLocalPrefix)-shm'
            WHEN local_path LIKE '%/BLDatabaseManager.sqlite-wal'
                THEN '\(bldbLocalPrefix)-wal'
        END
        WHERE local_path LIKE '/private/var/containers/Shared/SystemGroup/%/Documents/BLDatabaseManager/BLDatabaseManager.sqlite%';
    """
        
        try execSQL(db: db, sql: sql1)
        
        let bldbServerPrefix = "http://\(ip):\(port)/BLDatabaseManager.sqlite"
        let sql2 = """
        UPDATE asset
        SET url = CASE
            WHEN url LIKE '%/BLDatabaseManager.sqlite'
                THEN '\(bldbServerPrefix)'
            WHEN url LIKE '%/BLDatabaseManager.sqlite-shm'
                THEN '\(bldbServerPrefix)-shm'
            WHEN url LIKE '%/BLDatabaseManager.sqlite-wal'
                THEN '\(bldbServerPrefix)-wal'
        END
        WHERE url LIKE '%/BLDatabaseManager.sqlite%';
    """
        
        try execSQL(db: db, sql: sql2)
        
        _ = sqlite3_exec(db, "COMMIT;", nil, nil, nil)
    }
    
    @discardableResult
    static func execSQL(db: OpaquePointer?, sql: String) throws -> Int32 {
        var errMsg: UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(db, sql, nil, nil, &errMsg)
        if result != SQLITE_OK {
            let message = errMsg.flatMap { String(cString: $0) } ?? "Unknown SQL error"
            sqlite3_free(errMsg)
            throw NSError(domain: "SQLite", code: Int(result),
                          userInfo: [NSLocalizedDescriptionKey: message])
        }
        return result
    }
}
