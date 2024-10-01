//
//  SelectStreamAccountView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

// MARK: - SelectStreamAccountView

struct SelectStreamAccountView: View {
    
    enum SelectedState {
        case none
        case appleMusic
    }
    
    @Environment(PathModel.self) private var pathModel
    @Environment(AuthUseCase.self) private var authUseCase
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    
    @State private var selectedState: SelectedState = .none
    @State private var isShowingOffer = false
    @State private var isConnectFailedAlertPresented = false
    
    /// 애플 뮤직 셀을 탭했을 때 액션입니다.
    private func appleMusicTapAction() {
        Task {
            do {
                try await musicControlUseCase.requestSubscription()
                if musicControlUseCase.state.isAuthorized {
                    selectedState = .appleMusic
                } else {
                    isShowingOffer.toggle()
                }
            } catch {
                isConnectFailedAlertPresented.toggle()
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            PlatTitle(title: "사용하는 음악 플랫폼을\n선택해주세요")
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            
            ListRadioButton(
                state: .none,
                title: "\(StreamAccount.appleMusic.title) 연결하기",
                content: "선택하면 \(StreamAccount.appleMusic.title)과 연결돼요",
                icon: .icnAppleMusic,
                isSelected: selectedState == .appleMusic,
                tapAction: { appleMusicTapAction() }
            )
            .musicSubscriptionOffer(isPresented: $isShowingOffer)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.gray9)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 16)
            
            Spacer()
            
            Button {
                pathModel.presentSheet(.whyConnectStreamAccount)
            } label: {
                Text("왜 스트리밍 계정을 연결하나요?")
                    .font(.Body.body4)
                    .underline()
            }
            .padding(.bottom, 24)
            
            ActionButton(state: musicControlUseCase.state.isAuthorized ? .enabled : .disabled, title: "시작하기") {
                pathModel.popToRoot()
                authUseCase.updateIsLoginComplete(true)
            }
            .disabled(!musicControlUseCase.state.isAuthorized)
            .padding(.horizontal, 18)
            .padding(.bottom, 30)
        }
        .foregroundStyle(.white)
        .background(.platBackground)
        .navigationTitle("스트리밍 계정 선택하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .overlay(
            musicControlUseCase.state.isLoading
            ? AnyView(PlatProgressView()) : AnyView(EmptyView())
        )
        .alert("일시적인 오류로 계정 연결에 실패했습니다. 다시 시도해주세요.", isPresented: $isConnectFailedAlertPresented) {
            AlertActionButton(variant: .confim)
        }
    }
}

// MARK: - WhyConnectStreamAccountSheet

struct WhyConnectStreamAccountSheet: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("왜 스트리밍 계정을 연결하나요?")
                .font(.Head.head4)
                .padding(.top, 42)
                .padding(.bottom, 16)
            
            Text("스트리밍 서비스는 \(Constant.appName)의 가장 중요한 음원 재생을 위해 사용됩니다. 계정을 연결하면, 지인과 친구들이 공유한 음원들을 직접 PLAT을 통해 들을 수 있으며, 그 외에도 다양한 기능들을 제공하게 됩니다. 그리고 이를 통해 더 많은 아티스트들을 지원할 수 있게 됩니다.")
                .font(.Caption.caption1)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(.platBlack)
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview {
    SelectStreamAccountView()
        .injectDIContainer()
}
