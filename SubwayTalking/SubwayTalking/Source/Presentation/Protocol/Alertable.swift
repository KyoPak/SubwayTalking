//
//  Alertable.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/12/24.
//

import UIKit

protocol Alertable: AnyObject { }

extension Alertable where Self: UIViewController {
    func showLocationAuthorizationAlert() {
        let alert = UIAlertController(
            title: Constant.Text.locationAlertTitle,
            message: Constant.Text.locationAlertMessage,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: Constant.Text.locationAlertConfirmActionTitle,
            style: .default
        ) { action in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancelAction = UIAlertAction(title: Constant.Text.alertCancelActionTitle, style: .destructive)
        
        [confirmAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: Constant.Text.alertCancelActionTitle,
            style: .default
        )
        
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
}
