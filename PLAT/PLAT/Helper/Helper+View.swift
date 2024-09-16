//
//  Helper+View.swift
//  PLAT
//
//  Created by 박준우 on 9/15/24.
//

import SwiftUI

extension View {
    
    // 화면 터치 시, 키보드 내려가게 하는 뷰 모디파이어
    func tapDismissesKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
