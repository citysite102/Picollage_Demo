//
//  FontDisplayCell.swift
//  Picollage Demo
//
//  Created by Samuel on 2018/10/7.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit
import WebKit
import CoreText

class FontDisplayCell: UICollectionViewCell {
    
    var fontDisplayLabel: UILabel!
    var dataModel: FontModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4.0
        backgroundColor = UIConstant.normalBGColor
        
        fontDisplayLabel = UILabel()
        fontDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        fontDisplayLabel.textAlignment = .center
        addSubview(fontDisplayLabel)
        NSLayoutConstraint.activate([
            fontDisplayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fontDisplayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            fontDisplayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            fontDisplayLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
            ])
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIConstant.selectedBGColor : UIConstant.normalBGColor
            fontDisplayLabel.textColor = isSelected ? UIColor.white : dataModel.customColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
