//
//  CGFloat+Extensions.swift
//  
//
//  Created by Nilaakash Singh on 14/07/21.
//

import UIKit

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
