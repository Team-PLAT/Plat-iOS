//
//  PlaylistDetailView.swift
//  PLAT
//
//  Created by 박준우 on 9/17/24.
//

import SwiftUI

struct PlaylistDetailView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        // TODO: 뒤로가기 기능 구현
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.backward")
                        }
                        .foregroundStyle(.platPurple)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // TODO: 플레이리스트 편집 기능 추가
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(.platPurple)
                    }
                    .frame(width: 24, height: 24)
                    .background {
                        Circle().fill(Color.gray9)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // TODO: 플레이리스트 삭제 기능 추가
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 12, height: 14)
                        // trash 시스템 이미지는 왜 중간 정렬이 아닐까...
                            .padding(.trailing, 8)
                            .foregroundStyle(.platPurple)
                    }
                    .frame(width: 24, height: 24)
                    .background {
                        Circle().fill(Color.gray9)
                    }
                }
            }
    }
}

#Preview {
    PlaylistDetailView()
}
