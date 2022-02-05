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
import RxSwift
import RxCocoa
import Moya

enum SeekGender {
    case all
    case male
    case female
}

struct QueueData: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

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
    let disposeBag = DisposeBag()
    let mapRadius: CLLocationDistance = 1400
    
    var seekGender: SeekGender = .all {
        didSet {
            if oldValue != seekGender {
                mapView.removeAnnotations(mapView.annotations)
                self.findFriend()
            }
        }
    }
    
    let annotationIdentifier = "AnnotationIdentifier"
    
    var currentQueueData: QueueData? {
        didSet {
            self.showFriend()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicUIConfigure()
        mapConfigure()
        locationConfigure()
        buttonBind()
        findFriend()
        UserDefaultManager.userStatus = UserStatus.normal.rawValue
        print("this is idtoken",UserDefaultManager.idtoken)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        findFriend()
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
    
    private func mapConfigure() {
        
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 13000)
        mapView.delegate = self

    }
    
    private func locationConfigure() {
        
        setDefaultLocation()
        locationManager.delegate = self
        checkUsersLocationServicesAuthorization()
    }
    
    private func buttonBind() {
        
        Observable.merge(
            buttonGenderAll.rx.tap.map {SeekGender.all},
            buttonGenderMale.rx.tap.map {SeekGender.male},
            buttonGenderFemale.rx.tap.map {SeekGender.female}
        ).subscribe { value in
            guard let gender = value.element else {return}
            self.buttonGenderAll.isSelected = gender == .all
            self.buttonGenderMale.isSelected = gender == .male
            self.buttonGenderFemale.isSelected = gender == .female
            self.seekGender = gender
        }
        .disposed(by: disposeBag)
        
        buttonGps.rx.tap
            .subscribe { _ in
                self.checkUsersLocationServicesAuthorization()
            }
            .disposed(by: disposeBag)
        
        
        UserDefaults.standard.rx.observe(String.self, "userStatus")
            .subscribe { status in
            guard let currentStatus = status.element else {return}
            switch currentStatus {
            case UserStatus.normal.rawValue:
                self.statusButton.setImage(UIImage(named: "default"), for: .normal)
            case UserStatus.searching.rawValue:
                self.statusButton.setImage(UIImage(named: "matching"), for: .normal)
            case UserStatus.doneMatching.rawValue:
                self.statusButton.setImage(UIImage(named: "matched"), for: .normal)
            default: break
            }
        }.disposed(by: disposeBag)
    }
    
    private func findFriend() {
        let latitude = mapView.region.center.latitude
        let longitude = mapView.region.center.longitude
        let region: Int = Int((trunc((latitude + 90) * 100) * 100000) + (trunc((longitude + 180) * 100)))
        let data = ["region": region, "lat": latitude, "long": longitude] as [String : Any]
        let provider = MoyaProvider<APIServiceQueue>()
        provider.request(.onqueue(data: data)) { result in
            switch result {
            case let .success(response):
                let data = try? response.map(QueueData.self)
                self.currentQueueData = data
            case let .failure(error):
                print(error.errorDescription as Any)
                self.errorHandler(with: error.errorCode)
            }
        }
    }
    
    private func showFriend() {
        guard let data = currentQueueData else {return}
        
        data.fromQueueDB.forEach {
            if seekGender != .all {
                let gender = seekGender == .male ? Gender.male.rawValue : Gender.female.rawValue
                if $0.gender != gender {
                    return
                }
            }
            let location = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
            self.setAnnotation(imageType: $0.sesac, location: location)
        }
    }
    
    
}

extension HomeViewController: MKMapViewDelegate {
    
    private func setAnnotation(imageType: Int, location: CLLocationCoordinate2D) {
        
        let annotation = CustomAnnotation()
        guard let image = UIImage(named: "sesac_face_\(imageType)") else {fatalError("wrong sesac face imageType number")}
        annotation.image = image
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        findFriend()
        print(mapView.region.center as Any)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        let customAnnotation = annotation as! CustomAnnotation
        
        annotationView?.image = customAnnotation.image
        annotationView?.contentMode = .scaleAspectFit
        
        
        return annotationView
    }
    
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    private func checkUsersLocationServicesAuthorization() {
        
        let authorizationStatus = locationManager.authorizationStatus
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(status: authorizationStatus)
        } else {
            showLocationServiceAlert()
        }
    }
    
    private func showLocationServiceAlert() {
        
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
    
    private func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
    }
    
    private func setDefaultLocation() {
        let location = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
//        let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: mapRadius, longitudinalMeters: mapRadius)
//        setAnnotation(imageType: 0, location: location)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let region = MKCoordinateRegion(center: location, latitudinalMeters: mapRadius, longitudinalMeters: mapRadius)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
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
