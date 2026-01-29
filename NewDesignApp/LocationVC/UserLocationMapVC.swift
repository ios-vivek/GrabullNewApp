//
//  UserLocationMapVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 06/02/25.
//

import UIKit
import MapKit
import CoreLocation

class UserLocationMapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainAddressLbl: UILabel!
    @IBOutlet weak var subAddressLbl: UILabel!
    @IBOutlet weak var changeLocationBtn: UIButton!
    @IBOutlet weak var confirmLocationBtn: UIButton!
    @IBOutlet weak var locationView: UIView!
        var locationManager: CLLocationManager!
    let annotation = MKPointAnnotation()
    var location = CLLocation()
var addressWithLatLong = [ResultLatLong]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainAddressLbl.text = ""
        subAddressLbl.text = ""
        locationView.isHidden = true
        confirmLocationBtn.setRounded(cornerRadius: 10)
        changeLocationBtn.setRounded(cornerRadius: 8)
        locationManager = CLLocationManager()
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
               
               // Request location permission
               locationManager.requestWhenInUseAuthorization()
               
               // Start updating the location
               locationManager.startUpdatingLocation()
               
               // Set the map's delegate
               mapView.delegate = self
               
               // Show the user's location on the map
               mapView.showsUserLocation = true
        self.view.backgroundColor = UIColor.white
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmLocationAction() {
        if !self.addressWithLatLong.isEmpty {
        UtilsClass.setGlobalAddress(addressWithLatLong: self.addressWithLatLong)
            self.popTo(TabBarVC.self)
            //let tabbar = self.navigationController?.viewControllers[2] as! DashBoardVC
           // self.navigationController?.popToViewController(tabbar, animated: true)
           // self.navigationController?.popViewController(animated: true)
        }
    }
    func popTo(_ type: AnyClass) {
        guard let controllers = navigationController?.viewControllers else {return}
        
        for controller in controllers {
            print(controller)
            if controller.classForCoder == type {
                navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    func getAddressFromLatlong(text: String) {
        UtilsClass.showProgressHud(view: self.view)
        GoogleAPisService.googleAddressFromLatLong(searchtext: text, forModelType: GoogleAddressLatLongResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            guard let address = success.data.results else {
                return
            }
           // self.addressWithLatLong = address
            print("Address list- \(address.count)")
            for add in address[0].address_components {
                if add.types.contains("premise") {
                    self.mainAddressLbl.text = add.long_name
                    break
                }

            }
            self.subAddressLbl.text = address[0].formatted_address
            self.locationView.isHidden = false
            self.addressWithLatLong = address
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    
    // CLLocationManagerDelegate method: Called when the location manager successfully gets the user's location
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let userLocation = locations.first {
                locationManager.stopUpdatingLocation()
                /*
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)  // New York City coordinates
                        annotation.title = "Your location"
                        annotation.subtitle = "The Big Apple"
                        
                        // Add annotation to the map
                        mapView.addAnnotation(annotation)
                */
                // Create a region centered on the user's current location
                let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
                
                // Set the map's region to show the user's current location
                mapView.setRegion(region, animated: true)
            }
        }
        
        // CLLocationManagerDelegate method: Called when there is an error getting the user's location
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation") ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
            
            // Customize the annotation pin
            annotationView.tintColor = .green  // Change pin color
            annotationView.canShowCallout = true  // Show callout when tapped
            
            // Add a custom image or button if needed
            let rightButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = rightButton
            
            return annotationView
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Get the center coordinate of the map
            let centerCoordinate = mapView.centerCoordinate
            
            // Print the latitude and longitude of the new center
            print("Map Center: Latitude: \(centerCoordinate.latitude), Longitude: \(centerCoordinate.longitude)")
        location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        annotation.coordinate = CLLocationCoordinate2D(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)  // New York City coordinates
                annotation.title = "Your location"
                //annotation.subtitle = "The Big Apple"
                
                // Add annotation to the map
              //  mapView.addAnnotation(annotation)
        //getAddressFromLocation(location)
        getAddressFromLatlong(text: "\(centerCoordinate.latitude),\(centerCoordinate.longitude)")
       
        }


}
