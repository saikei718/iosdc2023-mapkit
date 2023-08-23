//
//  Destination.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/26.
//

import Foundation

enum Destination: CaseIterable {
    case geocoding
    case reverseGeocoding
    case spotSearch
    case routeSearch
    case annotationCustomize
    case poiFiltering
    case poiInformation
    case polygonDrawing
    case lookAround
    
    var title: String {
        switch self {
        case .geocoding:            return "ジオコーディング"
        case .reverseGeocoding:     return "逆ジオコーディング"
        case .spotSearch:           return "スポット検索"
        case .routeSearch:          return "経路検索"
        case .annotationCustomize:  return "ピンのカスタマイズ"
        case .poiFiltering:         return "スポット（POI）フィルタリング"
        case .poiInformation:       return "スポット（POI）の情報取得"
        case .polygonDrawing:       return "図形の描画"
        case .lookAround:           return "Look Around"
        }
    }
    
    var detail: String {
        switch self {
        case .geocoding:            return "住所から緯度経度への変換"
        case .reverseGeocoding:     return "緯度経度から住所への変換"
        case .spotSearch:           return "スポット名での検索＆サジェスト"
        case .routeSearch:          return "A地点からB地点までの経路探索"
        case .annotationCustomize:  return "ピンのカスタマイズやクラスタリング"
        case .poiFiltering:         return "地図上のスポット（POI）のフィルタリング"
        case .poiInformation:       return "地図上のスポット（POI）の情報を取得"
        case .polygonDrawing:       return "マップ上への図形の描画"
        case .lookAround:           return ""
        }
    }
}
