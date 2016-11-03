//
//  LocationViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 20/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit
import GoogleMaps
class LocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyANTsheZ7ClHH98Js5p1QA-7QIqw_KPrLQ")
        
        let barTitle = BarManager.singleton.displayedDetailBar.name
        let loc_lat = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_lat)
        let loc_long = CLLocationDegrees(BarManager.singleton.displayedDetailBar.loc_long)
        
        let camera = GMSCameraPosition.camera(withLatitude: loc_lat, longitude: loc_long, zoom: 4.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
        marker.title = barTitle
        //marker.snippet = "Australia"
        marker.map = mapView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
