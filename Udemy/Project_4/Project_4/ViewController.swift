//
//  ViewController.swift
//  Project_4
//
//  Created by Vinicius Emanuel on 08/07/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, NSGestureRecognizerDelegate, NSTouchBarDelegate, NSSharingServicePickerTouchBarItemDelegate {
    var rows: NSStackView!
    var selectedWebView: WKWebView!
    var AddressEntryDelegate: AddresEntryProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rows = NSStackView()
        self.rows.orientation = .vertical
        self.rows.distribution = .fillEqually
        self.rows.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rows)
        
        self.rows.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.rows.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.rows.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.rows.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        let column = NSStackView(views: [self.makeWebView()])
        column.distribution = .fillEqually
        
        rows.addArrangedSubview(column)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addRow() {
        let colunmCount = (rows.arrangedSubviews[0] as! NSStackView).arrangedSubviews.count
        let viewArray = (0..<colunmCount).map{ _ in makeWebView() }
        let row = NSStackView(views: viewArray)
        row.distribution = .fillEqually
        rows.addArrangedSubview(row)
    }
    
    func deleteRow() {
        guard rows.arrangedSubviews.count > 1 else { return }
        guard let rowToRemove = rows.arrangedSubviews.last as? NSStackView else { return }
        for cell in rowToRemove.arrangedSubviews {
            cell.removeFromSuperview()
        }
        
        rows.removeArrangedSubview(rowToRemove)
    }
    
    func addColunm() {
        for case let row as NSStackView in rows.arrangedSubviews {
            row.addArrangedSubview(self.makeWebView())
        }
    }
    
    func deleteColunm() {
        guard let firstRow = self.rows.arrangedSubviews.first as? NSStackView, firstRow.arrangedSubviews.count > 1 else {
            return
        }
        
        for case let row as NSStackView in self.rows.arrangedSubviews {
            if let last = row.arrangedSubviews.last {
                row.removeArrangedSubview(last)
                last.removeFromSuperview()
            }
        }
    }
    
    func openURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        guard let selected = self.selectedWebView else { return }
        selected.load(URLRequest(url: url))
    }
    
    func goBack() {
        guard let selected = self.selectedWebView else { return }
        selected.goBack()
    }
    
    func goFoward() {
        guard let selected = self.selectedWebView else { return }
        selected.goForward()
    }
    
    private func makeWebView() -> NSView {
    let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true
        webView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
        
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(webViewClicked(recognizer:)))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
        
        if self.selectedWebView == nil {
            self.select(webView: webView)
        }
        
        return webView
    }
    
    private func select(webView: WKWebView) {
        self.selectedWebView = webView
        self.selectedWebView.layer?.borderWidth = 4
        self.selectedWebView.layer?.borderColor = NSColor.blue.cgColor
        
        self.AddressEntryDelegate?.configAdress(adress: selectedWebView.url?.absoluteString ?? "")
    }
    
    @objc private func webViewClicked(recognizer: NSClickGestureRecognizer) {
        guard let newSelectedWebView = recognizer.view as? WKWebView else { return }
        
        if let selectedWebView = self.selectedWebView {
            selectedWebView.layer?.borderWidth = 0
        }
        
        self.select(webView: newSelectedWebView)
    }
    
    @objc func selectAddressEntry() {
        self.AddressEntryDelegate?.makeFirstResponder()
    }
    
    //MARK: - NSGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
        return gestureRecognizer.view != self.selectedWebView
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView != self.selectedWebView { return }
        
        self.AddressEntryDelegate?.configAdress(adress: webView.url?.absoluteString ?? "")
    }
    
    //MARK: - NSTouchBarDelegate
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        
        case .enterAdress:
            let button = NSButton(title: "Enter a URL", target: self, action: #selector(selectAddressEntry))
            button.setContentHuggingPriority(NSLayoutConstraint.Priority(10), for: .horizontal)
            
            let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
            customTouchBarItem.view = button
            return customTouchBarItem
            
        case .navigation:
            let back = NSImage(named: NSImage.touchBarGoBackTemplateName)!
            let fourward = NSImage(named: NSImage.touchBarGoForwardTemplateName)!
            let segmentedControl = NSSegmentedControl(images: [back, fourward], trackingMode: .momentary, target: (self.AddressEntryDelegate as! WindowController), action: #selector((self.AddressEntryDelegate as! WindowController).navigationClicked(_:)))
            
            let customBarItem = NSCustomTouchBarItem(identifier: identifier)
            customBarItem.view = segmentedControl
            return customBarItem
            
        case .sharingPicker:
            let picker = NSSharingServicePickerTouchBarItem(identifier: identifier)
            picker.delegate = self
            return picker
            
        case .adjustRows:
            let control = NSSegmentedControl(labels: ["Add Row", "Remove Row"], trackingMode: .momentary, target: (self.AddressEntryDelegate as! WindowController), action: #selector((self.AddressEntryDelegate as! WindowController).adjustRows(_:)))
            
            let customBarItem = NSCustomTouchBarItem(identifier: identifier)
            customBarItem.customizationLabel = "Rows"
            customBarItem.view = control
            return customBarItem
            
        case .adjustColumns:
            let control = NSSegmentedControl(labels: ["Add Column", "Remove Column"], trackingMode: .momentary, target: (self.AddressEntryDelegate as! WindowController), action: #selector((self.AddressEntryDelegate as! WindowController).adjustColumns(_:)))
            
            let customBarItem = NSCustomTouchBarItem(identifier: identifier)
            customBarItem.customizationLabel = "Column"
            customBarItem.view = control
            return customBarItem
            
        case .adjustGrid:
            let popover = NSPopoverTouchBarItem(identifier: identifier)
            popover.collapsedRepresentationLabel = "Grid"
            popover.customizationLabel = "Adjust Grid"
            popover.popoverTouchBar = NSTouchBar()
            popover.popoverTouchBar.delegate = self
            popover.popoverTouchBar.defaultItemIdentifiers = [.adjustColumns, .adjustRows]
            return popover
            
        default:
            return nil
        }
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        NSApp.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        
        let touchBar = NSTouchBar()
        touchBar.customizationIdentifier = "Personal.Project-4"
        touchBar.delegate = self
        
        touchBar.defaultItemIdentifiers = [.navigation, .adjustGrid, .enterAdress, .sharingPicker]
        touchBar.principalItemIdentifier = .enterAdress
        touchBar.customizationAllowedItemIdentifiers = [.sharingPicker, .adjustGrid, .adjustColumns, .adjustRows]
        touchBar.customizationRequiredItemIdentifiers = [.enterAdress]
        
        return touchBar
    }
    
    //MARK: - NSSharingServicePickerTouchBarItemDelegate
    func items(for pickerTouchBarItem: NSSharingServicePickerTouchBarItem) -> [Any] {
        guard let webView = self.selectedWebView else { return [] }
        guard let urlString = webView.url?.absoluteString else { return [] }
        return [urlString]
    }
}

