//
//  UIAlertHelper.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 27/07/2023.
//

import Foundation
import UIKit

class UIAlertHelper {
    static func showAlertWithTitle(_ title: String, message: String, from viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
