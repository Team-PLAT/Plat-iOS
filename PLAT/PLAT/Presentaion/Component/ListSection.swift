//
//  ListSection.swift
//  PLAT
//
//  Created by 조우현 on 7/6/24.
//

import SwiftUI

struct ListSection: View {
    
    struct Info: Identifiable {
        let id = UUID()
        let title: String
        let content: String
        let icon: ImageResource
        var streamAccount: StreamAccount?
        var isDestructive: Bool
        var tapAction: () -> Void
        
        init(
            title: String,
            content: String = "",
            icon: ImageResource = .icnChevronRight,
            streamAccount: StreamAccount? = nil,
            isDestructive: Bool = false,
            tapAction: @escaping () -> Void
        ) {
            self.title = title
            self.content = content
            self.icon = icon
            self.streamAccount = streamAccount
            self.isDestructive = isDestructive
            self.tapAction = tapAction
        }
    }
    
    let infoList: [Info]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(
                Array(infoList.enumerated()),
                id: \.offset
            ) { index, info in
                ListCell(info: info)
                if index != infoList.endIndex.advanced(by: -1) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray9)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(.gray9, lineWidth: 1)
        )
        .padding(.horizontal, 18)
    }
}

// MARK: - ListCell

private struct ListCell: View {
    
    var info: ListSection.Info
    
    var body: some View {
        Button {
            info.tapAction()
        } label: {
            HStack {
                Text(info.title)
                    .font(.Body.body2)
                    .foregroundStyle(info.isDestructive ? .red : .white)
                
                Spacer()
                
                if let streamAccount = info.streamAccount {
                    Image(streamAccount.icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                } else {
                    Text(info.content)
                        .font(.Body.body5)
                        .foregroundStyle(.white)
                }
                
                Image(info.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray7)
            }
            .padding(.horizontal, 24)
            .frame(height: 64)
        }
    }
}

#Preview {
    ListSection(
        infoList: [
            .init(title: "닉네임", content: "IPSUM_LOREM", tapAction: {}),
            .init(title: "계정 설정", tapAction: {}),
            .init(title: "연동된 스트리밍 계정", streamAccount: .appleMusic, tapAction: {}),
            .init(title: "연동된 스트리밍 계정", icon: .icnWeblink, streamAccount: .appleMusic, tapAction: {})
        ]
    )
}
