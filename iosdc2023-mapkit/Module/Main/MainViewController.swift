//
//  MainViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/26.
//

import UIKit

class MainViewController: UITableViewController {
    let destinations: [Destination] = Destination.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ホーム"
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = destinations[indexPath.row].title
        cell.detailTextLabel?.text = destinations[indexPath.row].detail
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = destinations[indexPath.row]
        
        switch destination {
        case .geocoding:
            self.navigationController?.pushViewController(GeocodingViewController(), animated: true)
        case .reverseGeocoding:
            self.navigationController?.pushViewController(ReverseGeocodingViewController(), animated: true)
        case .spotSearch:
            self.navigationController?.pushViewController(SpotSearchViewController(), animated: true)
        case .routeSearch:
            self.navigationController?.pushViewController(RouteSearchViewController(), animated: true)
        case .annotationCustomize:
            self.navigationController?.pushViewController(AnnotationCustomizeViewController(), animated: true)
        case .poiFiltering:
            self.navigationController?.pushViewController(PoiFilteringViewController(), animated: true)
        case .poiInformation:
            self.navigationController?.pushViewController(PoiInformationViewController(), animated: true)
        case .polygonDrawing:
            self.navigationController?.pushViewController(PolygonDrawingViewController(), animated: true)
        case .lookAround:
            self.navigationController?.pushViewController(LookAroundViewController(), animated: true)
        }
    }
}
