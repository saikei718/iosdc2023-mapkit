//
//  OrangeAnnotationCustomView.swift
//  iosdc2023-mapkit
//
//  Created by saikei on 2023/06/27.
//

import UIKit
import MapKit

class OrangeAnnotationCustomView: MKAnnotationView {

    @IBOutlet private weak var label: UILabel!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadFromNib()
    }
    
    private func loadFromNib() {
        guard let view = Bundle.main.loadNibNamed("OrangeAnnotationCustomView", owner: self, options: nil)?.first as? UIView else  {
            return
        }
        view.frame = bounds
        addSubview(view)
    }
    
    func setTitle(_ title: String) {
        self.label.text = title
    }
}
