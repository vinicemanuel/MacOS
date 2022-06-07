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
    
    var screenshotImage: NSImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.caption.delegate = self
        
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(importScreenshot))
        imageView.addGestureRecognizer(recognizer)
        
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
    
    @objc func importScreenshot() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["jpg", "png"]

        panel.begin { [unowned self] result in
            if result == .OK {
                guard let imageURL = panel.url else { return }
                self.screenshotImage = NSImage(contentsOf: imageURL)
                self.generatePreview()
            }
        }
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
            let captionOffset = self.drawCaption(rect: rect)
            self.drawDevice(rect: rect, captionOffset: captionOffset)
            self.drawScreenshot(rect: rect, captionOffset: captionOffset)
            
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
    
    func drawCaption(rect: CGRect) -> CGFloat {
        if dropShadowStrength.selectedSegment != 0 {
            if dropShadowTarget.selectedSegment == 0 || dropShadowTarget.selectedSegment == 2 {
                setShadow()
            }
        }

        let string = caption.textStorage?.string ?? ""
        let insetRect = rect.insetBy(dx: 40, dy: 20)

        let captionAttributes = createCaptionAttributes()
        let attributedString = NSAttributedString(string: string, attributes: captionAttributes)
        attributedString.draw(in: insetRect)

        //draw again if the shadow is sttrong to make the shadow deeper (work around)
        if dropShadowStrength.selectedSegment == 2 {
            if dropShadowTarget.selectedSegment == 0 || dropShadowTarget.selectedSegment == 2 {
                // create a stronger drop shadow by drawing again
                attributedString.draw(in: insetRect)
            }
        }

        // clear the shadow so it doesn't affect other stuff
        let noShadow = NSShadow()
        noShadow.set()

        let availableSpace = CGSize(width: insetRect.width, height: CGFloat.greatestFiniteMagnitude)
        let textFrame = attributedString.boundingRect(with: availableSpace, options: [.usesLineFragmentOrigin, .usesFontLeading])
        return textFrame.height
    }
    
    func createCaptionAttributes() -> [NSAttributedString.Key: Any]? {
        let ps = NSMutableParagraphStyle()
        ps.alignment = .center

        let fontSizes: [Int: CGFloat] = [0: 48, 1: 56, 2: 64, 3: 72, 4: 80, 5: 96, 6: 128]
        guard let baseFontSize = fontSizes[fontSize.selectedTag()] else { return nil }

        let selectedFontName = fontName.selectedItem?.title.trimmingCharacters(in: .whitespacesAndNewlines) ?? "HelveticaNeue-Medium"
        guard let font = NSFont(name: selectedFontName, size: baseFontSize) else { return nil }
        let color = fountColor.color

        return [NSAttributedString.Key.paragraphStyle: ps, NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
    }
    
    func setShadow() {
        //enable during all drawing operation
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize.zero
        shadow.shadowColor = NSColor.black
        shadow.shadowBlurRadius = 50
        shadow.set()
    }
    
    func drawDevice(rect: CGRect, captionOffset: CGFloat) {
        guard let image = NSImage(named: "iPhone") else { return }

        let offsetX = (rect.size.width - image.size.width) / 2
        var offsetY = (rect.size.height - image.size.height) / 2
        offsetY -= captionOffset

        if dropShadowStrength.selectedSegment != 0 {
            if dropShadowTarget.selectedSegment == 1 || dropShadowTarget.selectedSegment == 2 {
                setShadow()
            }
        }

        image.draw(at: CGPoint(x: offsetX, y: offsetY), from: .zero, operation: .sourceOver, fraction: 1)

        if dropShadowStrength.selectedSegment == 2 {
            if dropShadowTarget.selectedSegment == 1 || dropShadowTarget.selectedSegment == 2 {
                // create a stronger drop shadow by drawing again
                image.draw(at: CGPoint(x: offsetX, y: offsetY), from: .zero, operation: .sourceOver, fraction: 1)
            }
        }

        // clear the shadow so it doesn't affect other stuff
        let noShadow = NSShadow()
        noShadow.set()
    }
    
    func drawScreenshot(rect: CGRect, captionOffset: CGFloat) {
        guard let screenshot = screenshotImage else { return }
        screenshot.size = CGSize(width: 891, height: 1584)

        let offsetY = 314 - captionOffset
        screenshot.draw(at: CGPoint(x: 176, y: offsetY), from: .zero, operation: .sourceOver, fraction: 1)
    }
    
    //MARK: - NSTextViewDelegate
    func textDidChange(_ notification: Notification) {
        self.generatePreview()
    }
}
