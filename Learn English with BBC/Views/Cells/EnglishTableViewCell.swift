//
//  EnglishTableViewCell.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import UIKit
import Foundation

class EnglishTableViewCell: UITableViewCell
{
    
    //Tạo ImageMedia cho Cell
    let imageMediaView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Tạo titleLabel cho Cell
    let textLabelView: UILabel =
    {
        let textLabel = UILabel()
        textLabel.numberOfLines = 2
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    //Tạo detailLabel cho Cell
    let detailTextLabelView: UILabel =
    {
        let detailTextLabel = UILabel()
        detailTextLabel.numberOfLines = 2
        detailTextLabel.lineBreakMode = .byTruncatingTail
        detailTextLabel.font = .systemFont(ofSize: 16)
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return detailTextLabel
    }()
    
    //Hàm khởi tạo của EnglishCell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: "EnglishTableViewCell")
        
        self.contentView.addSubview(imageMediaView)
        self.contentView.addSubview(textLabelView)
        self.contentView.addSubview(detailTextLabelView)
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = UIColor.init(red: 253/255, green: 254/255, blue: 254/255, alpha: 1.0)
        
        imageMediaView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        imageMediaView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        imageMediaView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageMediaView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        textLabelView.leftAnchor.constraint(equalTo: imageMediaView.rightAnchor, constant: 12).isActive = true
        textLabelView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 20).isActive = true
        textLabelView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        textLabelView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1/2).isActive = true
        
        detailTextLabelView.leftAnchor.constraint(equalTo: imageMediaView.rightAnchor, constant: 12).isActive = true
        detailTextLabelView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        detailTextLabelView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        detailTextLabelView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
