//
//  DismissButton.swift
//  PLAT
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - DismissButton

struct DismissButton: View {
    
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 44, height: 44)
                    .opacity(0.0)
                
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 8, height: 8)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DismissButton {}
}
