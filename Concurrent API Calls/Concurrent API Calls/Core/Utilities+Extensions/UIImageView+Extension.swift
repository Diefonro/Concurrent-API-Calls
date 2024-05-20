//
//  UIImageView+Extension.swift
//  Concurrent API Calls
//
//  Created by Andrés Fonseca on 19/05/2024.
//

import UIKit

extension UIImageView {
    func showScaleEffectAnimated() {
        UIView.animate(withDuration: 3.0, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: nil)
    }
}
