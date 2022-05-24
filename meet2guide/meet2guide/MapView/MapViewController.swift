//
//  ViewController.swift
//  meet2guide
//
//  Created by user on 07.04.2022.
//

import UIKit
import PinLayout
import YandexMapsMobile
import CoreLocation

protocol MapView: AnyObject {
}

class MapViewController: UIViewController, MapView {
    var output: MapPresenterProtocol?
    
    private let mapView: YMKMapView = YMKMapView()
        
    let TARGET_LOCATION = YMKPoint(latitude: 59.945933, longitude: 30.320045)
    
    let locationManager = CLLocationManager()
    
    private var userLocationLayer: YMKUserLocationLayer!
    
    private var currentLocation: CLLocation?
    
    private let scale = UIScreen.main.scale
    
    private let currentLocationButton = UIButton()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true

        mapView.mapWindow.map.addCameraListener(with: self)
        
        
        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.backgroundColor = .clear
        currentLocationButton.addTarget(self, action: #selector(clickedCurrentLocationButton), for: .touchUpInside)
        mapView.addSubview(currentLocationButton)
        
        view.addSubview(mapView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.pin
            .all(0)
        currentLocationButton.pin
            .right(10)
            .bottom(view.safeAreaInsets.bottom + 10)
            .sizeToFit()
    }
    
    @objc
    private func clickedCurrentLocationButton() {
        guard let location = currentLocation else {
            return
        }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
}

extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        guard let location = currentLocation else {
            return
        }
        print(currentLocation)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
}

