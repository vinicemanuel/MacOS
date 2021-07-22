//
//  Photo.swift
//  Project_7
//
//  Created by Vinicius Emanuel on 22/07/21.
//

import Cocoa

class Photo: NSCollectionViewItem {
    private let selectedBorderThickness: CGFloat = 3
    
    override var isSelected: Bool {
        didSet {
            self.shouldHasBorder(isSelected)
        }
    }
    
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            self.shouldHasBorder(highlightState == .forSelection || isSelected)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.blue.cgColor
    }
    
    private func shouldHasBorder(_ isSelected: Bool) {
        view.layer?.borderWidth = 0
        
        if isSelected {
            view.layer?.borderWidth = selectedBorderThickness
        }
    }
    
}
