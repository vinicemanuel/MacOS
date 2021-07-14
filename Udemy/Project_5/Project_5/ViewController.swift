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
    
    var cities = [Pin]()
    var currentCity: Pin?
    
    var score = 0 {
        didSet {
            self.scroteLabel.stringValue = "Score: \(self.score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(self.mapClicked(recoognizer:)))
        self.mapView.addGestureRecognizer(recognizer)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.startNewGame()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addPin(at coord: CLLocationCoordinate2D) {
        guard let actual = self.currentCity else {
            return
        }
        
        let guess = Pin(title: "Your guess", coordinate: coord, color: .red)
        mapView.addAnnotations([guess, actual])
        
        let point1 = MKMapPoint(guess.coordinate)
        let point2 = MKMapPoint(actual.coordinate)
        
        let distance = Int(max(0,500 - point1.distance(to: point2) / 1000))
        self.score += distance
        actual.subtitle = "you scored \(distance)"
        self.mapView.selectAnnotation(actual, animated: true)
    }
    
    @objc func mapClicked(recoognizer: NSClickGestureRecognizer) {
        if self.mapView.annotations.count == 0 {
            self.addPin(at: self.mapView.convert(recoognizer.location(in: self.mapView), toCoordinateFrom: self.mapView))
        } else {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.nexCity()
        }
    }
    
    func startNewGame() {
        self.cities.append(Pin(title: "Surubim", coordinate: CLLocationCoordinate2D(latitude: -7.8441854275076714, longitude: -35.762170820107784)))
        self.cities.append(Pin(title: "recife", coordinate: CLLocationCoordinate2D(latitude: -8.056785046843226, longitude: -34.87107520882832)))
        self.score = 0
        self.nexCity()
    }
    
    func nexCity() {
        if let city = self.cities.popLast() {
            self.currentCity = city
            questionLabel.stringValue = "where is \(city.title ?? "")"
        } else {
            self.currentCity = nil
            let alert = NSAlert()
            alert.messageText = "final score: \(self.score)"
            alert.runModal()
            
            self.startNewGame()
        }
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
