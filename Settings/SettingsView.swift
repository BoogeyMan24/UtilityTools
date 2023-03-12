//
//  SettingsView.swift
//  UtilityTools
//
//  Created by BoogeyMan on 07/03/2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var utilityToolsState: UtilityToolsState = ApplicationMenu.utilityToolsState
    
    @State var timer: Float = ApplicationMenu.utilityToolsState.timer
    @State var rows: Float = Float(ApplicationMenu.utilityToolsState.rows)
    @State var openAtLogin = false
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<utilityToolsState.rows, id: \.self) { i in
                    let i = i * 3
                    HStack(alignment: .center, spacing: 15) {
                        ForEach(0...2, id: \.self) { j in
                            let j: Int = i + j
                            VStack{
                                if utilityToolsState.modulesUsedStr.count <= j || utilityToolsState.modulesUsedStr[j] == "SUS" {
                                    SusModule(susStates: utilityToolsState.modules[0] as! SusStates)
                                } else if utilityToolsState.modulesUsedStr[j] == "CPU" {
                                    CPUModule(cpuStates: utilityToolsState.modules[1] as! CPUStates)
                                } else if utilityToolsState.modulesUsedStr[j] == "MEM" {
                                    MemoryModule(memoryStates: utilityToolsState.modules[2] as! MemoryStates)
                                } else if utilityToolsState.modulesUsedStr[j] == "DISK" {
                                    DiskModule(diskStates: utilityToolsState.modules[3] as! DiskStates)
                                }
                                
                                Menu {
                                    ForEach((0..<utilityToolsState.modules.count), id: \.self) { i in
                                        Button(utilityToolsState.modules[i].typeState) {
                                            changeModule(id: j, module: utilityToolsState.modules[i].typeState)
                                        }
                                    }
                                }
                                label: {
                                    Text((utilityToolsState.modulesUsedStr.count > j ? utilityToolsState.modulesUsedStr[j]! : "SUS"))
                                }
                            }
                        }
                    }
                    .padding([.horizontal], 15)
                    .padding([.vertical], 7.5)
                }
            }
            .padding(5)
            
            Divider()
            
            HStack {
                Spacer()
                Text("Time Between Updates (Save & Restart Required): " + String(format: "%.1f", timer))
                Spacer()
                Slider(value: $timer, in: 0.5...10, step: 0.5).frame(width: 250, height: 50).tint(Color.blue)
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("Number of rows (Save Required): " + String(format: "%.0f", rows))
                Spacer()
                Slider(value: $rows, in: 1...10, step: 1).frame(width: 250, height: 50).tint(Color.blue)
                Spacer()
            }
            
            HStack {
                Toggle("Open at Login (Doesn't work)", isOn: $openAtLogin).toggleStyle(.switch)
                Spacer()
            }.padding([.horizontal],15)
            
            HStack {
                Spacer()
                Button("Save and Close") {
                    save()
                }
            }.padding([.horizontal], 10)
        }
    }
    
    func save() {
        ApplicationMenu.utilityToolsState.timer = timer
        ApplicationMenu.utilityToolsState.rows = Int(rows)
        
        ApplicationMenu.settingsWindow.close()
        AppDelegate.instance.menu.buildSettingsWindow()
        AppDelegate.instance.updateViewSizes()
    }
    
    func changeModule(id: Int, module: String) {
        ApplicationMenu.utilityToolsState.modulesUsedStr[id] = module
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
