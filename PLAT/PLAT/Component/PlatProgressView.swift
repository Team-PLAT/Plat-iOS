//
//  PlatProgressView.swift
//  PLAT
//
//  Created by 김민준 on 9/22/24.
//

import SwiftUI

struct PlatProgressView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black.opacity(0.4))
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(.circular)
                .tint(.primary)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PlatProgressView()
}
