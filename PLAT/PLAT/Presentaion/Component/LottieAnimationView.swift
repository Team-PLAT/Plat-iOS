//
//  LottieAnimationView.swift
//  PLAT
//
//  Created by 박준우 on 7/14/24.
//

import SwiftUI
import Lottie

struct LottieAnimationView: View {
    
    let lottieName: String
    let lottieSpeed: Double
    
    var body: some View {
        LottieView(animation: .named(lottieName))
            .looping()
            .animationSpeed(lottieSpeed)
    }
}
