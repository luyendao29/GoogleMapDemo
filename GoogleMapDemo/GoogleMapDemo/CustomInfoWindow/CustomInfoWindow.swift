//
//  CustomInfoWindow.swift
//  GoogleMapDemo
//
//  Created by Boss on 5/10/20.
//  Copyright © 2020 LuyệnĐào. All rights reserved.
//

import Foundation
import UIKit

class CustomInfoWindow: UIView {
    
    @IBOutlet weak var customWindowLabel: UILabel!
    
    @IBOutlet weak var viettelImageView: UIImageView!
    @IBOutlet weak var vinaImageView: UIImageView!
    @IBOutlet weak var mobiImageView: UIImageView!
    
    
    
    @IBAction func press(_ sender: UIButton) {
        self.customWindowLabel.text = "Tao vừa ấn vào đây"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() -> CustomInfoWindow{
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
        return customInfoWindow
    }
}
