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

    override func viewWillAppear() {
        super.viewWillAppear()
        generatePreview()
    }

    @IBAction func changeFontSize(_ sender: NSMenuItem) {
        self.generatePreview()
    }
    
    @IBAction func changeFontColor(_ sender: Any) {
        self.generatePreview()
    }
    
    @IBAction func changeBackGroundImage(_ sender: NSMenuItem) {
        self.generatePreview()
    }
    
    @IBAction func changeBackGroundColorStart(_ sender: Any) {
        self.generatePreview()
    }
    
    @IBAction func changeBackgroundColorEnd(_ sender: Any) {
        self.generatePreview()
    }
    
    @IBAction func changeDropShadowStrength(_ sender: Any) {
        self.generatePreview()
    }
    
    @IBAction func changeDropShadowTarget(_ sender: Any) {
        self.generatePreview()
    }
    
    @objc func changeFontName(_ sender: NSMenuItem) {
        self.generatePreview()
    }
    
    @IBAction func changeBackgroundImage(_ sender: Any) {
        self.generatePreview()
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
    
    func generatePreview() {
        let image = NSImage(size: CGSize(width: 1242, height: 2208), flipped: false) { [unowned self] rect in
            guard let ctx = NSGraphicsContext.current?.cgContext else { return false }
            
            self.clearBackground(context: ctx, rect: rect)
            self.drawBackgroundImage(rect: rect)
            self.drawColorOverlay(rect: rect)
            
            return true
        }

        imageView.image = image
    }
    
    func clearBackground(context: CGContext, rect: CGRect) {
        context.setFillColor(NSColor.white.cgColor)
        context.fill(rect)
    }
    
    func drawBackgroundImage(rect: CGRect) {
        // if they chose no background image, bail out
        if backgroundImage.selectedTag() == 999 { return }
        guard let title = backgroundImage.titleOfSelectedItem else { return }
        guard let image = NSImage(named: title) else { return }

        image.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1)
    }
    
    func drawColorOverlay(rect: CGRect) {
        let gradient = NSGradient(starting: backgroundColorStart.color, ending: backgroundColorEnd.color)
        gradient?.draw(in: rect, angle: -90)
    }

}
