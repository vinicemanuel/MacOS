//
//  AppDelegate.swift
//  Project_10
//
//  Created by vinicius emanuel on 02/06/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem.button?.title = "Fetching…"
        self.statusItem.menu = NSMenu()
        self.addConfigurationMenuItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func addConfigurationMenuItem() {
        let separator = NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: "")
        self.statusItem.menu?.addItem(separator)
    }
    
    @objc func showSettings(_ sender: NSMenuItem) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else { return }
        
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: self.statusItem.button!.bounds, of: self.statusItem.button!, preferredEdge: .maxY)
    }
}

