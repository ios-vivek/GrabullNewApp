//
//  Alert.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 24/10/24.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func setImage(
        urlString: String?,
        placeholder: UIImage? = UIImage(named: "img_midium")
    ) {
        // Default state (placeholder)
        self.image = placeholder
        self.contentMode = .center
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }
        
        self.sd_setImage(
            with: url,
            placeholderImage: placeholder,
            options: [.retryFailed, .continueInBackground, .highPriority]
        ) { [weak self] image, error, _, _ in
            
            guard let self = self else { return }
            
            if image != nil && error == nil {
                self.contentMode = .scaleAspectFill
            } else {
                self.image = placeholder
                self.contentMode = .center
            }
        }
    }
}
