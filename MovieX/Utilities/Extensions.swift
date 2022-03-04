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

