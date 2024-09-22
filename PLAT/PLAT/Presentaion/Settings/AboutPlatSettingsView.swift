//
//  AboutPlatSettingsView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

// MARK: - AboutPlatSettingsView

struct AboutPlatSettingsView: View {
    
    @Environment(InfoUseCase.self) private var infoUseCase
    
    var privacyPolicyInfo: ListSection.Info {
        return ListSection.Info(title: "개인정보 보호 정책", icon: .imgWeblink) {
            infoUseCase.checkPrivacyPolicy()
        }
    }
    
    var termsOfServiceInfo: ListSection.Info {
        return ListSection.Info(title: "서비스 이용 약관", icon: .imgWeblink) {
            infoUseCase.checkTermsOfService()
        }
    }
    
    var body: some View {
        VStack {
            ListSection(infoList: [privacyPolicyInfo, termsOfServiceInfo])
            Spacer()
        }
        .padding(.top, 24)
        .navigationTitle("About \(Constant.appName)")
        .navigationBarTitleDisplayMode(.inline)
        .background(.platBackground)
    }
}

// MARK: - Preview

#Preview {
    AboutPlatSettingsView()
        .environment(PreviewHelper.mockInfoUseCase)
}
