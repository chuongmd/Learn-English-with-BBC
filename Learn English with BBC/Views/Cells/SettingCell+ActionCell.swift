//
//  SettingCell+ActionCell.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import UIKit
import Foundation


class ActionCell: SettingCell
{
    
    override var isHighlighted: Bool
    {
        didSet
        {
            backgroundColor = isHighlighted ? UIColor(white: 0.3, alpha: 0.3) : .white
            nameLabel.textColor = isHighlighted ? UIColor.white : .blue
        }
    }
    var actions: Setting?
    {
        didSet
        {
            nameLabel.text = actions?.name.rawValue
        }
    }
    
    let dividerLineView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    override func setupView()
    {
        addSubview(nameLabel)
        addSubview(dividerLineView)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = UIColor.blue
        nameLabel.textAlignment = .center
        
        // Constraint nameLabel
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // Constraint dividerLineView
        dividerLineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}



class SettingCell: UICollectionViewCell
{
    override var isHighlighted: Bool
    {
        didSet
        {
            backgroundColor = isHighlighted ? UIColor.darkGray : .white
            nameLabel.textColor = isHighlighted ? UIColor.white : .black
            iconImageView.tintColor = isHighlighted ? UIColor.white : .blue
            
        }
    }
    var setting: Setting?
    {
        didSet
        {
            nameLabel.text = setting?.name.rawValue
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.blue
            }
        }
    }
    
    let nameLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Sort"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sortView")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    func setupView()
    {
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(24)]-10-[v1]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": iconImageView, "v1": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-13-[v0(24)]-13-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": iconImageView]))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}



