//
//  ProgressBar.swift
//  PopTools
//
//  Created by BoogeyMan on 06/03/2023.
//

import Foundation
import SwiftUI

struct ProgressBar: View {
    
    var progress: Float
    var type: String
    
    var dangerLimit: Float
    
    var primary: Color = Color.blue
    var secondary: Color = Color.yellow
    var danger: Color = Color.red
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text(String(Int((self.progress * 100).rounded(.toNearestOrAwayFromZero)))).font(.system(size: 18))
                    Text(self.type).font(.system(size: 8))
                }
                Circle()
                    .stroke(lineWidth: 8)
                    .opacity(0.2)
                    .foregroundColor(Color.gray)
                Circle()
                    .trim(from: 0, to: CGFloat(min(self.progress, 1)))
                    .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                    .foregroundColor((progress >= dangerLimit ? danger : primary))
                    .rotationEffect(Angle(degrees: 270))
                    .animation(Animation.linear(duration: 1.0), value: progress)
            }.frame(width: 55, height: 55)
        }
    }
}
