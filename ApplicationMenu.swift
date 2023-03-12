//
//  StatusMenuController.swift
//  UtilityTools
//
//  Created by BoogeyMan on 04/03/2023.
//

import Foundation
import SwiftUI

class ApplicationMenu: NSObject, NSMenuDelegate {
    static var menu = NSMenu()
    static var utilityToolsState: UtilityToolsState = UtilityToolsState()
    static let utilityToolsView = UtilityToolsView(utilityToolsState: ApplicationMenu.utilityToolsState)
    static let titleView = TitleView(utilityToolsState: ApplicationMenu.utilityToolsState)
    
    func createMenu() -> NSMenu {
        ApplicationMenu.menu.removeAllItems()
        
        let topView = NSHostingController(rootView: ApplicationMenu.utilityToolsView)
        topView.view.frame.size = CGSize(width: 225, height: ApplicationMenu.utilityToolsState.rows * 70)

        let customMenuItem: NSMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        
        let titleView = NSHostingController(rootView: ApplicationMenu.titleView)
        titleView.view.frame.size = CGSize(width: 225, height: 30)

        let titleMenuItem: NSMenuItem = NSMenuItem()
        titleMenuItem.view = titleView.view
        
        ApplicationMenu.menu.addItem(titleMenuItem)
        ApplicationMenu.menu.addItem(NSMenuItem.separator())
        ApplicationMenu.menu.addItem(customMenuItem)
        ApplicationMenu.menu.addItem(NSMenuItem.separator())
        ApplicationMenu.menu.addItem(createSettings())
        ApplicationMenu.menu.addItem(NSMenuItem.separator())
        ApplicationMenu.menu.addItem(createQuit())
        
        return ApplicationMenu.menu;
    }
    
    func startTimer() {
        ApplicationMenu.utilityToolsView.startTimer()
    }
    
    
    @objc
    func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    func createQuit() -> NSMenuItem {
        let quit = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quit.target = self
        
        return quit
    }
    
    
    
    @objc
    func settings() {
        ApplicationMenu.settingsWindow.makeKeyAndOrderFront(nil)
        ApplicationMenu.settingsWindow.orderFrontRegardless()
    }
    func createSettings() -> NSMenuItem {
        let settings = NSMenuItem(title: "Settings", action: #selector(settings), keyEquivalent: "")
        settings.target = self
        
        return settings
    }
    
    static var settingsWindow = NSWindow(contentRect: .init(origin: .zero, size: NSSize(width: 450, height: CGFloat(250 + ApplicationMenu.utilityToolsState.rows * 100))), styleMask: [.titled,.closable,.miniaturizable], backing: .buffered, defer: false)
    
    func buildSettingsWindow() {
        let hostingController = NSHostingController(rootView: SettingsView().frame(width: 450, height: CGFloat(250 + ApplicationMenu.utilityToolsState.rows * 100)))
        ApplicationMenu.settingsWindow = NSWindow(contentViewController: hostingController)
        ApplicationMenu.settingsWindow.title = "Settings"
        ApplicationMenu.settingsWindow.center()
    }
}
