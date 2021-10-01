//
//  Extension+ActivityIndicator.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    
    public func turnOn() {
        isHidden = false
        startAnimating()
    }
    
    public func turnOff() {
        isHidden = true
        stopAnimating()
    }
}
