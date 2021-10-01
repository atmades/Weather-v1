//
//  Alert.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//

import Foundation
import UIKit

final class Alert {
    //    City not found
    class func showUknownLocation() {
        DispatchQueue.main.async {
            guard let navigationController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? UINavigationController else { return }

            let alert = UIAlertController(title: String.alertCityNotFound.tittle.rawValue,
                                          message: String.alertCityNotFound.message.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String.interface.ok.rawValue, style: .default, handler: nil))
                navigationController.present(alert, animated: true)
        }
    }
}
