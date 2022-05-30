//
//  ViewController.swift
//  Project_7
//
//  Created by Vinicius Emanuel on 22/07/21.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    var photos = [URL]()
    
    lazy var photosDirectory: URL = {
        let fm = FileManager.default
        var paths = fm.urls(for: .documentDirectory, in: .userDomainMask)
        var saveDirectory = paths[0]
        saveDirectory.appendPathComponent("SlideMark")
        
        if fm.fileExists(atPath: saveDirectory.path) == false {
            try? fm.createDirectory(at: saveDirectory, withIntermediateDirectories: true)
        }
        
        return saveDirectory
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.photos = self.loadPhotos()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func loadPhotos() -> [URL] {
        do {
            let fm = FileManager.default
            var files = try fm.contentsOfDirectory(at: self.photosDirectory, includingPropertiesForKeys: nil)
            files.removeAll(where: {$0.pathExtension != "jpg" && $0.pathExtension != "png"})
            
            return files
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    //MARK: - NSCollectionViewDelegate
    
    //MARK: - NSCollectionViewDataSource
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PhotoCell"), for: indexPath)
        guard let pictureItem = item as? PhotoCell else {
            return item
        }
        
        pictureItem.imageView?.image = NSImage(contentsOf: self.photos[indexPath.item])
        
        return pictureItem
    }
}

