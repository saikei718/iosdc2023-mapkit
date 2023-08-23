//
//  AnnotationCustomizeViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/28.
//

import UIKit
import MapKit

class AnnotationCustomizeViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    private let centerCoordinate = CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70642)
    private let coordinates = [
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70602),
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70612),
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70622),
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70632),
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70652),
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70662),
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70672),
        CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70682)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultAnnotation()
    }

    private func setDefaultAnnotation() {
        let annotation = BlackAnnotation()
        annotation.coordinate = centerCoordinate
        annotation.title = "西早稲田キャンパス"
        mapView.addAnnotation(annotation)

        coordinates.enumerated().forEach { index, coordinate in
            let annotation = OrangeAnnotation()
            annotation.coordinate = coordinate
            annotation.content = "No.\(index)"
            mapView.addAnnotation(annotation)
        }

        let region = MKCoordinateRegion(
            center: centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        )
        mapView.setRegion(region, animated:true)
    }
}

// MKMapViewDelegate
extension AnnotationCustomizeViewController: MKMapViewDelegate {
    // アノテーション（ピン）の描画設定はDelegateで行う
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let orangeAnnotation as OrangeAnnotation:
            let annotationView = OrangeAnnotationCustomView(annotation: orangeAnnotation, reuseIdentifier: "orangeAnnotation")
            annotationView.clusteringIdentifier = "orangeAnnotation"
            if let content = orangeAnnotation.content {
                annotationView.setTitle(content)
            }
            return annotationView

        case _ as BlackAnnotation:
            let blackAnnotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                for: annotation
            ) as! MKMarkerAnnotationView
            blackAnnotationView.clusteringIdentifier = "blackAnnotation"
            blackAnnotationView.markerTintColor = .black
            return blackAnnotationView
            
        case _ as MKClusterAnnotation:
            let pinkAnnotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                for: annotation
            ) as! MKMarkerAnnotationView
            pinkAnnotationView.markerTintColor = .systemPink
            return pinkAnnotationView

        default:
            return nil
        }
    }
}

// MKPointAnnotation
class OrangeAnnotation: MKPointAnnotation {
    // アノテーション自体に情報を持たせる
    var content: String?
}
class BlackAnnotation: MKPointAnnotation {
    /* 必要なければ何も情報を持たせないことも可能 */
}
