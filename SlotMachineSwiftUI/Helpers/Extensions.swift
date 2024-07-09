//
//  Extensions.swift
//  SlotMachineSwiftUI
//
//  Created by Khavishini on 09/07/2024.
//

import SwiftUI

extension Text {
    func scoreLabelStyle() -> Text {
        self
            .foregroundColor(.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text {
        self.foregroundColor(.white)
            .font(.system(.title, design: .rounded, weight: .heavy))
    }
}
