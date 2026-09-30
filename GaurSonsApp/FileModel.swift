//
//  FileModel.swift
//  GaurSonsApp
//
//  Created by Sakshi on 17/09/25.
//  Copyright © 2025 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

struct FileModel {
    let fileName: String
    let fileData: Data
    let fileSize: String // New property to store human-readable size
    
    init(fileName: String, fileData: Data) {
        self.fileName = fileName
        self.fileData = fileData
        
        // Compute file size as a string (e.g., "3.9 KB", "147 KB")
        self.fileSize = ByteCountFormatter.string(fromByteCount: Int64(fileData.count), countStyle: .file)
    }
}
