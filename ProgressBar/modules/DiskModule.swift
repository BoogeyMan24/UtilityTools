//
//  DiskModule.swift
//  UtilityTools
//
//  Created by BoogeyMan on 06/03/2023.
//

import Foundation
import SwiftUI
import Cocoa


struct DiskModule: View {
    @ObservedObject var diskStates: DiskStates    
    
    var body: some View {
        ProgressBar(progress: diskStates.progress, type: diskStates.type, dangerLimit: diskStates.dangerLimit)
    }
}


class DiskStates: Module {
    @Published var progress: Float = 0.9
    
    @Published var dangerLimit: Float = 0.8
    @Published var type: String = "DISK"
    
    
    override func updateProgress() {
        self.progress = calcDiskSpace()

    }
    
    override func setType() {
        typeState = type
    }
    
    func calcDiskSpace() -> Float {
        return Float(1 - (getFreeSpace() / getTotalSpace()))
    }

    func getTotalSpace() -> Double {
        do {
            let fileAttributes = try FileManager.default.attributesOfFileSystem(forPath: "/")
            if let size: Double = fileAttributes[FileAttributeKey.systemSize] as? Double {
                return size
            }
        } catch { }
        return 0
    }
    
    func getFreeSpace2() -> Double {
        do {
            let fileAttributes = try FileManager.default.attributesOfFileSystem(forPath: "/")
            if let size: Double = fileAttributes[FileAttributeKey.systemFreeSize] as? Double {
                return size
            }
        } catch { }
        return 0
    }
    
    func getFreeSpace() -> Double {
        let fileURL = URL(fileURLWithPath: NSHomeDirectory())
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            if let capacity: Int64 = values.volumeAvailableCapacityForImportantUsage {
                return Double(capacity)
            }
        } catch {

        }
        return 1
    }
}
