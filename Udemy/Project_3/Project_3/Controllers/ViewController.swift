//
//  ViewController.swift
//  Project_3
//
//  Created by Vinicius Emanuel on 05/07/20.
//  Copyright © 2020 Vinicius Emanuel. All rights reserved.
//

import Cocoa

class ViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBAction func sharedClicked(_ sender: NSView){
        guard let detail  = children[1] as? DetailViewController, let image = detail.imageView.image else {
            return
        }
        
        let picker = NSSharingServicePicker(items: [image])
        picker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
    }
}
