//
//  ViewController.swift
//  Project_10
//
//  Created by vinicius emanuel on 02/06/22.
//

import Cocoa
import MapKit

class ViewController: NSViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var apiKey: NSTextField!
    @IBOutlet weak var statusBarOption: NSPopUpButton!
    @IBOutlet weak var units: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func showPoweredByDarkSky(_ sender: Any) {
        
    }
}

