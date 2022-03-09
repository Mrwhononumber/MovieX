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

extension UIView {
    
    func performSpringAnimation() {
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut) {
            self.transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
        } completion: { _ in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           
                           options: .curveEaseInOut,
                           animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
                           completion: nil)
        }
    }
}

