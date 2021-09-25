//
//  CustomCorner.swift
//  InfiniteCarouselSlider (iOS)
//
//  Created by Michele Manniello on 25/09/21.
//

import SwiftUI

// Custom Corner Shape...
struct CustomCorner: Shape {
    
    var corners : UIRectCorner
    var radius : CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

