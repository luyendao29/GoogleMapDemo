//
//  ViewController.swift
//  GoogleMapDemo
//
//  Created by Boss on 3/29/20.
//  Copyright © 2020 LuyệnĐào. All rights reserved.
//

import UIKit
import GoogleMaps
import DropDown

enum MapType: Int {
    case none = 0
    case normal = 1
    case satellite = 2
    case terrain = 3
    
    case hybrid = 4
    
    static var all = [none, normal, satellite, terrain, hybrid]
    
    var text: String {
        get {
            switch self {
            case .none:
                return "None"
            case .normal:
                return "Bình thường"
            case .satellite:
                return "Vệ tinh"
            case .terrain:
                return "Mặt đất"
            case .hybrid:
                return "Hỗn hợp"
            }
        }
    }
}

class ViewController: UIViewController, GMSMapViewDelegate, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var viewWrapperMap: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var testTextField: UITextField!
    
    //Current
    var camera = GMSCameraPosition()
    var currentMapType = MapType.none
    
    var mapType = GMSMapViewType.none
    
    
    var viewMap: GMSMapView?
    let marker = GMSMarker()
    
    
    
    
    var viDo = 21.033898
    var kinhDo = 105.767630
    
    let dropDown = DropDown()
    
    let locationManager = CLLocationManager()
    
    
    var currentLocation: CLLocation = CLLocation.init(latitude: CLLocationDegrees(-33.86), longitude: CLLocationDegrees(151.20))
    
    var isDisplayLocation = false
    var isDisplayMarker = false
    var isDisplayTapSelectLocation = false
    //Huypn
    var strTitle = ""
    var params = Dictionary<String, Any>()
    
    
    // index selected of listStation
    var indexSelected: Int = 0
    var markers = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testTextField.delegate = self
//        baseSetting()
//        setDisplayData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DropDown.startListeningToKeyboard()
        loadMap()
    }
    
    //function to convert the given UIView into a UIImage
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func createMarker(latitude: Double, longitude: Double) {
        guard let mapView = viewMap else { return }
        mapView.clear()
        let marker = GMSMarker()
        
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "mapMarker")!.withRenderingMode(.alwaysTemplate)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        //changing the tint color of the image
        markerView.tintColor = UIColor.red
        
        // marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.iconView = markerView
        marker.title = "New Delhi" + "\n" + "Dau Buoi"
        marker.snippet = "India"
        marker.map = mapView
        
        //comment this line if you don't wish to put a callout bubble
        mapView.selectedMarker = marker
    }
    
    func baseSetting() {
        title = strTitle.isEmpty ? "V-Smart" : strTitle
        
//        setDisplayData()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // text Field delegate
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChiDuongVC") as! ChiDuongVC
        vc.latitude = String(viDo)
        vc.longitude = String(kinhDo)
        present(vc, animated: true, completion: nil)
    }
    
    
    func settingMap(){
        // GOOGLE MAPS SDK: BORDER
        let mapInsets = UIEdgeInsets(top: 80.0, left: 45.0, bottom: 0.0, right: 0.0)
        self.viewMap?.padding = mapInsets
        
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // GOOGLE MAPS SDK: COMPASS
        self.viewMap?.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        self.viewMap?.isMyLocationEnabled = true
        self.viewMap?.settings.myLocationButton = true
    }
    
    func loadMap() {
        camera = GMSCameraPosition.camera(withLatitude: viDo, longitude: kinhDo, zoom: 15)
        self.viewMap = GMSMapView.map(withFrame: self.viewWrapperMap.bounds, camera: camera)
//        drawCableRoute()
//        markerCable()
        locationManager.delegate = self
        self.viewMap?.delegate = self
        self.viewMap?.mapType = mapType
        self.viewWrapperMap.addSubview(self.viewMap!)
        
        let centerMapCoordinate = CLLocationCoordinate2D(latitude: viDo, longitude: kinhDo)
        placeMarkerOnCenter(centerMapCoordinate: centerMapCoordinate)
        
        self.viewMap?.animate(to: camera)
        viewWrapperMap.layoutIfNeeded()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //Get current location
//    func getCurrentLocation() {
//
//        VLocation.sharedInstance.getCurrentLocation { (currentLocation) in
//
//            if let location = currentLocation {
//                self.latitude = location.coordinate.latitude
//                self.longtitude = location.coordinate.longitude
//                print(self.latitude as Any, self.longtitude as Any)
//                //fix cứng lấy data
//                self.latitude = 21.017029
//                self.longtitude = 105.783671
//            } else {
//                self.showAlertController(title: VTLocalizedString.localized(key: "Thông báo"), message: VTLocalizedString.localized(key: "Không thể lấy được vị trí, thử lại?"), cancelAction: nil, okAction: {
//                    self.getCurrentLocation()
//                })
//            }
//        }
//    }
    
    
    
    
    
    
    
    // kẻ và đánh dấu trên map
    func drawCableRoute() {
//        if let mapView = viewMap {
//            if infoCable.geometry != nil && infoCable.geometry!.coordinates.count > 0 {
//                mapView.clear()
//                let path = GMSMutablePath()
//                for item in infoCable.geometry!.coordinates {
//                    if let lat = item.latitude, let lng = item.longitude {
//                        let locationCoodinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                        // add item to line
//                        path.add(locationCoodinate2D)
//
//                        let polyline = GMSPolyline(path: path)
//                        polyline.strokeWidth = 3.0
//                        polyline.strokeColor = UIColor.blue
//                        // Your map view
//                        polyline.map = mapView
//                    }
//                }
//            }
//        }
    }
    
    func markerCable() {
        markers.removeAll()
        let centerMapCoordinate = CLLocationCoordinate2D(latitude: viDo, longitude: kinhDo)
        placeMarkerOnCenter(centerMapCoordinate: centerMapCoordinate)
//        if let coordinates = infoCable.geometry?.coordinates {
//            for item in coordinates {
//                if let latitude = item.latitude, let longitude = item.longitude {
//                    let centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                    placeMarkerOnCenter(centerMapCoordinate: centerMapCoordinate)
//                }
//            }
//        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//            viewMap?.isMyLocationEnabled = true
//            viewMap?.settings.myLocationButton = true
//        }
//    }
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            viewMap?.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
//            locationManager.stopUpdatingLocation()
//        }
//    }
}

//MARK: Call API
extension ViewController {
    // Cập nhật thông tin đoạn cáp
//    func updateCable(params: Dictionary<String, Any>) {
//        self.showLoading()
//        QuanLyHaTangNimsRouter(endpoint: .updateCable(params: params)).request { (result) in
//            self.hideLoading()
//            switch result {
//            case .success(let response, _):
//                if let dataReturn = response as? JSON, let status = dataReturn["status"].string, let message = dataReturn["message"].string {
//                    if status == "SUCCESS" {
//                        self.showNoticeMessage(message: message)
//                    } else {
//                        self.showErrorMessage(message: message)
//                    }
//                }
//            case .failure(_):
//                self.viewMap?.clear()
//            default:
//                break
//            }
//        }
//    }
    
}

extension ViewController {
    //MARK: Action
    
    
    @IBAction func tappedEditLoaiCap(_ sender: UIButton!) {
        dropDown.dataSource = MapType.all.map { $0.text }
        dropDown.direction = .bottom
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.bounds.size.height)
        dropDown.width = sender.bounds.size.width
        dropDown.selectionAction = { (index, item) in
            self.currentMapType = MapType.all[index]
            switch self.currentMapType {
            case .none:
                self.mapType = .none
            case .normal:
                self.mapType = .normal
            case .satellite:
                self.mapType = .satellite
            case .terrain:
                self.mapType = .terrain
            case .hybrid:
                self.mapType = .hybrid
            }
            self.view.endEditing(true)
            self.dropDown.reloadInputViews()
            sender.setTitle(item, for: .normal)
            self.loadMap()
        }
        dropDown.show()
        
    }
    
    @IBAction func tappedRefreshLocation(_ sendder: UIButton!) {
        loadMap()
//        cheChieuDaiView.isHidden = true
//        updateButton.isHidden = false
//        lengthTextField.becomeFirstResponder()
    }
    
    @IBAction func tappedConectHypelink(_ sendder: UIButton!) {
//        let vc = Storyboard.QuanLyHaTangNIMS.nimsThongTinSoiCapVC()
//        vc.infoCable = self.infoCable
//        navigationController?.pushViewController(vc, animated: true)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChiDuongVC") as! ChiDuongVC
        vc.latitude = String(viDo)
        vc.longitude = String(kinhDo)
        present(vc, animated: true, completion: nil)
    }
    
    
    //Coordinate in 4 corner map screen
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        
        //        let projection = mapView.projection.visibleRegion()
        //
        //        let topLeftCorner: CLLocationCoordinate2D = projection.farLeft
        //        let topRightCorner: CLLocationCoordinate2D = projection.farRight
        //        let bottomLeftCorner: CLLocationCoordinate2D = projection.nearLeft
        //        let bottomRightCorner: CLLocationCoordinate2D = projection.nearRight
        //
        //        x1 = topLeftCorner.latitude
        //        y1 = topLeftCorner.longitude
        //        x2 = bottomRightCorner.latitude
        //        y2 = bottomRightCorner.longitude
        //
                viDo = mapView.camera.target.latitude
                kinhDo = mapView.camera.target.longitude
        
            createMarker(latitude: viDo, longitude: kinhDo)
        
        
        //        let centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //        self.placeMarkerOnCenter(centerMapCoordinate: centerMapCoordinate)
        //        print("Toạ độ: ", topLeftCorner, topRightCorner, bottomLeftCorner, bottomRightCorner)
    }
    
    // function to place a marker on center point
    func placeMarkerOnCenter(centerMapCoordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = centerMapCoordinate
        markers.append(marker)
        marker.icon = GMSMarker.markerImage(with: UIColor.red)
        marker.snippet = "Hàm Nghi"
        marker.map = self.viewMap
    }
    
    //Tapped in marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        changedView = true
//        loadMap()
//        if let index = markers.index(of: marker) {
//            for i in 0..<markers.count {
//                if index == i {
//                    markers[i].icon = GMSMarker.markerImage(with: UIColor.red)
//                } else {
//                    markers[i].icon = GMSMarker.markerImage(with: UIColor.gray)
//                }
//                indexSelected = index
//            }
//        }
        return true
    }
    
    //    @IBAction func onClickToDirection(_ sender: UIButton!) {
    //        let directionMapVC = UIStoryboard.init(name: "TraCuuThueBaoBCCS", bundle: nil).instantiateViewController(withIdentifier: "ChiDuongVC") as! ChiDuongVC
    //        self.title = ""
    //        let latitude = listStation[indexSelected].latitude ?? 0
    //        let longitude = listStation[indexSelected].longtitude ?? 0
    //        directionMapVC.latitude = String(latitude)
    //        directionMapVC.longitude = String(longitude)
    //        self.navigationController?.pushViewController(directionMapVC, animated: true)
    //    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        tempView.isHidden = false
        //        isFullScreen = false
        //        loadMapPillar()
        //        if !isDisplayMarker {
        //            self.showAlertController(title: "Thông báo".language(), message: "Bạn có chắc chắn chọn vị trí này?".language(), cancelAction: nil) {
        //                self.marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude , longitude: coordinate.longitude)
        //                self.delegate?.didSelectLocation(coordinate.longitude, coordinate.latitude)
        //            }
        //        }
    }
}






