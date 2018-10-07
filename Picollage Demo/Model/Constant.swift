//
//  Constant.swift
//  Picollage Demo
//
//  Created by Samuel on 2018/10/6.
//  Copyright © 2018 Samuel. All rights reserved.
//

import Foundation
import UIKit

struct APIConstant {
    
    static let loadedFontNumber: Int = 150
    #if DEBUG
    static let APIKey = ""
    static let BaseURL = "https://www.googleapis.com/webfonts/v1/webfonts"
    #else
    static let APIKey = "Release API Key"
    static let BaseURL = "Release URL"
    #endif
    
}


struct UIConstant {
    static let fontSize: CGFloat = 16
    static let defaultTextColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
    static let searchBorderColor = UIColor(red: 217/255, green: 218/255, blue: 228/255, alpha: 1)
    static let searchBGColor = UIColor(red: 237/255, green: 237/255, blue: 241/255, alpha: 1)
    
    static let normalBGColor = UIColor(red: 244/255, green: 244/255, blue: 246/255, alpha: 1)
    static let selectedBorderColor = UIColor(red: 221/255, green: 98/255, blue: 102/255, alpha: 1)
    static let selectedBGColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
    static let selectedGreenColor = UIColor(red: 56/255, green: 162/255, blue: 160/255, alpha: 1)
    static let textColors = [UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1),
                             UIColor(red: 221/255, green: 98/255, blue: 102/255, alpha: 1),
                             UIColor(red: 56/255, green: 162/255, blue: 160/255, alpha: 1)]
}
