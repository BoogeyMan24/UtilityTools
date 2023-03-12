//
//  MemoryModule.swift
//  PopTools
//
//  Created by BoogeyMan on 06/03/2023.
//

import Foundation
import SwiftUI


struct MemoryModule: View {
    @ObservedObject var memoryStates: MemoryStates
    
    var body: some View {
        ProgressBar(progress: memoryStates.progress, type: memoryStates.type, dangerLimit: memoryStates.dangerLimit)
    }
}


class MemoryStates: Module {
    @Published var progress: Float = 0
    
    @Published var dangerLimit: Float = 0.7
    @Published var type: String = "MEM"
    
    
    override func updateProgress() {
        progress = calcMemUsage()
    }
    
    override func setType() {
        typeState = type
    }
    
    func calcMemUsage() -> Float {
        let memUsage = MemoryStates.memoryUsage()
        let memUsageTotal = memUsage.active + memUsage.wired + memUsage.compressed
        
        let usage = memUsageTotal / MemoryStates.physicalMemory()
        
        return Float(usage)
    }
    
    static func physicalMemory() -> Double {
        return Double((ProcessInfo().physicalMemory / 1024) / 1024 / 1024) // in GB
    }
    
    static let PAGE_SIZE = vm_kernel_page_size
    
    static func memoryUsage() -> (free       : Double,
                                         active     : Double,
                                         inactive   : Double,
                                         wired      : Double,
                                         compressed : Double) {
        let stats = VMStatistics64()
        
        let free     = Double(stats.free_count) * Double(PAGE_SIZE)     / Unit.gigabyte.rawValue
        let active   = Double(stats.active_count) * Double(PAGE_SIZE)   / Unit.gigabyte.rawValue
        let inactive = Double(stats.inactive_count) * Double(PAGE_SIZE) / Unit.gigabyte.rawValue
        let wired    = Double(stats.wire_count) * Double(PAGE_SIZE)     / Unit.gigabyte.rawValue
        
        // Result of the compression. This is what you see in Activity Monitor
        let compressed = Double(stats.compressor_page_count) * Double(PAGE_SIZE) / Unit.gigabyte.rawValue
        
        return (free, active, inactive, wired, compressed)
    }
    
    
    static func VMStatistics64() -> vm_statistics64 {
        let host_port: host_t = mach_host_self()

        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size))

        var returnData:vm_statistics64 = vm_statistics64.init()
        _ = withUnsafeMutablePointer(to: &returnData) {
            (p:UnsafeMutablePointer<vm_statistics64>) -> Bool in

            return p.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                (pp:UnsafeMutablePointer<integer_t>) -> Bool in

                let retvalue = host_statistics64(host_port, HOST_VM_INFO64, pp, &host_size)
                return retvalue == KERN_SUCCESS
            }
        }
        
        return returnData
    }
}
