//
//  UIView+Extentions.swift
//  FlippingNotch
//
//  Created by Joan Disho on 18.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func snapshotImage(afterScreenUpdated: Bool = true) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            self.drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdated)
        }
    }
}
