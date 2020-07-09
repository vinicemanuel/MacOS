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
        self.vwController?.navigationClicked()
    }
    
    @IBAction func adjustRows(_ sender: NSSegmentedControl) {
        self.vwController?.adjustRows()
    }
    
    @IBAction func adjustCols(_ sender: NSSegmentedControl) {
        self.vwController?.adjustCols()
    }
    
    @IBAction func urlEntered(_ sender: NSTextField) {
        self.vwController?.urlEntered()
    }
}
