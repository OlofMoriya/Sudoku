//
//  Style.swift
//  Sudoku
//
//  Created by Olof Olsson on 31/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

struct Colors{
    static var mainColor = UIColor(red: 70.0/255.0, green: 146.0/255.0, blue: 135.0/255.0, alpha: 1)
    static var defaultTint = UIColor.whiteColor()
    static var gray = UIColor.darkGrayColor()
}

class Style {
    
    static func setAppStyle(){
        UINavigationBar.appearance().barTintColor = Colors.mainColor
        UIButton.appearance().tintColor = Colors.mainColor
        UISearchBar.appearance().tintColor = Colors.defaultTint
        UINavigationBar.appearance().tintColor = Colors.defaultTint
        
    }
    
}
