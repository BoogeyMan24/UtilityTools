//
//  CPUModule.swift
//  PopTools
//
//  Created by BoogeyMan on 06/03/2023.
//

import Foundation
import SwiftUI


struct CPUModule: View {
    @ObservedObject var cpuStates: CPUStates
    
    var body: some View {
        ProgressBar(progress: cpuStates.progress, type: cpuStates.type, dangerLimit: cpuStates.dangerLimit)
    }
}


class CPUStates: Module {
    @Published var progress: Float = 0

    @Published var dangerLimit: Float = 0.9
    @Published var type: String = "CPU"
    
    @Published var loadPrev: host_cpu_load_info = host_cpu_load_info(cpu_ticks: (UInt32(0), UInt32(0), UInt32(0), UInt32(0)))
    
    
    override func updateProgress() {
        progress = calcCPUUsage()
    }
    
    override func setType() {
        typeState = type
    }

    func calcCPUUsage() -> Float {
        var load: host_cpu_load_info
        
        load = hostCPULoadInfo()!
        
        if loadPrev.cpu_ticks.0 == 0 {
            loadPrev = load
            return -0.01
        }
        
        
        let userDif: UInt32 = (load.cpu_ticks.0) - (loadPrev.cpu_ticks.0)
        let systemDif: UInt32 = (load.cpu_ticks.1) - (loadPrev.cpu_ticks.1)
        let idleDif: UInt32 = (load.cpu_ticks.2) - (loadPrev.cpu_ticks.2)
        let niceDif: UInt32 = (load.cpu_ticks.3) - (loadPrev.cpu_ticks.3)

        let total = userDif + systemDif + idleDif + niceDif
        
        if total == 0 {
            return -0.02
        }
        
        let usage: Float = Float((userDif + systemDif + niceDif)) / Float(total)
        
        loadPrev = load
        
        
        return usage
    }

    func hostCPULoadInfo() -> host_cpu_load_info? {
        let HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        var cpuLoadInfo = host_cpu_load_info()

        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        if result != KERN_SUCCESS{
            print("Error  - \(#file): \(#function) - kern_result_t = \(result)")
            return nil
        }
        
        return cpuLoadInfo
    }
}
