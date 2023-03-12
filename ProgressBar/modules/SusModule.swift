//
//  SusModule.swift
//  PopTools
//
//  Created by BoogeyMan on 06/03/2023.
//

import Foundation
import SwiftUI


struct SusModule: View {
    @ObservedObject var susStates: SusStates
    
    var body: some View {
        ProgressBar(progress: susStates.progress, type: susStates.type, dangerLimit: susStates.dangerLimit)
    }
}


class SusStates: Module {
    @Published var progress: Float = 0.9
    
    @Published var dangerLimit: Float = 0.8
    @Published var type: String = "SUS"
    
    override func updateProgress() {
        progress = calcSusUsage()
    }
    
    override func setType() {
        typeState = type
    }
    
    func calcSusUsage() -> Float {
        progress += Float.random(in: -0.03...0.03)
        if progress > 1 {
            progress = 1
        } else if progress < 0 {
            progress = 0
        }
        
        return progress
    }
}
