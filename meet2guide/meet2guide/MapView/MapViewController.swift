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
    func reloadData(with excursions: [ExcursionData])
    
    func openInfo(with excursion: ExcursionData)
}

class MapViewController: UIViewController {
    var output: MapPresenterProtocol?
    
    private let mapView: YMKMapView = YMKMapView()
        
    let TARGET_LOCATION = YMKPoint(latitude: 59.945933, longitude: 30.320045)
    
    let locationManager = CLLocationManager()
    
    private var userLocationLayer: YMKUserLocationLayer!
    
    private var currentLocation: CLLocation?
    
    private let scale = UIScreen.main.scale
    
    private let currentLocationButton = UIButton()
    
    private var listExcursions: [ExcursionData] = [ExcursionData]()
    
    private var dictionaryPoints: [YMKPlacemarkMapObject: ExcursionData] = [:]
    
    private let transition = ExcursionPanelTransition()
    
    private var flagLocation = false
    
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.getExcursions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: currentLocation?.coordinate.latitude ?? TARGET_LOCATION.latitude, longitude: currentLocation?.coordinate.longitude ?? TARGET_LOCATION.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
        
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true

        //mapView.mapWindow.map.addCameraListener(with: self)
        
        mapView.mapWindow.map.mapObjects.addTapListener(with: self)
        
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
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
    }
    
    private func setPoints() {
        var config = UIImage.SymbolConfiguration(paletteColors: [colorBlueCustom])
        for excursion in listExcursions {
            if let latitude = excursion.latitude, let longtitude = excursion.longtitude {
                let mapObjects = mapView.mapWindow.map.mapObjects
                let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: latitude, longitude: longtitude))
                let image = UIImage(systemName: "mappin.circle.fill", withConfiguration: config)
                placemark.setIconWith(image?.withTintColor(UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1), renderingMode: .alwaysOriginal) ?? UIImage())
                dictionaryPoints.updateValue(excursion, forKey: placemark)
            }
        }
    }
}

/*extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
    }
}*/

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        if !flagLocation {
            guard let location = currentLocation else {
                return
            }
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                cameraCallback: nil)
            flagLocation = true
        }
    }
}

extension MapViewController: MapView {
    func reloadData(with excursions: [ExcursionData]) {
        listExcursions = excursions
        setPoints()
    }
    
    func openInfo(with excursion: ExcursionData) {
        let child = ExcursionViewController()
        child.transitioningDelegate = transition
        child.modalPresentationStyle = .custom
        child.config(excursion: excursion, presenter: output)
        present(child, animated: true, completion: nil)
    }
}

extension MapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        print("tap")
        if let placemark = mapObject as? YMKPlacemarkMapObject {
            if let excursion = dictionaryPoints[placemark] {
                output?.openInfo(with: excursion)
            }
        }
        return true
    }
}


class ExcursionViewController: UIViewController {
    private var output: MapPresenterProtocol?
    
    private var hideButton = UIButton()

    
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    
    private let scrollView = UIScrollView()
    
    private let tourImageView = UIImageView()
    private var tourName: String? = "                              "
    private let formTitleLabel = UILabel()
    private let labelTourPlace = UILabel()
    private var tourPlaceTextView = UITextView()
    private var tourPlaceView = UIView()
    
    private let labelTourDate = UILabel()
    private var tourDateTextView = UITextView()
    private var tourDateView = UIView()
    
    private let labelTourDescription = UILabel()
    private var tourDescriptionTextView = UITextView()
    private var tourDescriptionView = UIView()
    
    private var excursion: ExcursionData?
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 400)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapCloseBarButton))
        
        hideButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        hideButton.tintColor = .white
        hideButton.addTarget(self, action: #selector(didTapCloseBarButton), for: .touchUpInside)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        tourImageView.backgroundColor = .systemGray
        tourImageView.alpha = 1
        tourImageView.contentMode = .scaleAspectFill
        tourImageView.clipsToBounds = true
        tourImageView.layer.cornerRadius = 20
        view.addSubview(tourImageView)
        
        let blurEffect = UIView()
        blurEffect.backgroundColor = .black
        blurEffect.alpha = 0.5
        blurEffect.frame = view.bounds
        blurEffect.clipsToBounds = true
        blurEffect.layer.cornerRadius = 20
        blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffect)
        //formTitleLabel.text = tourName
        formTitleLabel.textColor = .white
        formTitleLabel.font = UIFont(name: "Montserrat-Bold", size: 20)
        formTitleLabel.textAlignment = .center
        formTitleLabel.sizeToFit()
        formTitleLabel.alpha = 1
        formTitleLabel.numberOfLines = 0
        scrollView.addSubview(formTitleLabel)
        
        labelTourPlace.text = "Расположение"
        labelTourPlace.textColor = .white
        labelTourPlace.font = UIFont(name: "Montserrat-Bold", size: 13)
        labelTourPlace.textAlignment = .left
        //labelTourPlace.sizeToFit()
        labelTourPlace.alpha = 1
        labelTourPlace.numberOfLines = 2
        tourPlaceView.addSubview(labelTourPlace)
        
        tourPlaceTextView.font = UIFont(name: "Montserrat-Regular", size: 13)
        tourPlaceTextView.textAlignment = .right
        tourPlaceTextView.backgroundColor = .clear
        //tourPlaceTextView.text = labelTourPlace + ": " + textTourPlace
        tourPlaceTextView.textColor = .white
        tourPlaceTextView.isUserInteractionEnabled = false
        tourPlaceView.addSubview(tourPlaceTextView)
        scrollView.addSubview(tourPlaceView)
        
        labelTourDate.text = "Дата и время"
        labelTourDate.textColor = .white
        labelTourDate.font = UIFont(name: "Montserrat-Bold", size: 13)
        labelTourDate.textAlignment = .left
        //labelTourPlace.sizeToFit()
        labelTourDate.alpha = 1
        labelTourDate.numberOfLines = 2
        tourDateView.addSubview(labelTourDate)
        
        tourDateTextView.font = UIFont(name: "Montserrat-Regular", size: 13)
        tourDateTextView.textAlignment = .right
        tourDateTextView.backgroundColor = .clear
        //tourPlaceTextView.text = labelTourPlace + ": " + textTourPlace
        tourDateTextView.textColor = .white
        tourDateTextView.isUserInteractionEnabled = false
        tourDateView.addSubview(tourDateTextView)
        scrollView.addSubview(tourDateView)
        
        labelTourDescription.text = "Описание"
        labelTourDescription.textColor = .white
        labelTourDescription.font = UIFont(name: "Montserrat-Bold", size: 13)
        labelTourDescription.textAlignment = .left
        //labelTourPlace.sizeToFit()
        labelTourDescription.alpha = 1
        labelTourDescription.numberOfLines = 2
        tourDescriptionView.addSubview(labelTourDescription)
        
        tourDescriptionTextView.font = UIFont(name: "Montserrat-Regular", size: 13)
        tourDescriptionTextView.textAlignment = .right
        tourDescriptionTextView.backgroundColor = .clear
        //tourPlaceTextView.text = labelTourPlace + ": " + textTourPlace
        tourDescriptionTextView.textColor = .white
        tourDescriptionTextView.isUserInteractionEnabled = false
        tourDescriptionView.addSubview(tourDescriptionTextView)
        scrollView.addSubview(tourDescriptionView)
        
        formTitleLabel.alpha = 1
        
        view.addSubview(scrollView)

        view.addSubview(hideButton)
    }
    
    override func viewDidLayoutSubviews() {
        tourImageView.pin
            .all(0)
        
        hideButton.pin
            .top(5)
            .hCenter()
            .width(100%)
            .height(30)
        
        formTitleLabel.pin
            .topCenter(to: hideButton.anchor.bottomCenter)
            .margin(10)
            .width(view.frame.width - 40)
            .height(20)
        
        tourPlaceView.pin
            .topCenter(to: formTitleLabel.anchor.bottomCenter)
            .margin(20)
            .right()
            .left()
            .width(80%)
            .height(30)
        
        scrollView.pin
            .all(0)
        
        labelTourPlace.pin
            .top()
            .left(0)
            .height(tourPlaceTextView.frame.height)
            .width(tourPlaceTextView.frame.width)
        
        tourPlaceTextView.pin
            .top()
            .right(0)
            .sizeToFit()
        
        tourDateView.pin
            .topCenter(to: tourPlaceView.anchor.bottomCenter)
            .margin(20)
            .right()
            .left()
            .width(80%)
            .height(30)
        
        labelTourDate.pin
            .top()
            .left(0)
            .height(tourPlaceTextView.frame.height)
            .width(tourPlaceTextView.frame.width)
        
        tourDateTextView.pin
            .top()
            .right(0)
            .sizeToFit()
        
        tourDescriptionView.pin
            .topCenter(to: tourDateView.anchor.bottomCenter)
            .margin(20)
            .right()
            .left()
            .width(80%)
            .bottom(10)
        
        labelTourDescription.pin
            .top()
            .left(0)
            .height(tourPlaceTextView.frame.height)
            .width(tourPlaceTextView.frame.width)
        
        tourDescriptionTextView.pin
            .top()
            .right(0)
            .bottom()
            .width(60%)

    }
    
    @objc
    func didTapCloseBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didSwipe() {
        dismiss(animated: true, completion: nil)
    }
    
    func config(excursion: ExcursionData, presenter: MapPresenterProtocol?) {
        self.excursion = excursion
        formTitleLabel.text = excursion.name
        tourImageView.image = excursion.image
        tourPlaceTextView.text = excursion.address
        tourDateTextView.text = excursion.date
        tourDescriptionTextView.text = excursion.description
        output = presenter
    }
    
    @objc
    func didTapDoneButton() {
        //output?.didTapDoneButton(address: addressLabel.text, coords: coordsYMK)
        dismiss(animated: true, completion: nil)
    }
}

class ExcursionPanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ShadowPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}

class ExcursionPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let halfHeight = bounds.height / 2
        return CGRect(x: 0,
                      y: halfHeight,
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

class ShadowPresentationController: ExcursionPresentationController {
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

