//
//  ChiDuongVCViewController.swift
//  GoogleMapDemo
//
//  Created by Boss on 3/29/20.
//  Copyright © 2020 LuyệnĐào. All rights reserved.
//

import UIKit

class ChiDuongVC: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    
    var latitude: String?
    var longitude: String?
    var address: String?
    var stringTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        loadSpinner.layer.cornerRadius = loadSpinner.frame.width / 2
        loadAddress()
        if(stringTitle.isEmpty){
            self.title = "V-Smart"
        } else {
            self.title = stringTitle
        }
    }
    
//    func getLocation(){
//        self.showLoading()
//        VLocation.sharedInstance.getCurrentLocation { (currentLocation) in
//            self.hideLoading()
//            if let location = currentLocation {
//                self.latitude = String.init(describing: location.coordinate.latitude)
//                self.longitude = String.init(describing: location.coordinate.longitude)
//                print(self.latitude, self.longitude)
//            } else {
//                self.showAlertController(title: VTLocalizedString.localized(key: "Thông báo"), message: VTLocalizedString.localized(key: "Không thể lấy được vị trí, thử lại?"), cancelAction: nil, okAction: {
//                    self.getLocation()
//                })
//            }
//        }
//    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad")
        loadSpinner.isHidden = false
        loadSpinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
        loadSpinner.stopAnimating()
        loadSpinner.isHidden = true
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("didFailLoadWithError")
        loadSpinner.stopAnimating()
        loadSpinner.isHidden = true
    }
    
    func loadAddress() {
        let latitude = self.latitude ?? ""
        let longitude = self.longitude ?? ""
        let url = """
        https://www.google.com/maps/dir//\(latitude),\(longitude)/@\(latitude),\(longitude)z/data=!4m2!4m1!3e0
        """
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.loadRequest(myRequest)
        print("Sucessfully")
    }
    
    
    @IBAction func onClickedReload(_ sender: Any) {
        loadAddress()
    }
    
    // MARK: Actions
    @IBAction func tappedBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
