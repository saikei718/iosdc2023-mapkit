//
//  PoiInformationViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/08/28.
//

import UIKit
import MapKit

class PoiInformationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            
            // タップ可能なPOI要素を指定（未指定の場合はデフォルトでタップ判定されない）
            mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filter = MKPointOfInterestFilter(including: [.cafe, .restaurant])
        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = filter
        self.mapView.preferredConfiguration = mapConfiguration
        
        setDefaultAnnotation()
    }
    
    private func setDefaultAnnotation() {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: 35.70588730, longitude: 139.70603490)
//        annotation.title = "早稲田大学 西早稲田キャンパス"
//        annotation.coordinate = coordinate
//        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
    }

}

extension PoiInformationViewController: MKMapViewDelegate {
    // タップイベントは通常のアノテーションと同様 `MKMapViewDelegate` で受け取る
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let featureAnnotation = annotation as? MKMapFeatureAnnotation else { return }
        let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
        Task {
            let featureMapItem: MKMapItem = try await featureRequest.mapItem
            self.nameLabel.text = featureMapItem.name ?? "情報なし"                  // => ex. 早稲田大学 西早稲田キャンパス
            self.telLabel.text = featureMapItem.phoneNumber ?? "情報なし"            // => ex. +81 3 3203 4333
            self.urlLabel.text = featureMapItem.url?.absoluteString ?? "情報なし"    // => ex. https://www.waseda.jp/top/
        }
    }
}
