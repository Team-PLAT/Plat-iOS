//
//  Helper+RoundedCorner.swift
//  PLAT
//
//  Created by 조세연 on 8/15/24.
//

import SwiftUI

// 특정 모서리만 radius를 주고 싶을 때 사용하는 extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> SwiftUI.Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return SwiftUI.Path(path.cgPath)
    }
}
