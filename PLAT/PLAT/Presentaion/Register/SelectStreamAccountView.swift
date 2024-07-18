//
//  SelectStreamAccountView.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import SwiftUI

struct SelectStreamAccountView: View {
    
    enum SelectedState {
        case none
        case appleMusic
        case spotify
    }
    
    @State var selectedState: SelectedState = .none
    @State var isSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            Text("사용하는 음악 플랫폼을\n선택해주세요")
                .font(.Head.head2)
                .padding(.trailing, 144)
                .padding(.top, 32)
                .padding(.bottom, 32)
            
            Group {
                
                ListRadioButton(state: .none, title: "\(StreamAccount.appleMusic.rawValue) 연결하기", content: "선택하면 \(StreamAccount.appleMusic.rawValue)과 연결돼요", icon: .appleMusic, isSelected: selectedState == .appleMusic) {
                    
                    selectedState = .appleMusic
                }
                
                ListRadioButton(state: .none, title: "\(StreamAccount.spotify.rawValue) 연결하기", content: "선택하면 \(StreamAccount.spotify.rawValue)로 연결돼요", icon: .spotify, isSelected: selectedState == .spotify) {
                    
                    selectedState = .spotify
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.gray9)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 32)
            
            Spacer()
            
            Divider()
                .frame(height: 2)
                .background(.white)
                .padding(.horizontal, 38)
                .padding(.bottom)
            
            Button(action: {
                isSheetPresented.toggle()
                print("왜 스트리밍 계정을 연결하나요?")
            }, label: {
                Text("왜 스트리밍 계정을 연결하나요?")
                    .font(.Body.body4)
                    .underline()
            })
            .padding(.horizontal, 108)
            .padding(.bottom)
        }
        .foregroundStyle(.white)
        .background(.platBackground)
        .sheet(isPresented: $isSheetPresented, content: {
            WhyConnectStreamAccountSheet()
        })
    }
}

// MARK: WhyConnectStreamAccountSheet

private struct WhyConnectStreamAccountSheet: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("왜 스트리밍 계정을 연결하나요?")
                .font(.Head.head4)
                .padding(.top, 42)
                .padding(.bottom, 16)
            
            Text("스트리밍 서비스는 PLAT의 가장 중요한 음원 재생을 위해 사용됩니다. 계정을 연결하면, 지인과 친구들이 공유한 음원들을 직접 PLAT을 통해 들을 수 있으며, 그 외에도 다양한 기능들을 제공하게 됩니다. 그리고 이를 통해 더 많은 아티스트들을 지원할 수 있게 됩니다.")
                .font(.Caption.caption1)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(.platBlack)
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    SelectStreamAccountView()
}
