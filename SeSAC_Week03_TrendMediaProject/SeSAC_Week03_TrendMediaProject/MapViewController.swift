//
//  MapViewController.swift
//  SeSAC_Week03_TrendMediaProject
//
//  Created by Sehun Kang on 2021/10/20.
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI
import simd

class MapViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	
	let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(showAlert))
		self.navigationItem.rightBarButtonItem?.tintColor = .black //
		self.navigationController?.navigationBar.tintColor = .black // 위의 추가된 아이템의 설정을 바꾸는 것과 다르다
		mapView.delegate = self
		locationManager.delegate = self
		
	
		setDefaultLocation()
		setTheatreAnnotation(type: "all")
		showAlert()
		checkUsersLocationServicesAuthorization()
		
	}
	
	func setDefaultLocation() {
		let location = CLLocationCoordinate2D(latitude: 37.566385167896016, longitude: 126.9779657721714)
		let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}
	
	@objc
	func showAlert() {
		
		let authorizationStatus: CLAuthorizationStatus
		if #available(iOS 14.0, *) {
			authorizationStatus = locationManager.authorizationStatus
		} else {
			authorizationStatus = CLLocationManager.authorizationStatus()
		}

		if CLLocationManager.locationServicesEnabled() && (authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse || authorizationStatus == CLAuthorizationStatus.authorizedAlways ){
	
			let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			let all = UIAlertAction(title: "전체보기", style: .default) { _ in
				self.setTheatreAnnotation(type: "all")
			}
			let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
				self.setTheatreAnnotation(type: "롯데시네마")
			}
			let megabox = UIAlertAction(title: "메가박스", style: .default) { _ in
				self.setTheatreAnnotation(type: "메가박스")
			}
			let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
				self.setTheatreAnnotation(type: "CGV")
			}
			let cancel = UIAlertAction(title: "취소", style: .cancel)
			alert.addAction(lotte)
			alert.addAction(megabox)
			alert.addAction(cgv)
			alert.addAction(all)
			alert.addAction(cancel)
			
			self.present(alert, animated: true)

		} else {
			let alert = UIAlertController(title: "위치서비스", message: "디바이스의 위치서비스를 사용하시겠습니까? ", preferredStyle: .alert)
			let ok = UIAlertAction(title: "예", style: .default) { _ in
				guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url)
				}
			}
			let no = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
			alert.addAction(ok)
			alert.addAction(no)
			self.present(alert, animated: true)
		}
		
	}
    
	func setTheatreAnnotation(type: String) {
		mapView.removeAnnotations(mapView.annotations)
		if type == "all" {
			for theatre in mapAnnotations {
				let annotation = MKPointAnnotation()
				annotation.title = theatre.location
				annotation.coordinate = CLLocationCoordinate2D(latitude: theatre.latitude, longitude: theatre.longitude)
				mapView.addAnnotation(annotation)
			}
		} else {
			for theatre in mapAnnotations {
				if theatre.type == type {
					let annotation = MKPointAnnotation()
					annotation.title = theatre.location
					annotation.coordinate = CLLocationCoordinate2D(latitude: theatre.latitude, longitude: theatre.longitude)
					mapView.addAnnotation(annotation)
				}
			}
		}
	}
	
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
	
	func checkUsersLocationServicesAuthorization() {
		let authorizationStatus: CLAuthorizationStatus
		if #available(iOS 14.0, *) {
			authorizationStatus = locationManager.authorizationStatus
		} else {
			authorizationStatus = CLLocationManager.authorizationStatus()
		}
		if CLLocationManager.locationServicesEnabled() {
			checkCurrentLocationAuthorization(authorizationStatus)
		}
	}
	
	func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
		switch authorizationStatus {
		case .notDetermined:
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestWhenInUseAuthorization() // OS레벨에서 한번만 물어본다 하는듯, 재요청 불가. 질문할것
			locationManager.startUpdatingLocation()
		case .restricted, .denied:
			print("restricted, denied")
		case .authorizedAlways:
			print("authorizedAlways")
		case .authorizedWhenInUse:
			locationManager.startUpdatingLocation()
			print("authorizedWhenInUse")
		@unknown default:
			print("default")
		}
		if #available(iOS 14.0, *) {
			let accuracyState = locationManager.accuracyAuthorization
			switch accuracyState {
			case .fullAccuracy:
				print("full")
			case .reducedAccuracy:
				print("reduced")
			@unknown default:
				print("Unknown")
			}
		}
	}
	
	func getCurrentAddress(location: CLLocation) {
		let geoCoder: CLGeocoder = CLGeocoder()
		let location: CLLocation = location
		//한국어 주소 설정
		let locale = Locale(identifier: "Ko-kr")
		//위경도를 통해 주소 변환
		geoCoder.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: { (placemark, error) -> Void in
			guard error == nil, let place = placemark?.first else {
				print("주소설정 불가능")
				return
			}
			self.navigationItem.title = "\(place.administrativeArea ?? "") \(place.locality ?? "")"
			if let administrativeArea = place.administrativeArea {
				print(administrativeArea)
			}
			if let locality = place.locality {
				print(locality)
			}
			if let subLocality = place.subLocality {
				print(subLocality)
			}
			if let subThoroughfare = place.subThoroughfare {
				print(subThoroughfare)
			}
		})
	}
	

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(#function)
		guard let coordinate = locations.last?.coordinate else { return }
		let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
		print(region)
		getCurrentAddress(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
		locationManager.stopUpdatingLocation()
		}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkUsersLocationServicesAuthorization()
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		checkUsersLocationServicesAuthorization()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
	
	
	
}
