//
//  PoiFilteringViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/27.
//

import UIKit
import MapKit

class PoiFilteringViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var filteringStackView: UIStackView!
    @IBOutlet private weak var restaurantSwitch: UISwitch!
    @IBOutlet private weak var schoolSwitch: UISwitch!
    @IBOutlet private weak var parkSwitch: UISwitch!
    @IBOutlet private weak var parkingSwitch: UISwitch!
    @IBAction private func didUpdateSwitch(_ sender: Any) {
        updateMapViewFiltering()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "スポット（POI）フィルタリング"
        filteringStackView.isHidden = true
        setDefaultAnnotation()
    }

    private func setDefaultAnnotation() {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: 35.70588730, longitude: 139.70603490)
        annotation.title = "早稲田大学 西早稲田キャンパス"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
    }
    
    @IBAction private func didChangeSegmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 全て表示
            let mapConfiguration = MKStandardMapConfiguration()
            mapConfiguration.pointOfInterestFilter = .includingAll
            self.mapView.preferredConfiguration = mapConfiguration

            self.filteringStackView.isHidden = true
            
        case 1: // 全て非表示
            let mapConfiguration = MKStandardMapConfiguration()
            mapConfiguration.pointOfInterestFilter = .excludingAll
            self.mapView.preferredConfiguration = mapConfiguration

            self.filteringStackView.isHidden = true

        case 2: // フィルタリング
            self.filteringStackView.isHidden = false
            
            updateMapViewFiltering()

        default:
            fatalError("Invalid Index")
        }
    }
    
    private func updateMapViewFiltering() {
        var filteringCategories: [MKPointOfInterestCategory] = []
        if restaurantSwitch.isOn {
            filteringCategories.append(.restaurant)
        }
        if schoolSwitch.isOn {
            filteringCategories.append(.school)
        }
        if parkSwitch.isOn {
            filteringCategories.append(.park)
        }
        if parkingSwitch.isOn {
            filteringCategories.append(.parking)
        }
        let filter = MKPointOfInterestFilter(including: filteringCategories)
        
        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = filter
        self.mapView.preferredConfiguration = mapConfiguration
    }
}
