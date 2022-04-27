//
//  ViewController.swift
//  meet2guide
//
//  Created by user on 07.04.2022.
//

import UIKit
import PinLayout
import YandexMapsMobile

protocol MapView: AnyObject {
}

class MapViewController: UIViewController, MapView {
    var output: MapPresenterProtocol?
    
    private let mapView: YMKMapView = YMKMapView()
        
    let TARGET_LOCATION = YMKPoint(latitude: 59.945933, longitude: 30.320045)
        

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        mapView.mapWindow.map.logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .top))
                
        
        view.addSubview(mapView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.pin
            .all(0)
    }
}

