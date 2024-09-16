//
//  PlaylistDetailsView.swift
//  PLAT
//
//  Created by crownjoe on 9/16/24.
//

import SwiftUI

struct PlaylistDetailsView: View {
    var body: some View {
        VStack(spacing: 0) {
            PlayListEditButton()
            PlayListInfo()
                .padding(.bottom, 10)
            PlayListPlayButton()
                .padding(.bottom, 10)
            PlayListDetailView()
            PlayListRowView()
            PlayListRowView()
            PlayListRowView()
            PlayListRowView()
            PlayListRowView()
            PlayListRowView()
        }
    }
}

private struct PlayListEditButton: View {
    var body: some View {
        HStack(spacing: 12) {
            Button {
                // TODO: 수정
            } label: {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray9)
                    .overlay {
                        Image(systemName: SystemImage.pencil)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.platPurple)
                    }
            }
            
            Button {
                // TODO: 삭제
            } label: {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray9)
                    .overlay {
                        Image(systemName: SystemImage.trash)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.platPurple)
                    }
            }
        }
    }
}

private struct PlayListInfo: View {
    
    private var playlistImageUrl: URL? {
        //        URL(string: )
        URL(string: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1")
    }
    
    var body: some View {
        VStack( alignment: .center, spacing: 0) {
            AsyncImage(url: playlistImageUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: 220, height: 220)
                        .foregroundStyle(.gray9)
                }
            }
            .padding(.bottom, 16)
            
            Text("지곡동에서의 PLAT")
                .font(.Head.head2)
                .foregroundStyle(.white)
                .frame(width: 213, height: 44, alignment: .center)
                .padding(.bottom, -12)
            
            Text("2024.07.14")
                .font(.Body.body1)
                .foregroundStyle(.gray7)
                .frame(width: 160, height: 44, alignment: .center)
            
        }
    }
}

private struct PlayListPlayButton: View {
    var body: some View {
        HStack(spacing: 27) {
            Button {
                // TODO: 재생
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 165, height: 44)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemName: SystemImage.play)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.platPurple)
                            
                            Text("재생")
                                .font(.Body.body2)
                                .foregroundStyle(.platPurple)
                        }
                    }
            }
            
            Button {
                // TODO: 임의재생
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 165, height: 44)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemName: SystemImage.shuffle)
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.platPurple)
                            
                            Text("임의재생")
                                .font(.Body.body2)
                                .foregroundStyle(.platPurple)
                        }
                    }
            }
            
        }
    }
}

private struct PlayListDetailView: View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(spacing: 6) {
                // TODO: 곡 + 분 처리
                Text("13곡")
                    .font(.Body.body5)
                    .foregroundStyle(.white)
                
                Circle()
                    .frame(width: 2, height: 2)
                    .foregroundColor(.gray9)
                
                Text("42분")
                    .font(.Body.body5)
                    .foregroundStyle(.white)
            }
            .padding(.trailing, 18)
            .padding(.bottom, 9)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
        }
    }
}

private struct PlayListRowView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                AlbumImage()
                    .padding(.trailing, 10)
                
                TrackInfo()
                    .padding(.trailing, 40)
                
                Image(systemName: SystemImage.moreDetail)
                    .foregroundStyle(.white)
                    .rotationEffect(Angle(degrees: -90))
            }
            .padding(.bottom, 10)
            .padding(.top, 8)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray9)
                .padding(.leading, 46)
        }
    }
}

private struct AlbumImage: View {
    
    private var albumImageUrl: URL? {
        //        URL(string: )
        URL(string: "https://stickershop.line-scdn.net/stickershop/v1/product/26725647/LINEStorePC/main.png?v=1")
    }
    
    var body: some View {
        AsyncImage(url: albumImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

private struct TrackInfo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("너답기기안 (너의 답장을 기다리다가... ")
                .font(.Body.body3)
                .foregroundStyle(.white)
            
            HStack(spacing: 8) {
                Text("미노이")
                    .font(.Body.body5)
                    .foregroundStyle(.gray7)
                
                Circle()
                    .frame(width: 2, height: 2)
                    .foregroundColor(.gray7)
                
                // TODO: 분기처리 및 유저 이름 + 의 트랙
                Text("LoremLorem의 트랙")
                    .font(.Body.body5)
                    .foregroundStyle(.gray7)
            }
        }
        .frame(width: 238)
    }
}

#Preview {
    PlaylistDetailsView()
}
