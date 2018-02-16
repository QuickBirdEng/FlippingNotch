//
//  NSLayoutConstraint+Extention.swift
//  FlippingNotch
//
//  Created by Joan Disho on 18.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate([self])
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate([self])
    }
    
}
