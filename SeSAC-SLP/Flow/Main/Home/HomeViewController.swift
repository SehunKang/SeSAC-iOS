//
//  HomeViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/04.
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

class HomeViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var buttonGenderAll: SegmentedButton!
    @IBOutlet var buttonGenderMale: SegmentedButton!
    @IBOutlet var buttonGenderFemale: SegmentedButton!
    @IBOutlet var stackViewGender: UIStackView!
    @IBOutlet var buttonGps: UIButton!
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var coverView: UIView!
    @IBOutlet var viewForShadow: UIView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicUIConfigure()
        locationConfigure()
    }
    
    private func basicUIConfigure() {
        
        buttonGenderAll.setOnlyTitle(text: "전체")
        buttonGenderMale.setOnlyTitle(text: "남자")
        buttonGenderFemale.setOnlyTitle(text: "여자")
        
        buttonGenderAll.isSelected = true
        coverView.layer.cornerRadius = 8
        coverView.clipsToBounds = true
        viewForShadow.shadowConfig()
            
        buttonGps.layer.cornerRadius = 8
        buttonGps.backgroundColor = CustomColor.SLPWhite.color
        buttonGps.shadowConfig()
        
        statusButton.shadowConfig()
    }
    
//    private func locationConfigure() {
//        
//        if CLLocationManager.locationServicesEnabled() {
//            switch locationManager.authorizationStatus {
//            case .authorizedAlways, .authorizedWhenInUse:
//                locationManager.star
//            default:
//                setDefaultLocation()
//            }
//        }
//        
//        
//        
//        
//        
//    }
    

    private func setDefaultLocation() {
        let location = CLLocationCoordinate2D(latitude: 37.566385167896016, longitude: 126.9779657721714)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }



}
