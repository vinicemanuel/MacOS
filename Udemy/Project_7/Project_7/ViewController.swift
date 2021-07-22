//
//  ViewController.swift
//  Project_7
//
//  Created by Vinicius Emanuel on 22/07/21.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //MARK: - NSCollectionViewDelegate
    
    //MARK: - NSCollectionViewDataSource
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Photo"), for: indexPath)
        guard let pictureItem = item as? Photo else {
            return item
        }
        
        pictureItem.view.wantsLayer = true
        pictureItem.view.layer?.backgroundColor = NSColor.red.cgColor
        
        return pictureItem
    }
}

