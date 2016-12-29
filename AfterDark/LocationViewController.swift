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

    var mapView : GMSMapView?
    var button : UIButton?
    
    let targetImage = #imageLiteral(resourceName: "target1x")
    let compassImage = #imageLiteral(resourceName: "Compass")
    
    var locationManager : CLLocationManager?
    var latestLocation : CLLocationCoordinate2D?
    var mapBehaviourMode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //map init
        GMSServices.provideAPIKey("AIzaSyANTsheZ7ClHH98Js5p1QA-7QIqw_KPrLQ")
        
        let barTitle = BarManager.singleton.displayedDetailBar.name
        let loc_lat = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_lat)
        let loc_long = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_long)
        
        let camera = GMSCameraPosition.camera(withLatitude: loc_lat, longitude: loc_long, zoom: 17)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = self
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
        marker.title = barTitle
        marker.snippet = BarManager.singleton.displayedDetailBar.name
        marker.map = mapView
        
        
        //button
        let targetWidth : CGFloat = 45
        button = UIButton(frame: CGRect(x: Sizing.ScreenWidth() - 20 - targetWidth, y: Sizing.mainViewHeight - Sizing.tabHeight - targetWidth - 20 - Sizing.statusBarHeight, width: targetWidth, height: targetWidth))

        //set up button image
        button?.setImage(targetImage.withRenderingMode(.alwaysTemplate), for: .normal)
        button?.tintColor = ColorManager.deselectedIconColor
        button?.backgroundColor = UIColor.white
        button?.layer.cornerRadius = targetWidth/2
        button?.addTarget(self, action: #selector(ToggleMapBehaviour), for: .touchDown)
        view.addSubview(button!)
        
        button?.clipsToBounds = false
        button?.layer.shadowOpacity = 0.3
        button?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button?.layer.shadowRadius = 10
        
        //location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.distanceFilter = 10
        locationManager?.headingFilter = 5
        
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        FocusBarLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopUpdatingHeading()
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
        let loc_lat = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_lat)
        let loc_long = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_long)
        let barLocation = CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
        
        if let mapView = mapView
        {
            mapView.animate(toZoom: 17)
            mapView.animate(toLocation: barLocation)
        }
    }
    
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
    

    func StartFollowLocation()
    {
        mapBehaviourMode = 1
        locationManager?.startUpdatingLocation()
        
        //ui
        button?.tintColor = ColorManager.selectedIconColor
        button?.setImage(targetImage.withRenderingMode(.alwaysTemplate), for: .normal)
        
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
        button?.tintColor = ColorManager.selectedIconColor
        button?.setImage(compassImage.withRenderingMode(.alwaysTemplate), for: .normal)
        
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
        button?.tintColor = ColorManager.deselectedIconColor
        button?.setImage(targetImage.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if mapBehaviourMode != 0
        {
            
            let location = locations.last
            if let location = location
            {
                mapView?.animate(toLocation: location.coordinate)
                latestLocation = location.coordinate
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
        let loc_lat = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_lat)
        let loc_long = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_long)
        let barLocation = CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
        
        //gets user location
        
        guard let myLocation = latestLocation else {return}
        let locations = [barLocation,myLocation]
        
        //set boundary
        var bounds = GMSCoordinateBounds()
        for location in locations
        {
            bounds = bounds.includingCoordinate(location)
        }
        
        //update map
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView?.animate(with: update)
    }
    

    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if gesture
        {
            StopFollow()
        }
        
    }
}
