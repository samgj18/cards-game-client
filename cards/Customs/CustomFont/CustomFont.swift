//
//  CustomFont.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import SwiftUI

struct AppFont {
    static func commonFont(fontSize: CGFloat) -> Font {
        return Font.custom("Mulish-Regular", size: fontSize)
    }
}
