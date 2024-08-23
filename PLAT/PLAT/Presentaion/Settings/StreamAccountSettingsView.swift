//
//  StreamAccountSettingsView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

struct StreamAccountSettingsView: View {
    
    @Environment(UserUseCase.self) private var userUseCase
    @Environment(StreamAccountUseCase.self) private var streamAccountUseCase
    
    /// 현재 연결된 스트리밍 계정을 확인후 타이틀 텍스트를 반환합니다.
    func connectTitleText(_ stream: StreamAccount) -> String {
        if userUseCase.state.user.streamAccount == stream {
            return " 연결됨"
        } else {
            return " 연결하기"
        }
    }
    
    /// 현재 연결된 스트리밍 계정을 확인후 콘텐트 텍스트를 반환합니다.
    func connectContentText(_ stream: StreamAccount) -> String {
        if userUseCase.state.user.streamAccount == stream {
            return " 스트리밍 계정과 연결되어 있어요"
        } else {
            return " 스트리밍 계정과 연결할 수 있어요"
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ListRadioButton(
                state: .radio,
                title: StreamAccount.appleMusic.rawValue + connectTitleText(.appleMusic),
                content: StreamAccount.appleMusic.rawValue + connectContentText(.appleMusic),
                icon: .icnAppleMusic,
                isSelected: userUseCase.state.user.streamAccount == .appleMusic,
                tapAction: {
                    streamAccountUseCase.connect(streamAccount: .appleMusic)
                }
            )
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 18)
        .navigationTitle("연결된 스트리밍 계정")
        .navigationBarTitleDisplayMode(.inline)
        .background(.platBackground)

    }
}

#Preview {
    StreamAccountSettingsView()
        .environment(PreviewHelper.mockUserUseCase)
        .environment(PreviewHelper.mockStreamAccountUseCase)
}
