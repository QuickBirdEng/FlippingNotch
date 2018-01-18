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
    
    var activate: Void {
        NSLayoutConstraint.activate([self])
    }
    
    var deactivate: Void {
        NSLayoutConstraint.deactivate([self])
    }
    
}
