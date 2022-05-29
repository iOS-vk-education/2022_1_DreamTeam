//
//  MapShowExcursionViewController.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 28.05.2022.
//

import UIKit
import PinLayout
import YandexMapsMobile
import CoreLocation

protocol MapShowExcursionView: AnyObject {
}

class MapShowExcursionViewController: UIViewController, MapShowExcursionView {
    var output: MapShowExcursionPresenterProtocol?
    
    private let mapView: YMKMapView = YMKMapView()
        
    let TARGET_LOCATION = YMKPoint(latitude: 59.945933, longitude: 30.320045)
    
    let locationManager = CLLocationManager()
    
    private var userLocationLayer: YMKUserLocationLayer!
    
    private var currentLocation: CLLocation?
    
    private let scale = UIScreen.main.scale
    
    private let currentLocationButton = UIButton()
    
    private var excursionPoint: YMKPoint?
        

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
        if let excursionPoint = excursionPoint {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: excursionPoint, zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.linear, duration: 1),
                cameraCallback: nil)
            let mapObjects = mapView.mapWindow.map.mapObjects
            //mapObjects.clear()
            let placemark = mapObjects.addPlacemark(with: excursionPoint)
            placemark.setIconWith(UIImage(systemName: "mappin.circle.fill")!)
        } else {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
                cameraCallback: nil)
        }
        
        
        
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true

        //mapView.mapWindow.map.addCameraListener(with: self)
        
        
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
    
    func setPoint(with point: YMKPoint) {
        excursionPoint = point
    }
}

/*extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
    }
}*/

extension MapShowExcursionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        guard let location = currentLocation else {
            return
        }
        print(currentLocation)
        /*mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)*/
    }
}
