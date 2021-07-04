//
//  ViewController.swift
//  Project_5
//
//  Created by Vinicius Emanuel on 04/07/21.
//

import Cocoa
import MapKit

class ViewController: NSViewController {

    @IBOutlet weak var questionLabel: NSTextField!
    @IBOutlet weak var scroteLabel: NSTextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(self.mouseClicked(recoognizer:)))
        self.mapView.addGestureRecognizer(recognizer)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addPin(at coord: CLLocationCoordinate2D) {
        let guess = Pin(title: "Your guess", coordinate: coord, color: .red)
        mapView.addAnnotation(guess)
    }
    
    @objc func mouseClicked(recoognizer: NSClickGestureRecognizer) {
        let location = recoognizer.location(in: self.mapView)
        let coordinates = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        self.addPin(at: coordinates)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "guess"
        
        guard let pin = annotation as? Pin else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        annotationView?.pinTintColor = pin.color
        
        return annotationView
    }
}
