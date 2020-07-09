//
//  PhotoCell.swift
//  Project_1
//
//  Created by Vinicius Emanuel on 22/06/20.
//  Copyright © 2020 Vinicius Emanuel. All rights reserved.
//

import Cocoa

class PhotoCell: NSTableCellView {
    
    @IBOutlet weak var imgTitle: NSTextField!
    @IBOutlet weak var img: NSImageView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
