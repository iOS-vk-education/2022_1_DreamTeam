//
//  ViewController.swift
//  meet2guide
//
//  Created by user on 07.04.2022.
//

import UIKit
import PinLayout
import YandexMapsMobile

class MapViewController: UIViewController {
    private let tabBar: UITabBar = UITabBar()
    private let mapTabBarItem: UITabBarItem = UITabBarItem()
    private let favoriteTabBarItem: UITabBarItem = UITabBarItem()
    private let accountTabBarItem: UITabBarItem = UITabBarItem()
    private let searchTabBarItem: UITabBarItem = UITabBarItem()
    private let mapView: YMKMapView = YMKMapView()
        
    let TARGET_LOCATION = YMKPoint(latitude: 59.945933, longitude: 30.320045)
        

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.backgroundColor = .gray
        
        mapTabBarItem.image = UIImage(systemName: "map")
        favoriteTabBarItem.image = UIImage(systemName: "star")
        accountTabBarItem.image = UIImage(systemName: "person")
        searchTabBarItem.image = UIImage(systemName: "list.bullet")
        
        mapTabBarItem.title = "карта"
        favoriteTabBarItem.title = "избранное"
        accountTabBarItem.title = "аккаунт"
        searchTabBarItem.title = "поиск"
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        mapView.mapWindow.map.logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .top))
                
        tabBar.setItems([mapTabBarItem, searchTabBarItem, favoriteTabBarItem, accountTabBarItem], animated: true)
        tabBar.selectedItem = mapTabBarItem
        
        view.addSubview(mapView)
        view.addSubview(tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.pin
            .all(0)
        
        tabBar.pin
            .bottom(view.safeAreaInsets.bottom)
            .left(0)
            .right(0)
            .height(30)
            .sizeToFit(.width)
    }
}

