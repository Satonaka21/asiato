//
//  map.swift
//  asiato
//
//  Created by 山北峻佑 on 2022/09/06.
//

import Foundation
import UIKit
import MapKit

class ViewController: UIViewController {

    fileprivate lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        [mapView.topAnchor.constraint(equalTo: view.topAnchor),
         mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),]
            .forEach { $0.isActive = true }

        setupMap()
    }

    fileprivate func setupMap() {
        // map center
        let lat = CLLocationDegrees(35.6809591)
        let long = CLLocationDegrees(139.7673068)
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        mapView.setCenter(loc ,animated:true)

        // map region
        var region: MKCoordinateRegion = mapView.region
        region.center = loc
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        mapView.setRegion(region,animated:true)
    }
}
