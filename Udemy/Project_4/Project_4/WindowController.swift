//
//  WindowController.swift
//  Project_4
//
//  Created by Vinicius Emanuel on 09/07/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet weak var addresEntry: NSTextField!
    var vwController: ViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titleVisibility = .hidden
        
        self.vwController = self.window?.contentViewController as? ViewController
    }
    
    @IBAction func navigationClicked(_ sender: NSSegmentedControl) {
        
    }
    
    @IBAction func adjustRows(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            self.vwController?.addRow()
        } else {
            self.vwController?.deleteRow()
        }
    }
    
    @IBAction func adjustColumns(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            self.vwController?.addColunm()
        } else {
            self.vwController?.deleteColunm()
        }
    }
    
    @IBAction func urlEntered(_ sender: NSTextField) {
        
    }
}
