//
//  OnboardingView.swift
//  PLAT
//
//  Created by 조우현 on 6/27/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(LoginUseCase.self) private var loginUseCase
    
    var body: some View {
        Text("OnboardingView")
    }
}

#Preview {
    OnboardingView()
}
