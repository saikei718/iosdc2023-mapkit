//
//  GeocodingViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/27.
//

import UIKit
import MapKit

class GeocodingViewController: UIViewController {
    private let geocoder = CLGeocoder()
    
    @IBOutlet private weak var addressField: UITextField!
    @IBOutlet private weak var locationField: UITextField!
    @IBOutlet private weak var addressDictionaryTextView: UITextView!
    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ジオコーディング"
    }

    @IBAction private func didTapGeocodingButton(_ sender: Any) {
        guard let address = self.addressField.text else {
            return
        }

        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first,
            let coordinate = placemark.location?.coordinate else {
                return
            }
            
            // debug
            print("===== placemarks: \(String(describing: placemarks))")
            
            // 取得した値の表示
            let coordinateText = "\(coordinate.latitude), \(coordinate.longitude)"
            self.locationField.text = coordinateText
            self.addressDictionaryTextView.text = """
            name: \(placemark.name ?? "nil")
            thoroughfare: \(placemark.thoroughfare ?? "nil")
            subThoroughfare: \(placemark.subThoroughfare ?? "nil")
            locality: \(placemark.locality ?? "nil")
            subLocality: \(placemark.subLocality ?? "nil")
            administrativeArea: \(placemark.administrativeArea ?? "nil")
            subAdministrativeArea: \(placemark.subAdministrativeArea ?? "nil")
            postalCode: \(placemark.postalCode ?? "nil")
            isoCountryCode: \(placemark.isoCountryCode ?? "nil")
            country: \(placemark.country ?? "nil")
            inlandWater: \(placemark.inlandWater ?? "nil")
            ocean: \(placemark.ocean ?? "nil")
            areasOfInterest: \(placemark.areasOfInterest?.compactMap { $0 }.joined(separator: ", ") ?? "nil")
            """
            
            // MapViewの操作
            /// 中心点の移動
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            self.mapView.setRegion(.init(center: center, span: span), animated: true)
            /// 該当緯度経度にピンを立てる
            let annotation = MKPointAnnotation()
            annotation.title = address
            annotation.subtitle = coordinateText
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.mapView.addAnnotation(annotation)
        }
    }
}
