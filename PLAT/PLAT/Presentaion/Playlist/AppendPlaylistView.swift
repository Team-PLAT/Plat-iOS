//
//  AppendPlaylistView.swift
//  PLAT
//
//  Created by 박준우 on 9/16/24.
//

import SwiftUI

struct AppendPlaylistView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPhotoAlbumSheet = false
    @State private var playlistImage: UIImage?
    @State private var playlistTitle: String = ""
    
    var body: some View {
        VStack {
            AppendPlaylistButton(isPhotoAlbumSheet: $isPhotoAlbumSheet, playlistImage: $playlistImage)
                .sheet(isPresented: $isPhotoAlbumSheet) {
                    PhotoPicker(selectedImage: $playlistImage)
                }
            
            AppendPlaylistTitle(playlistTitle: $playlistTitle)
            
            AppendPlaylistDate()
            
            Spacer()
        }
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
        .presentationDragIndicator(.visible)
    }
}

// MARK: - AppendPlaylistButton

private struct AppendPlaylistButton: View {
    @Binding private(set) var isPhotoAlbumSheet: Bool
    @Binding private(set) var playlistImage: UIImage?
    
    var body: some View {
        Button {
            isPhotoAlbumSheet = true
        } label: {
            if let image = playlistImage {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .aspectRatio(1, contentMode: .fit)
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.gray9)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .foregroundStyle(.platPurple)
                            .background {
                                Circle()
                                    .foregroundStyle(.white)
                                    .padding(1)
                            }
                            .padding(80)
                    }
            }
        }
        .padding(EdgeInsets(top: 35, leading: 86, bottom: 16, trailing: 86))
    }
}

// MARK: - AppendPlaylistTitle

private struct AppendPlaylistTitle: View {
    @Binding private(set) var playlistTitle: String
    
    var body: some View {
        TextField("", text: $playlistTitle, prompt: Text("플레이리스트 제목")
            .foregroundStyle(.gray9)
            .font(.Head.head2))
        .font(.Head.head2)
        .tint(.platPurple)
        .multilineTextAlignment(.center)
        
        Divider()
            .frame(height: 1)
            .background {
                Color.gray9
            }
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 8, trailing: 18))
    }
}

// MARK: - AppendPlaylistDate

private struct AppendPlaylistDate: View {
    
    var body: some View {
        HStack {
            Text("생성일자")
            Spacer()
            // TODO: 생성일자 서버 기준으로 표시하기
            Text("2024.08.17")
        }
        .foregroundStyle(.gray7)
        .font(.Body.body1)
        .padding(.horizontal, 18)
    }
}

#Preview {
    AppendPlaylistView()
}
