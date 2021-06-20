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
    func makeFirstResponder()
}

protocol ReloadButtonProtocol {
    func loading(isLoading: Bool)
}

protocol NavigationButtonProtocol {
    func setGoBack(canGoBack: Bool)
    func setGoFoward(canGoFoward: Bool)
}

class WindowController: NSWindowController, AddresEntryProtocol, ReloadButtonProtocol, NavigationButtonProtocol {
    @IBOutlet weak var reloadButton: NSButton!
    @IBOutlet weak var addressEntry: NSTextField!
    @IBOutlet weak var navigationSegment: NSSegmentedControl!
    
    var vwController: ViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titleVisibility = .hidden
        
        self.vwController = self.window?.contentViewController as? ViewController
        self.vwController?.addressEntryDelegate = self
        self.vwController?.loadingButtonDelegate = self
        self.vwController?.navigationButtonDelegate = self
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
    
    override func cancelOperation(_ sender: Any?) {
        self.window?.makeFirstResponder(self.vwController)
    }

    @IBAction func reload(_ sender: NSButton) {
        self.vwController?.reload()
    }
    
    //MARK: - AddresEntryProtocol
    func configAdress(adress: String) {
        self.addressEntry.stringValue = adress
    }
    
    func makeFirstResponder() {
        self.window?.makeFirstResponder(self.addressEntry)
    }
    
    //MARK: - ReloadButtonProtocol
    func loading(isLoading: Bool) {
        if isLoading {
            self.reloadButton.image = NSImage(named: "NSStopProgressTemplate")
        } else {
            self.reloadButton.image = NSImage(named: "NSRefreshTemplate")
        }
    }
    
    //MARK: - NavigationButtonsProtocol
    func setGoBack(canGoBack: Bool) {
        self.navigationSegment.setEnabled(canGoBack, forSegment: 0)
    }
    
    func setGoFoward(canGoFoward: Bool) {
        self.navigationSegment.setEnabled(canGoFoward, forSegment: 1)
    }
}
