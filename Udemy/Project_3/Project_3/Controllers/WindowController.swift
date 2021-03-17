//
//  WindowController.swift
//  Project_3
//
//  Created by Vinicius Emanuel on 17/03/21.
//  Copyright © 2021 Vinicius Emanuel. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet weak var shareButton: NSButton!
    @IBOutlet weak var alertButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.shareButton.sendAction(on: .leftMouseDown)
        self.alertButton.sendAction(on: .leftMouseDown)
    }

}
