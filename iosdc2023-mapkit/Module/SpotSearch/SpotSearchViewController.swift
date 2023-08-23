//
//  SpotSearchViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/28.
//

import UIKit
import MapKit

protocol SpotSearchViewDelegate {
    func spotSearchView(
        _ spotSearchView: SpotSearchViewController,
        didSelectSpot spot: SpotModel
    )
}

struct SpotModel {
    let title: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
}

class SpotSearchViewController: UIViewController {
    var delegate: SpotSearchViewDelegate?
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    private var searchKeyword: String = "" {
        didSet {
            guard !searchKeyword.isEmpty else {
                searchCompleter.cancel()
                return
            }
            searchCompleter.queryFragment = searchKeyword
        }
    }
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        
        // スポット検索の基準となる地点を指定
        let coordinate = CLLocationCoordinate2D(latitude: 35.70588730, longitude: 139.70603490)
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        searchCompleter.region = MKCoordinateRegion(center: coordinate, span: span)
        
        return searchCompleter
    }()
    private var searchCompleterResults: [MKLocalSearchCompletion] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "フリーワード検索"
    }
}

extension SpotSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchCompleterResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = searchCompleterResults[indexPath.row].title
        cell.detailTextLabel?.text = searchCompleterResults[indexPath.row].subtitle
        return cell
    }
}

extension SpotSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchBar.text else {
            return
        }
        self.searchKeyword = searchKeyword
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchKeyword = searchText
    }
}

extension SpotSearchViewController: MKLocalSearchCompleterDelegate {
    // 正常に検索結果が更新されたとき
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchCompleterResults = completer.results
    }

    // 検索が失敗したとき
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let alertController = UIAlertController(
            title: "場所の検索に失敗しました",
            message: "時間をおいてもう一度お試しください。",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
