//
//  ViewController.swift
//  Project_4
//
//  Created by Vinicius Emanuel on 08/07/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate {
    
    var rows: NSStackView!

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
    
    func navigationClicked(){
        print("dale meu consagrado")
    }
    
    func adjustRows(){
        print("dale meu consagrado")
    }
    
    func adjustCols(){
        print("dale meu consagrado")
    }
    
    func urlEntered(){
        print("dale meu consagrado")
    }
    
    func makeWebView() -> NSView {
    let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true
        webView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
        
        return webView
    }
}

