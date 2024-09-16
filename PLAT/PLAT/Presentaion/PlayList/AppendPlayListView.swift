//
//  AppendPlayListView.swift
//  PLAT
//
//  Created by 박준우 on 9/16/24.
//

import SwiftUI

struct AppendPlayListView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
                .navigationTitle("새로운 플레이리스트")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 3) {
                                Image(systemName: "chevron.backward")
                                Text("취소")
                                    .font(.Body.body2)
                            }
                            .foregroundStyle(.platPurple)
                        }
                        
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            // TODO: 플레이 생성하기 기능 추가
                        } label: {
                            Text("생성")
                                .foregroundStyle(.platPurple)
                                .font(.Body.body2)
                        }
                    }
                }
        }
    }
}

#Preview {
    AppendPlayListView()
}
