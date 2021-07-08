//
//  ViewController.swift
//  VennPiChartWithTextData
//
//  Created by Pankaj Kumhar on 12/19/18.
//  Copyright © 2018 Pankaj Kumhar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var vennView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CGFloat {
    /** Degrees to Radian **/
    var degrees: CGFloat {
        return self * (180.0 / .pi)
    }
    
    /** Radians to Degrees **/
    var radians: CGFloat {
        return self / 180.0 * .pi
    }
}
