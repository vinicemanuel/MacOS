//
//  DetailViewController.swift
//  Project_1
//
//  Created by Vinicius Emanuel on 19/06/20.
//  Copyright © 2020 Vinicius Emanuel. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func selectImage(name: String){
        self.imageView.image = NSImage(named: name)
    }
    
}
