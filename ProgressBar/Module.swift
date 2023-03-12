//
//  Module.swift
//  UtilityTools
//
//  Created by BoogeyMan on 06/03/2023.
//

import Foundation
import SwiftUI

public enum Unit : Double {
    // For going from byte to -
    case byte     = 1
    case kilobyte = 1024
    case megabyte = 1048576
    case gigabyte = 1073741824
}

class Module: ObservableObject {
    
    var typeState: String = ""

    
    func updateProgress() {
        print("Empty Update Progress")
    }
    
    func setType() {
        print("No Set Type")
    }
}

