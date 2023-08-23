//
//  PolygonDrawingViewController.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/28.
//

import UIKit
import MapKit

class PolygonDrawingViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "図形の描画"
        
        // POIを非表示にする
        let mapConfiguration = MKStandardMapConfiguration()
        mapConfiguration.pointOfInterestFilter = .excludingAll
        self.mapView.preferredConfiguration = mapConfiguration
        // 地図の操作を制限
//        self.mapView.isScrollEnabled = false  // 地図の移動の許可
        self.mapView.isRotateEnabled = false  // 地図の回転の許可
        self.mapView.isZoomEnabled = false    // 地図のズームの許可
        self.mapView.isPitchEnabled = false   // 地図の3D表示の許可

        setDefaultAnnotation()
        drawPolygons()
    }
    
    private func setDefaultAnnotation() {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: 35.70564, longitude: 139.70672)
        annotation.title = "現在地"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
    }
    
    private func drawPolygons() {
        // ステージ①（西早稲田キャンパス内）
        /// 図形の描画
        let coordinates1: [CLLocationCoordinate2D]  = [
            .init(latitude: 35.70620, longitude: 139.70713),
            .init(latitude: 35.70620, longitude: 139.70800),
            .init(latitude: 35.70580, longitude: 139.70800),
            .init(latitude: 35.70580, longitude: 139.70713)
        ]
        let polygon1 = MKPolygon(coordinates: coordinates1, count: coordinates1.count)
        mapView.addOverlay(polygon1)
        /// アノテーション（ラベル）の追加
        let coordinate1 = CLLocationCoordinate2D(latitude: 35.70598, longitude: 139.70757)
        let annotation1 = LabelAnnotationAnnotation()
        annotation1.title = "ステージ①"
        annotation1.coordinate = coordinate1
        mapView.addAnnotation(annotation1)
        
        // ステージ②（戸山公演内）
        /// 図形の描画
        let coordinates2: [CLLocationCoordinate2D]  = [
            .init(latitude: 35.70695, longitude: 139.70673),
            .init(latitude: 35.70695, longitude: 139.70749),
            .init(latitude: 35.70661, longitude: 139.70749),
            .init(latitude: 35.70661, longitude: 139.70673)
        ]
        let polygon2 = MKPolygon(coordinates: coordinates2, count: coordinates2.count)
        mapView.addOverlay(polygon2)
        /// アノテーション（ラベル）の追加
        let coordinate2 = CLLocationCoordinate2D(latitude: 35.70677, longitude: 139.70711)
        let annotation2 = LabelAnnotationAnnotation()
        annotation2.title = "ステージ②"
        annotation2.coordinate = coordinate2
        mapView.addAnnotation(annotation2)
        
        // 運営本部
        /// 図形の描画
        let coordinates3: [CLLocationCoordinate2D]  = [
            .init(latitude: 35.70654, longitude: 139.70569),
            .init(latitude: 35.70654, longitude: 139.70645),
            .init(latitude: 35.70552, longitude: 139.70645),
            .init(latitude: 35.70552, longitude: 139.70569)
        ]
        let polygon3 = MKPolygon(coordinates: coordinates3, count: coordinates3.count)
        mapView.addOverlay(polygon3)
        /// アノテーション（ラベル）の追加
        let coordinate3 = CLLocationCoordinate2D(latitude: 35.70605, longitude: 139.70605)
        let annotation3 = LabelAnnotationAnnotation()
        annotation3.title = "運営本部"
        annotation3.coordinate = coordinate3
        mapView.addAnnotation(annotation3)
    }

}

// MKMapViewDelegate
extension PolygonDrawingViewController: MKMapViewDelegate {
    // ポリゴン（図形）の描画設定はDelegate内で行う
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polygon = overlay as? MKPolygon else {
            return MKOverlayRenderer()
        }
        let polygonRenderer = MKPolygonRenderer(polygon: polygon)
        polygonRenderer.strokeColor = .systemRed
        polygonRenderer.lineWidth = 2.0
        polygonRenderer.fillColor = .green
        polygonRenderer.alpha = 0.5
        return polygonRenderer
    }
    
    // アノテーション（ピン）の描画設定はDelegateで行う
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case _ as LabelAnnotationAnnotation:
            let annotationView = LabelAnnotationView(
                annotation: annotation,
                reuseIdentifier: "identifier"
            )
            return annotationView
            
        default:
            return nil
        }
    }
}

// 地図上に表示するラベル用のアノテーション
class LabelAnnotationAnnotation: MKPointAnnotation { }
class LabelAnnotationView: MKAnnotationView {
    private let label: UILabel
    
    override var annotation: MKAnnotation? {
        didSet {
            if let title = annotation?.title {
                label.text = title
            } else {
                label.text = nil
            }
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        label = UILabel(frame: .zero)
        label.backgroundColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        isEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
