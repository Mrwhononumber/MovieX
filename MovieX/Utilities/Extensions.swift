//
//  Extensions.swift
//  MovieX
//
//  Created by Basem El kady on 2/11/22.
//

import Foundation
import UIKit

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
//MARK: - Activity Indicator
var aView: UIView?

extension UIImageView {
    
    func showImageSpinner(){
        aView = UIView()
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        aView?.translatesAutoresizingMaskIntoConstraints = false
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = aView!.center
        activityIndicator.startAnimating()
        aView?.addSubview(activityIndicator)
        self.addSubview(aView!)
        aView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        aView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
   
    func removeImageSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
}
extension UIViewController {
    
    func showViewSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = (aView!.center)
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func hideViewSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
}
