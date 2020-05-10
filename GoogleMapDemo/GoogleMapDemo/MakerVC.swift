//
//  MakerVC.swift
//  GoogleMapDemo
//
//  Created by Boss on 5/10/20.
//  Copyright © 2020 LuyệnĐào. All rights reserved.
//

import UIKit
import GoogleMaps

class MakerVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInfoWindow = CustomInfoWindow().loadView()
        loadMap()
    }
    
    func loadMap() {
        guard let mapView = mapView else { return }
        let camera = GMSCameraPosition.camera(withLatitude: 51.5287352, longitude: -0.3817818, zoom: 8)
        
        mapView.camera = camera
        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 51.5287352, longitude: -0.3817818)
//        marker.title = "My marker"
//        marker.icon = UIImage(named: "icons8-internet_antenna")
//        marker.map = self.mapView
        
//        let anotherMarker = GMSMarker()
//        anotherMarker.position = CLLocationCoordinate2D(latitude: 52, longitude: -0.10)
//        anotherMarker.title = "Another marker"
//        anotherMarker.map = self.mapView
        
//        self.tappedMarker = GMSMarker()
        
//        self.customInfoWindow = CustomInfoWindow().loadView()
        
//        for item in testCoordinate {
//            marker.position = item
//            marker.title = "My marker"
//            marker.icon = UIImage(named: "icons8-internet_antenna")
//            marker.map = mapView
//        }
        
        
        for item in testCoordinate {
            let image = imageWithView(view: setView(location: item))
            customInfoWindow?.removeFromSuperview()
            marker.position = item
            marker.icon = image
            marker.map = mapView
        }
        
        mapView.delegate = self
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
        
        //get position of tapped marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        let opaqueWhite = UIColor(white: 1, alpha: 0.85)
        customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
        customInfoWindow?.layer.cornerRadius = 8
        customInfoWindow?.center = mapView.projection.point(for: position)
        //        customInfoWindow?.center.y -= 100
        customInfoWindow?.center.y = self.view.bounds.height/2 - 85
        customInfoWindow?.customWindowLabel.text = "Load  Custom Info Window"
        customInfoWindow?.bounds.size = CGSize(width: 100, height: 100)
        self.mapView.addSubview(customInfoWindow!)
        
        return false
    }
    
    func setView(location: CLLocationCoordinate2D) -> UIView {
        //get position of tapped marker
        //        let marker = GMSMarker()
        //        marker.position = location
        //
        //        let position = marker.position
        //        mapView.animate(toLocation: position)
        //        let point = mapView.projection.point(for: position)
        //        let newPoint = mapView.projection.coordinate(for: point)
        //        let camera = GMSCameraUpdate.setTarget(newPoint)
        //        mapView.animate(with: camera)
//        view.layoutIfNeeded()
        let opaqueWhite = UIColor(white: 1, alpha: 0.85)
        customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
        customInfoWindow?.layer.cornerRadius = 8
        //        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center = mapView.projection.point(for: location)
        //        customInfoWindow?.center.y -= 100
        //        customInfoWindow?.center.y = self.view.bounds.height/2 - 85
                customInfoWindow?.center.y = self.view.bounds.height
        customInfoWindow?.customWindowLabel.text = "Load  Custom Info Window"
        customInfoWindow?.bounds.size = CGSize(width: 100, height: 100)
        self.mapView.addSubview(customInfoWindow!)
        return customInfoWindow!
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    var listCoordinate = [CLLocationCoordinate2D]()
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        listCoordinate.append(coordinate)
        let marker = GMSMarker()
        marker.position = coordinate
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = mapView
        //        setView(location: coordinate)
        
                customInfoWindow?.removeFromSuperview()
    }
    
    
    
    func createMarker() {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 100
        
        let marker = GMSMarker()
        
        // I have taken a pin image which is a custom image
        //        let markerImage = UIImage(named: "mapMarker")!.withRenderingMode(.alwaysTemplate)
        
        //creating a marker view
        //        let markerView = UIImageView(image: markerImage)
        let markerView = imageWithView(view: customInfoWindow!)
        
        //changing the tint color of the image
        //        markerView.tintColor = UIColor.red
        if let locationCoordinate2D = position {
            marker.position = locationCoordinate2D
        }
        
        //        marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        
        //        marker.iconView = markerView
        marker.icon = markerView
        // marker.title = "New Delhi"
        // marker.snippet = "India"
        marker.map = mapView
        
        //comment this line if you don't wish to put a callout bubble
        mapView.selectedMarker = marker
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //        let position = tappedMarker?.position
        //        customInfoWindow?.center = mapView.projection.point(for: position!)
        //        customInfoWindow?.center.y -= 100
        //
        //        let marker = GMSMarker()
        //
        //        // I have taken a pin image which is a custom image
        ////        let markerImage = UIImage(named: "mapMarker")!.withRenderingMode(.alwaysTemplate)
        //
        //        //creating a marker view
        ////        let markerView = UIImageView(image: markerImage)
        //        let markerView = imageWithView(view: customInfoWindow!)
        //
        //        //changing the tint color of the image
        ////        markerView.tintColor = UIColor.red
        //        if let locationCoordinate2D = position {
        //            marker.position = locationCoordinate2D
        //        }
        //
        ////        marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        //
        ////        marker.iconView = markerView
        //        marker.icon = markerView
        //        marker.title = "New Delhi"
        //        marker.snippet = "India"
        //        marker.map = mapView
        //
        //        //comment this line if you don't wish to put a callout bubble
        //        mapView.selectedMarker = marker
    }
    
    //function to convert the given UIView into a UIImage
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    @IBAction func danhDau(_ sender: UIButton) {
//        customInfoWindow?.removeFromSuperview()
        let marker = GMSMarker()
        for item in listCoordinate {
            let image = imageWithView(view: setView(location: item))
            marker.position = item
            marker.icon = image
            if let mapView = mapView {
                marker.map = mapView
            }
        }
        
        print(listCoordinate)
        
    }
    
    var testCoordinate = [
        CLLocationCoordinate2D(latitude: 52.33818867670363, longitude: -0.9970169886946678),
        CLLocationCoordinate2D(latitude: 51.7316177043579, longitude: -0.9915238246321678),
        CLLocationCoordinate2D(latitude: 50.91290059639955, longitude: 0.04668485373258591)
    ]

}

