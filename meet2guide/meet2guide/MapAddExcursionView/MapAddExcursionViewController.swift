//
//  MapAddExcursionViewController.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 25.05.2022.
//
import UIKit
import PinLayout
import YandexMapsMobile
import CoreLocation
import MapKit

protocol MapAddExcursionView: AnyObject {
    func closeWindow()
}

class MapAddExcursionViewController: UIViewController {
    var output: MapAddExcursionPresenterProtocol?
    
    private let transition = PanelTransition()
    
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    
    private let mapView: YMKMapView = YMKMapView()
        
    let TARGET_LOCATION = YMKPoint(latitude: 59.945933, longitude: 30.320045)
    
    let locationManager = CLLocationManager()
    
    private var userLocationLayer: YMKUserLocationLayer!
    
    private var currentLocation: CLLocation?
    
    private let scale = UIScreen.main.scale
    
    private let currentLocationButton = UIButton()
    
    private let backButton = UIBarButtonItem()
    
    private var coords: YMKPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchBarButton))
        
        if let excursionCoords = coords {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: YMKPoint(latitude: excursionCoords.latitude ?? 59.945933, longitude: excursionCoords.longitude ?? 30.320045), zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.linear, duration: 1),
                cameraCallback: nil)
            let mapObjects = mapView.mapWindow.map.mapObjects
            //mapObjects.clear()
            let placemark = mapObjects.addPlacemark(with: excursionCoords)
            placemark.setIconWith(UIImage(systemName: "mappin")!)
        } else {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: YMKPoint(latitude: locationManager.location?.coordinate.latitude ?? 59.945933, longitude: locationManager.location?.coordinate.longitude ?? 30.320045), zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.linear, duration: 1),
                cameraCallback: nil)
        }
        
        
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true

        mapView.mapWindow.map.addInputListener(with: self)
        
        
        backButton.title = "назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.backgroundColor = .systemBackground
        currentLocationButton.addTarget(self, action: #selector(clickedCurrentLocationButton), for: .touchUpInside)
        currentLocationButton.layer.cornerRadius = 10
        currentLocationButton.clipsToBounds = true
        currentLocationButton.contentMode = .scaleAspectFit
        mapView.addSubview(currentLocationButton)
        
        view.addSubview(mapView)
    }
    
    func setCoords(coords: YMKPoint?) {
        self.coords = coords
    }
    
    @objc
    private func didTapSearchBarButton() {
        let searchController = UISearchController()
        //searchController.searchResultsUpdater = searchTable
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for places"
        //searchTable.mapView = mapView
        //searchTable.handleMapSearchDelegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.pin
            .all()
        currentLocationButton.pin
            .right(10)
            .bottom(view.safeAreaInsets.bottom + 10)
            .width(40)
            .height(40)
    }
    
    @objc
    private func clickedCurrentLocationButton() {
        guard let location = currentLocation else {
            return
        }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
    }
    
    func onSearchResponse(_ response: YMKSearchResponse) {
        let mapObjects = mapView.mapWindow.map.mapObjects
    }
    
    func popToRoot(sender:UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
        
    func onSearchError(_ error: Error) {
        let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if searchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if searchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
            
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
        present(alert, animated: true, completion: nil)
    }
}

extension MapAddExcursionViewController: MapAddExcursionView {
    func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MapAddExcursionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
}

extension MapAddExcursionViewController: UISearchBarDelegate {
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension MapAddExcursionViewController: YMKMapInputListener {
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        print("tap", point.latitude, point.longitude)
        
        let child = PlaceViewController()
        child.transitioningDelegate = transition
        child.modalPresentationStyle = .custom
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        location.fetchName { [weak self] name, error in
            child.config(name: name, coords: point, presenter: self?.output)
            self?.present(child, animated: true, completion: nil)
        }
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
    }
}

class PlaceViewController: UIViewController {
    private var output: MapAddExcursionPresenterProtocol?
    
    private var hideButton = UIButton()
    
    private var addressLabel: UILabel = UILabel()
    
    private var coordsLabel: UILabel = UILabel()
    
    private let doneButton: UIButton = UIButton()
    
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    
    private var coordsYMK: YMKPoint?
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapCloseBarButton))
        
        hideButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        hideButton.addTarget(self, action: #selector(didTapCloseBarButton), for: .touchUpInside)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        //addressLabel.text = "test address text"
        addressLabel.textColor = UIColor(named: "LabelColor")
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        
        //coordsLabel.text = "test"
        coordsLabel.textColor = UIColor(named: "LabelColor")
        coordsLabel.font = UIFont(name: "Montserrat-Regilar", size: 10)
        
        doneButton.backgroundColor = colorBlueCustom
        doneButton.setTitle("Выбрать", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font =  UIFont(name: "Montserrat-Regular", size: 16)
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        view.addSubview(hideButton)
        view.addSubview(addressLabel)
        view.addSubview(coordsLabel)
        view.addSubview(doneButton)
    }
    
    override func viewDidLayoutSubviews() {
        hideButton.pin
            .top(5)
            .hCenter()
            .sizeToFit()
        addressLabel.pin
            .top(40)
            .left(10)
            .width(view.frame.width - 20)
            .height(20)
        coordsLabel.pin
            .topLeft(to: addressLabel.anchor.bottomLeft)
            .marginTop(10)
            .sizeToFit()
        
        doneButton.pin
            .bottom(20)
            .right(20)
            .width(30%)
            .height(40)
    }
    
    @objc
    func didTapCloseBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didSwipe() {
        dismiss(animated: true, completion: nil)
    }
    
    func config(name: String?, coords: YMKPoint, presenter: MapAddExcursionPresenterProtocol?) {
        addressLabel.text = name
        coordsLabel.text = String(format: "%.3f %.3f", coords.latitude, coords.longitude)
        coordsYMK = coords
        output = presenter
    }
    
    @objc
    func didTapDoneButton() {
        output?.didTapDoneButton(address: addressLabel.text, coords: coordsYMK)
        dismiss(animated: true, completion: nil)
    }
}

class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}

class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let halfHeight = bounds.height / 4
        return CGRect(x: 0,
                      y: bounds.height - halfHeight,
                      width: bounds.width,
                      height: halfHeight)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        //containerView?.removeFromSuperview()
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.containerView?.removeFromSuperview()
        }
    }
}

class DimmPresentationController: PresentationController {
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.alpha = 0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(dimmView, at: 0)
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 1
        }
    }
    
    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }

        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmView.frame = containerView!.frame
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 1
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.dimmView.removeFromSuperview()
        }
    }
}


