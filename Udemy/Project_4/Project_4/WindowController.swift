//
//  WindowController.swift
//  Project_4
//
//  Created by Vinicius Emanuel on 09/07/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Cocoa

protocol AddresEntryProtocol {
    func configAdress(adress: String)
}

class WindowController: NSWindowController, AddresEntryProtocol {
    
    @IBOutlet weak var addressEntry: NSTextField!
    var vwController: ViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titleVisibility = .hidden
        
        self.vwController = self.window?.contentViewController as? ViewController
        self.vwController?.AddressEntryDelegate = self
    }
    
    @IBAction func navigationClicked(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            self.vwController?.goBack()
        } else {
            self.vwController?.goFoward()
        }
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
        self.vwController?.openURL(urlString: sender.stringValue)
    }
    
    func configAdress(adress: String) {
        self.addressEntry.stringValue = adress
    }
}
