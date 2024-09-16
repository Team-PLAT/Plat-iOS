//
//  AppendPlayListView.swift
//  PLAT
//
//  Created by 박준우 on 9/16/24.
//

import SwiftUI

struct AppendPlayListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPhotoAlbumSheet = false
    @State private var playListImage: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    isPhotoAlbumSheet = true
                } label: {
                    if let image = playListImage {
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
                .sheet(isPresented: $isPhotoAlbumSheet) {
                    PhotoPicker(selectedImage: $playListImage)
                }
                
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
        }
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    AppendPlayListView()
}
