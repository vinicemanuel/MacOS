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
        
        self.loadFonts()
        self.loadBackgroundImages()
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
    
    @objc func changeFontName(_ sender: NSMenuItem) {
        
    }
    
    @IBAction func changeBackgroundImage(_ sender: Any) {
        
    }
    
    func loadFonts() {
        guard let fontFile = Bundle.main.url(forResource: "fonts", withExtension: nil) else { return }
        guard let fonts = try? String(contentsOf: fontFile) else { return }
        let fontNames = fonts.components(separatedBy: "\n")

        for font in fontNames {
            if font.hasPrefix(" ") {
                let item = NSMenuItem(title: font, action: #selector(changeFontName), keyEquivalent: "")
                item.target = self
                fontName.menu?.addItem(item)
            } else {
                let item = NSMenuItem(title: font, action: nil, keyEquivalent: "")
                item.target = self
                item.isEnabled = false
                fontName.menu?.addItem(item)
            }
        }
    }
    
    func loadBackgroundImages() {
        let allImages = ["Antique Wood", "Autumn Leaves", "Autumn Sunset", "Autumn by the Lake", "Beach and Palm Tree", "Blue Skies", "Bokeh (Blue)", "Bokeh (Golden)", "Bokeh (Green)", "Bokeh (Orange)", "Bokeh (Rainbow)", "Bokeh (White)", "Burning Fire", "Cherry Blossom", "Coffee Beans", "Cracked Earth", "Geometric Pattern 1", "Geometric Pattern 2", "Geometric Pattern 3", "Geometric Pattern 4", "Grass", "Halloween", "In the Forest", "Jute Pattern", "Polka Dots (Purple)", "Polka Dots (Teal)", "Red Bricks", "Red Hearts", "Red Rose", "Sandy Beach", "Sheet Music", "Snowy Mountain", "Spruce Tree Needles", "Summer Fruits", "Swimming Pool", "Tree Silhouette", "Tulip Field", "Vintage Floral", "Zebra Stripes"]

        for image in allImages {
            let item = NSMenuItem(title: image, action: #selector(changeBackgroundImage), keyEquivalent: "")
            item.target = self

            backgroundImage.menu?.addItem(item)
        }
    }
}
