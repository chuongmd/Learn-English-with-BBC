//
//  Setting.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import UIKit
import Foundation

class Setting: NSObject
{
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String)
    {
        self.name = name
        self.imageName = imageName
    }
}
