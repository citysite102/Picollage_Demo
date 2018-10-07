//
//  FontModel.swift
//  Picollage Demo
//
//  Created by Samuel on 2018/10/6.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit


struct FontModel: Codable {
    
    struct FontFileModel: Codable {
        let regular: String
    }
    
    let category: String
    let family: String
    let variants: [String]
    let subsets: [String]
    let version: String
    let lastModified: String
    let files: FontFileModel
    
    private enum CodingKeys: String, CodingKey {
        case category
        case family
        case variants
        case subsets
        case version
        case lastModified
        case files
    }
    
    var customFont: UIFont?
    var customColor: UIColor!
}
