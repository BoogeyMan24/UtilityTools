//
//  ContentView.swift
//  UtilityTools
//
//  Created by BoogeyMan on 04/03/2023.
//

import SwiftUI

class UtilityToolsState: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var menuIsOpen: Bool = false
    
    @Published var rows: Int = 5
    @Published var modules: Array<Module> = [SusStates(), CPUStates(), MemoryStates(), DiskStates()]
    @Published var modulesStr: Array<String?> = ["SUS", "CPU", "MEM", "DISK"]
    @Published var modulesUsedStr: Array<String?> = ["CPU", "MEM", "DISK", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS"]
    
    @Published var timer: Float = 1
    
    @Published var on: Bool = true
    @Published var isOpen: Bool = false
    
    init() {
        rows = defaults.integer(forKey: "saveRows")
        modulesUsedStr = defaults.stringArray(forKey: "saveModules")!
        timer = defaults.float(forKey: "saveTimer")
        on = defaults.bool(forKey: "saveOn")
    }
}

struct TitleView: View {
    @ObservedObject var utilityToolsState: UtilityToolsState
    
    
    var body: some View {
        let onBinding = Binding(
            get: { self.utilityToolsState.on },
            set: { self.utilityToolsState.on = $0 }
                )
        HStack {
            Spacer()
            Spacer()
            Text("UtilityTools").font(.system(size: 14)).bold(true)
            Spacer()
            Toggle(isOn: onBinding) {
                
            }.toggleStyle(.switch)
        }.padding([.horizontal], 15).padding([.vertical], 5)
    }
}


struct UtilityToolsView: View {
    @ObservedObject var utilityToolsState: UtilityToolsState
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<utilityToolsState.rows, id: \.self) { i in
                let i = i * 3
                HStack(alignment: .center, spacing: 15) {
                    ForEach(0...2, id: \.self) { j in
                        let j: Int = Int(i) + Int(j)
                        if utilityToolsState.modulesUsedStr.count <= j || utilityToolsState.modulesUsedStr[j] == "SUS" {
                            SusModule(susStates: utilityToolsState.modules[0] as! SusStates)
                        } else if utilityToolsState.modulesUsedStr[j] == "CPU" {
                            CPUModule(cpuStates: utilityToolsState.modules[1] as! CPUStates)
                        } else if utilityToolsState.modulesUsedStr[j] == "MEM" {
                            MemoryModule(memoryStates: utilityToolsState.modules[2] as! MemoryStates)
                        } else if utilityToolsState.modulesUsedStr[j] == "DISK" {
                            DiskModule(diskStates: utilityToolsState.modules[3] as! DiskStates)
                        }
                    }
                }
                .padding([.horizontal], 15)
                .padding([.vertical], 7.5)
            }
        }
        .padding(5)
    }
    
    func startTimer() {
        utilityToolsState.modules.forEach { state in
            state.setType()
        }
        
        let timer: Timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(utilityToolsState.timer), repeats: true, block: { _ in
            if ApplicationMenu.utilityToolsState.on {
                utilityToolsState.modules.forEach { state in
                    if utilityToolsState.modulesUsedStr.contains(state.typeState) {
                        state.updateProgress()
                    }
                }
            }
        })
        
        RunLoop.main.add(timer, forMode: .common)
    }
}
