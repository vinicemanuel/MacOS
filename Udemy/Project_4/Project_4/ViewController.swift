//
//  ViewController.swift
//  Project_4
//
//  Created by Vinicius Emanuel on 08/07/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, NSGestureRecognizerDelegate {
    
    var rows: NSStackView!
    var selectedWebView: WKWebView!

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
    
    private func makeWebView() -> NSView {
    let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true
        webView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
        
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(webViewClicked(recognizer:)))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
        
        return webView
    }
    
    private func select(webView: WKWebView) {
        self.selectedWebView = webView
        self.selectedWebView.layer?.borderWidth = 4
        self.selectedWebView.layer?.borderColor = NSColor.blue.cgColor
    }
    
    @objc private func webViewClicked(recognizer: NSClickGestureRecognizer) {
        guard let newSelectedWebView = recognizer.view as? WKWebView else { return }
        
        if let selectedWebView = self.selectedWebView {
            selectedWebView.layer?.borderWidth = 0
        }
        
        self.select(webView: newSelectedWebView)
    }
    
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
        return gestureRecognizer.view != self.selectedWebView
    }
}

