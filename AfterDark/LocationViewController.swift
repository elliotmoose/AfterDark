//
//  LocationViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit
import GoogleMaps
class LocationViewController: UIViewController ,CLLocationManagerDelegate,GMSMapViewDelegate{

    //static let singleton = LocationViewController()
    var mapView : GMSMapView?
    let marker = GMSMarker()
    
    var focusLocationButton : UIButton?
    var focusBarButton : UIButton?
    var openGoogleMapsButton : UIButton?
    var zoomOutButton : UIButton?
    
    
    let targetImage = #imageLiteral(resourceName: "target1x")
    let compassImage = #imageLiteral(resourceName: "compass-1")
    let forwardArrowImage = #imageLiteral(resourceName: "Forward Arrow-104").newImageWithSize(CGSize(width: 25, height: 25))
    let pointObjectImage = #imageLiteral(resourceName: "PointObjects").newImageWithSize(CGSize(width: 25, height: 25))
    
    var locationManager : CLLocationManager?
    var mapBehaviourMode = 0
    
    var highlightedBar : Bar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //map init
        GMSServices.provideAPIKey(Settings.googleServicesKey)
        
        var loc_lat : Double = 0
        var loc_long : Double = 0
        
        if highlightedBar != nil
        {
            loc_lat = CLLocationDegrees(highlightedBar!.loc_lat)
            loc_long = CLLocationDegrees(highlightedBar!.loc_long)
        }

        let camera = GMSCameraPosition.camera(withLatitude: loc_lat, longitude: loc_long, zoom: 17)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = self
        view = mapView
        
        marker.map = mapView
        
        
        //focusLocationButton
        let targetWidth : CGFloat = 45
        focusLocationButton = UIButton(frame: CGRect(x: Sizing.ScreenWidth() - 20 - targetWidth, y: 20, width: targetWidth, height: targetWidth))

            //set up button image
        focusLocationButton?.imageView?.contentMode = .scaleAspectFit
        focusLocationButton?.setImage(targetImage.withRenderingMode(.alwaysTemplate), for: .normal)
        focusLocationButton?.tintColor = ColorManager.deselectedIconColor
        focusLocationButton?.backgroundColor = UIColor.white
        focusLocationButton?.layer.cornerRadius = targetWidth/2
        focusLocationButton?.addTarget(self, action: #selector(ToggleMapBehaviour), for: .touchDown)
        view.addSubview(focusLocationButton!)
            //shadow
        focusLocationButton?.clipsToBounds = false
        focusLocationButton?.layer.shadowOpacity = 0.3
        focusLocationButton?.layer.shadowOffset = CGSize(width: 0, height: 0)
        focusLocationButton?.layer.shadowRadius = 10
        
        //openGoogleMapsButton
        openGoogleMapsButton = UIButton(frame : CGRect(x: Sizing.ScreenWidth() - 20 - targetWidth, y: 40 + targetWidth, width: targetWidth, height: targetWidth))
        openGoogleMapsButton?.imageView?.contentMode = .scaleAspectFit
        openGoogleMapsButton?.setImage(forwardArrowImage.withRenderingMode(.alwaysTemplate), for: .normal)
        openGoogleMapsButton?.tintColor = ColorManager.selectedIconColor
        openGoogleMapsButton?.backgroundColor = UIColor.white
        openGoogleMapsButton?.layer.cornerRadius = targetWidth/2
        openGoogleMapsButton?.addTarget(self, action: #selector(OpenGoogleMaps), for: .touchDown)
        view.addSubview(openGoogleMapsButton!)

            //shadow
        openGoogleMapsButton?.clipsToBounds = false
        openGoogleMapsButton?.layer.shadowOpacity = 0.3
        openGoogleMapsButton?.layer.shadowOffset = CGSize(width: 0, height: 0)
        openGoogleMapsButton?.layer.shadowRadius = 10
        
//        //zoomOutButton
//        zoomOutButton = UIButton(frame: CGRect(x: 20, y: 40 + targetWidth, width: targetWidth, height: targetWidth))
//        zoomOutButton?.imageView?.contentMode = .scaleAspectFit
//        zoomOutButton?.setImage(pointObjectImage.withRenderingMode(.alwaysTemplate), for: .normal)
//        zoomOutButton?.tintColor = ColorManager.selectedIconColor
//        zoomOutButton?.backgroundColor = UIColor.white
//        zoomOutButton?.layer.cornerRadius = targetWidth/2
//        zoomOutButton?.addTarget(self, action: #selector(ZoomToIncludeStartAndEndLocation), for: .touchDown)
//        view.addSubview(zoomOutButton!)
//        
//        //shadow
//        zoomOutButton?.clipsToBounds = false
//        zoomOutButton?.layer.shadowOpacity = 0.3
//        zoomOutButton?.layer.shadowOffset = CGSize(width: 0, height: 0)
//        zoomOutButton?.layer.shadowRadius = 10
        
        //location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.distanceFilter = 10
        locationManager?.headingFilter = 5
        
//        //focusbarbutton
//        focusBarButton = UIButton(frame: CGRect(x: 20, y: 20, width: targetWidth, height: targetWidth))
//        
//        //set up button image
//        focusBarButton?.imageView?.contentMode = .scaleAspectFit
//        focusBarButton?.setImage(#imageLiteral(resourceName: "Marker-48").newImageWithSize(CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
//        focusBarButton?.tintColor = ColorManager.selectedIconColor
//        focusBarButton?.backgroundColor = UIColor.white
//        focusBarButton?.layer.cornerRadius = targetWidth/2
//        focusBarButton?.addTarget(self, action: #selector(FocusBarLocation), for: .touchDown)
//        view.addSubview(focusBarButton!)
//        //shadow
//        focusBarButton?.clipsToBounds = false
//        focusBarButton?.layer.shadowOpacity = 0.3
//        focusBarButton?.layer.shadowOffset = CGSize(width: 0, height: 0)
//        focusBarButton?.layer.shadowRadius = 10
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        SetBarMarker()
        FocusCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopUpdatingHeading()
    }
    
    func SetBar(bar : Bar)
    {
        highlightedBar = bar
        SetBarMarker()
        FocusBarLocation()
    }
    
    func SetBarMarker()
    {
        guard highlightedBar != nil else {return}
        let barTitle = highlightedBar?.name
        let loc_lat = CLLocationDegrees(highlightedBar!.loc_lat)
        let loc_long = CLLocationDegrees(highlightedBar!.loc_long)
        
        // Creates a marker in the center of the map.
        
        marker.position = CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
        marker.snippet = barTitle
        marker.title = "\(highlightedBar?.address)"
    }
    
    func FocusCurrentLocation()
    {
        if let mapView = mapView
        {
            if let location = mapView.myLocation
            {
                mapView.animate(toZoom: 17)
                mapView.animate(toLocation: location.coordinate)
            }
            else
            {
                print("no current location found")
            }
        }
    }
    
    func FocusBarLocation()
    {
        StopFollow()
        guard let bar = highlightedBar else {return}
        let loc_lat = CLLocationDegrees(bar.loc_lat)
        let loc_long = CLLocationDegrees(bar.loc_long)
        let barLocation = CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
        
        if let mapView = mapView
        {
            mapView.animate(toZoom: 14)
            mapView.animate(toLocation: barLocation)
        }
    }
    
    //================================================================================================
    //                                          BUTTON SELECTORS
    //================================================================================================
    func ToggleMapBehaviour()
    {
        //when button is tapped
        switch mapBehaviourMode {
        case 0:
            StartFollowLocation()
        case 1:
            StartFollowOrientation()
        case 2:
            StopFollow()
            StartFollowLocation()
        default:
            return
        }
        
    }
    
    func OpenGoogleMaps()
    {
        var barLocLat : Double = 0
        var barLocLong : Double = 0
        if highlightedBar != nil
        {
            barLocLat = highlightedBar!.loc_lat
            barLocLong = highlightedBar!.loc_long
        }
       
        
        guard barLocLat != 0 && barLocLong != 0 else {
            
            PopupManager.singleton.Popup(title: "Oops!", body: "This bar does not have a registered google maps location", presentationViewCont: self)
            return
        }
        //1.329486,103.88217
        let startAdd = "My%20Location"
        let endAdd = "\(barLocLat),\(barLocLong)"
        
        let newUrl = URL(string: "comgooglemaps://?saddr=\(startAdd)&daddr=\(endAdd)&directionsmode=transit")
        
        guard let url = newUrl else {return}
        
        if UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.openURL(url)
        }
        else
        {
            //means user doesnt have application
            if UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.openURL(url)
            }
        }
        
        
        
    }

    func StartFollowLocation()
    {
        mapBehaviourMode = 1
        locationManager?.startUpdatingLocation()
        
        //ui
        focusLocationButton?.tintColor = ColorManager.selectedIconColor
        focusLocationButton?.setImage(targetImage.withRenderingMode(.alwaysTemplate), for: .normal)
        
        //change view angle
        mapView?.animate(toViewingAngle: 0)
        mapView?.animate(toZoom: 17)

    }
    
    func StartFollowOrientation()
    {
        mapBehaviourMode = 2
        locationManager?.startUpdatingLocation()
        locationManager?.startUpdatingHeading()
        
        //ui
        focusLocationButton?.tintColor = ColorManager.selectedIconColor
        focusLocationButton?.setImage(compassImage.withRenderingMode(.alwaysTemplate), for: .normal)
        
        //change view angle
        mapView?.animate(toViewingAngle: 45)
        mapView?.animate(toZoom: 18)
    }
    

    
    func StopFollow()
    {
        mapBehaviourMode = 0
        locationManager?.stopUpdatingLocation()
        locationManager?.stopUpdatingHeading()

        //ui
        focusLocationButton?.tintColor = ColorManager.deselectedIconColor
        focusLocationButton?.setImage(targetImage.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if mapBehaviourMode != 0
        {
            
            let location = locations.last
            if let location = location
            {
                mapView?.animate(toLocation: location.coordinate)
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if mapBehaviourMode == 2
        {
            mapView?.animate(toBearing: newHeading.trueHeading)
        }
    }
    
    
    func ZoomToIncludeStartAndEndLocation()
    {
        StopFollow()
        
        guard let bar = highlightedBar else {print("no bar to include in zoom out");return}
        let loc_lat = CLLocationDegrees(bar.loc_lat)
        let loc_long = CLLocationDegrees(bar.loc_long)
        let barLocation = CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
        
        //gets user location
        
        guard let myLocation = locationManager?.location?.coordinate else {return}
        let locations = [barLocation,myLocation]
        
        //set boundary
        var bounds = GMSCoordinateBounds()
        for location in locations
        {
            bounds = bounds.includingCoordinate(location)
        }
        
        //update map
        
        let update = GMSCameraUpdate.fit(bounds, with:UIEdgeInsetsMake(100, 20, 20, 100))
        mapView?.animate(with: update)
    }
    

    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if gesture
        {
            StopFollow()
        }
        
    }
}
