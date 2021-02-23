//
//  UIView extensions.swift
//  hn
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UIViewController {
    func toogleActivityIndicatorStatus(activityIndicator: UIActivityIndicatorView, isOn: Bool) {
        activityIndicator.isHidden = !isOn
        
        switch isOn {
        case true:
            activityIndicator.startAnimating()
        case false:
            activityIndicator.stopAnimating()
        }
    }
    
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
