//
//  LocationNameTip.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 30/04/2024.
//

import Foundation
import TipKit

struct LocationNameTip: Tip {
    var title: Text {
        Text("Reverse searched location name")
    }
    
    var message: Text? {
        Text("No name was present from the source, so I've looked it up for you. ✨")
    }
    
    var image: Image? {
        Image(systemName: "wand.and.stars")
    }
}
