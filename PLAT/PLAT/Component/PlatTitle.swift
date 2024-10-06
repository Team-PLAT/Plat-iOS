//
//  PlatTitle.swift
//  PLAT
//
//  Created by 김민준 on 10/1/24.
//

import SwiftUI

struct PlatTitle: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.Head.head2)
                .multilineTextAlignment(.leading)
                .lineSpacing(8)
            
            Spacer()
        }
    }
}

#Preview {
    PlatTitle(title: "타이틀 텍스트")
}
