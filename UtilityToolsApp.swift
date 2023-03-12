//
//  UtilityToolsApp.swift
//  UtilityTools
//
//  Created by BoogeyMan on 04/03/2023.
//

import SwiftUI

@main
struct UtilityToolsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: 20)
    var menu: ApplicationMenu = ApplicationMenu()
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.accessory)
        return false
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        self.menu = ApplicationMenu()
        
        setDefaults()
        
        let image = NSImage(systemSymbolName: "gearshape.circle", accessibilityDescription: "A gear inside of a circle.")
        let config = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
        
        statusBarItem.button?.image = image?.withSymbolConfiguration(config)!
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = AppDelegate.instance.menu.createMenu()
        AppDelegate.instance.menu.startTimer()
        
        AppDelegate.instance.menu.buildSettingsWindow()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.set(ApplicationMenu.utilityToolsState.on, forKey: "saveOn")
        defaults.set(ApplicationMenu.utilityToolsState.rows, forKey: "saveRows")
        defaults.set(ApplicationMenu.utilityToolsState.modulesUsedStr, forKey: "saveModules")
        defaults.set(ApplicationMenu.utilityToolsState.timer, forKey: "saveTimer")
    }
    
    func updateViewSizes() {
        statusBarItem.menu = AppDelegate.instance.menu.createMenu()
    }
    
    func setDefaults() {
        let defaults = UserDefaults.standard
        let defaultValue = ["saveOn": true, "saveRows" : 2, "saveModules": ["CPU", "MEM", "DISK", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS", "SUS"], "saveTimer": 1] as [String : Any]
        defaults.register(defaults: defaultValue)
    }
}
