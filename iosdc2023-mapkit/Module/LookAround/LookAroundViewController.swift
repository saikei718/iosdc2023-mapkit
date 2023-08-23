//
//  LookAroundViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/08/23.
//

import UIKit
import CoreLocation
import MapKit

class LookAroundViewController: UIViewController {
    // スナップショットを表示するUIImageView
    @IBOutlet weak private var snapShotImageView: UIImageView!
    // 緯度経度の受け取り
    @IBOutlet weak private var inputLatitude: UITextField!
    @IBOutlet weak private var inputLongitude: UITextField!
    // 「取得」のタップイベント
    @IBAction private func didTapSearchLocationButton(_ sender: Any) {
        guard let latString = inputLatitude?.text,
              let lonString = inputLongitude?.text,
              let lat = CLLocationDegrees(latString),
              let lon = CLLocationDegrees(lonString) else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        searchLookAround(coordinate: coordinate)
    }
    // 「LookAroundViewControllerを開く」ボタン
    @IBOutlet weak private var openLookAroundViewButton: UIButton!
    @IBAction private func didTapOpenLookAroundViewButton(_ sender: Any) {
        guard let lookAroundViewController = lookAroundViewController else {
            return
        }
        present(lookAroundViewController, animated: true)
    }
    // 「LookAroundViewController」を保持する
    private var lookAroundViewController: MKLookAroundViewController? {
        didSet {
            openLookAroundViewButton.isEnabled = (lookAroundViewController != nil)
        }
    }
    
    private func searchLookAround(coordinate: CLLocationCoordinate2D) {
        let sceneRequest = MKLookAroundSceneRequest(coordinate: coordinate)
        sceneRequest.getSceneWithCompletionHandler { scene, error in
            guard error == nil, let scene = scene else {
                self.setNotFound()
                return
            }
            
            // スナップショットを作成
            let snapshotter = MKLookAroundSnapshotter(scene: scene, options: .init())
            snapshotter.getSnapshotWithCompletionHandler{ snapshot, error in
                guard let snapshotImage = snapshot?.image else {
                    self.setNotFound()
                    return
                }
                // スナップショットをUIImageViewにセット
                self.snapShotImageView.image = snapshotImage
                // 「LookAroundViewControlelrを開く」ボタンを活性化
                self.openLookAroundViewButton.isEnabled = true
                // 「lookAroundViewController」プロパティにセット
                self.lookAroundViewController = MKLookAroundViewController(scene: scene)
                self.lookAroundViewController?.isNavigationEnabled = false
            }
        }
    }
    
    private func setNotFound() {
        // NoImage画像をUIImageViewにセット
        self.snapShotImageView.image = UIImage(systemName: "mappin.slash.circle.fill")
        // 「LookAroundViewControlelrを開く」ボタンを無効化
        self.openLookAroundViewButton.isEnabled = false
        // 「lookAroundViewController」プロパティをnilにする
        self.lookAroundViewController = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
