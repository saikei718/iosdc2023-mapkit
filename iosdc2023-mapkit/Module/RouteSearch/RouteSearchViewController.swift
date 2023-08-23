//
//  RouteSearchViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/08/23.
//

import UIKit
import MapKit

class RouteSearchViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet private weak var startLat: UITextField!
    @IBOutlet private weak var startLon: UITextField!
    @IBOutlet private weak var endLat: UITextField!
    @IBOutlet private weak var endLon: UITextField!
    
    @IBAction private func didTapRouteSearchButton(_ sender: Any) {
        searchRoute()
    }
    
    private func searchRoute() {
        guard let startLatString = startLat.text,
              let startLonString = startLon.text,
              let endLatString = endLat.text,
              let endLonString = endLon.text else {
            return
        }
        
        let startLat = NSString(string: startLatString).doubleValue
        let startLon = NSString(string: startLonString).doubleValue
        let endLat = NSString(string: endLatString).doubleValue
        let endLon = NSString(string: endLonString).doubleValue
        
        // 始点終点のアノテーション
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let startCoordinate = CLLocationCoordinate2D(latitude: startLat, longitude: startLon)
        let startAnnotation = MKPointAnnotation()
        startAnnotation.title = "始点"
        startAnnotation.coordinate = startCoordinate
        let endCoordinate = CLLocationCoordinate2D(latitude: endLat, longitude: endLon)
        let endAnnotation = MKPointAnnotation()
        endAnnotation.title = "終点"
        endAnnotation.coordinate = endCoordinate
        self.mapView.addAnnotations([startAnnotation, endAnnotation])
        
        // 経路探索
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .init(latitude: startLat, longitude: startLon) ))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: .init(latitude: endLat, longitude: endLon) ))
        request.transportType = .walking
        MKDirections(request: request).calculate { response, _ in
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coordinate = CLLocationCoordinate2D(latitude: 35.70588730, longitude: 139.70603490)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        self.mapView.setRegion(.init(center: coordinate, span: span), animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = "早稲田大学"
        annotation.subtitle = "西早稲田キャンパス"
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.addAnnotation(annotation)
    }
}

extension RouteSearchViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let route = overlay as? MKPolyline else { return MKOverlayRenderer() }
        
        let routeRenderer = MKPolylineRenderer(polyline: route)
        routeRenderer.strokeColor = .systemBlue
        routeRenderer.lineWidth = 5.0
        return routeRenderer
    }
}
