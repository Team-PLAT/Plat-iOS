//
//  AlertActionButton.swift
//  PLAT
//
//  Created by 김민준 on 10/1/24.
//

import SwiftUI

struct AlertActionButton: View {
    
    enum Variant {
        case cancel
        case confim
    }
    
    let variant: Variant
    let action: () -> Void
    
    init(variant: Variant, action: @escaping () -> Void = {}) {
        self.variant = variant
        self.action = action
    }
    
    /// 버튼 제목
    private var titleKey: LocalizedStringKey {
        switch variant {
        case .cancel: return "취소"
        case .confim: return "확인"
        }
    }
    
    /// 버튼 제목
    private var role: ButtonRole? {
        switch variant {
        case .cancel: return .cancel
        case .confim: return .none
        }
    }
    
    var body: some View {
        Button(titleKey, role: role, action: action)
    }
}

#Preview {
    AlertActionButton(variant: .confim)
}
