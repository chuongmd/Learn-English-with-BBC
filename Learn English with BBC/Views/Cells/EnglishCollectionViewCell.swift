//
//  EnglishCollectionViewCell.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import UIKit
import Foundation

class EnglishCollectionViewCell: UICollectionViewCell
{
    
    //Tao ImageMedia cho Cell
    let imageMediaView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Tạo titleLabel cho Cell
    let textLabelView: UILabel =
    {
        let textLabel = UILabel()
        textLabel.numberOfLines = 1
        textLabel.textColor = .black
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.contentMode = .scaleAspectFill
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    //Tạo detailLabel cho Cell
    let detailTextLabelView: UILabel =
    {
        let detailTextLabel = UILabel()
        detailTextLabel.numberOfLines = 2
        detailTextLabel.textColor = .black
        detailTextLabel.contentMode = .scaleAspectFill
        detailTextLabel.lineBreakMode = .byTruncatingTail
        detailTextLabel.font = UIFont.italicSystemFont(ofSize: 12)
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return detailTextLabel
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.layer.borderColor = UIColor(red: 34/255, green: 58/255, blue: 93/255, alpha: 1.0).cgColor
        contentView.layer.borderWidth = 2.0
        contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
        setupView()
    }
    
    func setupView()
    {
        addSubview(imageMediaView)
        addSubview(textLabelView)
        addSubview(detailTextLabelView)
        
        imageMediaView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 2).isActive = true
        imageMediaView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2).isActive = true
        imageMediaView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -2).isActive = true
        imageMediaView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.64).isActive = true
        
        textLabelView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        textLabelView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        textLabelView.topAnchor.constraint(equalTo: self.imageMediaView.bottomAnchor, constant: 4).isActive = true
        textLabelView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        detailTextLabelView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        detailTextLabelView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        detailTextLabelView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        detailTextLabelView.topAnchor.constraint(equalTo: self.textLabelView.bottomAnchor, constant: 4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
