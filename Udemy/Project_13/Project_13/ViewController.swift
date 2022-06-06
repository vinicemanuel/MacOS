//
//  ViewController.swift
//  Project_13
//
//  Created by vinicius emanuel on 06/06/22.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet var caption: NSTextView!
    @IBOutlet weak var fontName: NSPopUpButton!
    @IBOutlet weak var fontSize: NSPopUpButton!
    @IBOutlet weak var fountColor: NSColorWell!
    @IBOutlet weak var backgroundImage: NSPopUpButton!
    @IBOutlet weak var backgroundColorStart: NSColorWell!
    @IBOutlet weak var backgroundColorEnd: NSColorWell!
    @IBOutlet weak var dropShadowStrength: NSSegmentedControl!
    @IBOutlet weak var dropShadowTarget: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.caption.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func changeFontSize(_ sender: NSMenuItem) {
        
    }
    
    @IBAction func changeFontColor(_ sender: Any) {
        
    }
    
    @IBAction func changeBackGroundImage(_ sender: NSMenuItem) {
        
    }
    
    @IBAction func changeBackGroundColorStart(_ sender: Any) {
        
    }
    
    @IBAction func changeBackgroundColorEnd(_ sender: Any) {
        
    }
    
    @IBAction func changeDropShadowStrength(_ sender: Any) {
        
    }
    
    @IBAction func changeDropShadowTarget(_ sender: Any) {
        
    }
}
