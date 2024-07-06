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
        let icon: String
        var isDestructive: Bool
        var tapAction: () -> Void
        
        init(
            title: String,
            content: String = "",
            icon: String = "chevron.right",
            isDestructive: Bool = false,
            tapAction: @escaping () -> Void
        ) {
            self.title = title
            self.content = content
            self.icon = icon
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
                if index != infoList.endIndex {
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
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(info.content)
                    .font(.Body.body5)
                    .foregroundStyle(.white)
                
                Image(systemName: info.icon)
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
            .init(title: "계정 설정", tapAction: {})
        ]
    )
}
