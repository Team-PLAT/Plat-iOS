//
//  PlattingView.swift
//  PLAT
//
//  Created by 박준우 on 8/18/24.
//

import SwiftUI

struct PlattingView: View {
    @State var isCompleteLoading = false
    @Binding var playList: Playlist?
    
    var body: some View {
        VStack {
            PlattingDismissButton()
            Spacer()
            if isCompleteLoading {
                if let playlist = playList {
                    PlattingPlayListView(playList: playlist)
                } else {
                    Text("No playlist available")
                }
            } else {
                if let trackList = playList?.trackList {
                    PlattingLoadingView(trackList: trackList)
                } else {
                    Text("Loading failed")
                }
            }
        }
        
        // TODO: 플래팅로딩뷰에서 플래팅플레이리스트뷰로 넘어가는 로직 구현하기
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                isCompleteLoading = true
            }
        }
    }
}

// MARK: - PlattingDismissButton

private struct PlattingDismissButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        HStack {
            Spacer()
            DismissButton {
                // TODO: 만들어진 플레이리스트 인스턴스 삭제 필요?
                dismiss()
            }
        }
    }
}

// MARK: - PlattingLoadingView

private struct PlattingLoadingView: View {
    var trackList: [Track]
    var body: some View {
        VStack {
            // TODO: 트랙들의 이미지 그리는 로직 추가하기
            ForEach(trackList) { list in
                if let imgUrl = list.imageUrl {
                    AsyncImage(url: URL(string: imgUrl)) { img in
                        if let image = img.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                        }
                    }
                }
            }
            Spacer()
            Text("Platting...")
                .font(.Head.head3)
                .padding(.bottom, 104)
        }
    }
}

// MARK: - PlattingPlayListView

private struct PlattingPlayListView: View {
    var playList: Playlist
    
    var body: some View {
        VStack {
            // TODO: 플레이리스트 기본 이미지 설정하기
            AsyncImage(url: URL(string: playList.imageUrl)) { img in
                if let image = img.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.horizontal, 86)
                        .padding(.bottom)
                    
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.linearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.horizontal, 86)
                        .padding(.bottom)
                }
            }
            
            // TODO: 사용자의 위치 명칭 받아오기(ex. 지곡동)
            Text("지곡동에서의 PLAT")
                .font(.Head.head2)
                .padding(.bottom, 4)
            
            Text("\(playList.createdDate.yearMonthDayFormat)")
                .font(.Body.body1)
                .foregroundStyle(.gray7)
                .padding(.bottom)
            
            PlattingPlayListButton()
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray9)
                .padding(.top, 40)
            
            PlattingPlayList(trackList: playList.trackList)
        }
    }
}

// MARK: - PlattingPlayListButton

private struct PlattingPlayListButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 26) {
            Group {
                Button {
                    // TODO: 플레이리스트 재생 기능 추가
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray9)
                        .overlay {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("재생")
                            }
                        }
                }
                Button {
                    // TODO: 플레이리스트 저장 기능 추가
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray9)
                        .overlay {
                            HStack {
                                // TODO: 이미지 바꾸기
                                Image(systemName: "music.note")
                                Text("플레이리스트 저장")
                            }
                        }
                }
            }
            .frame(height: 44)
            .font(.Body.body2)
        }
        .padding(.horizontal, 18)
    }
}

// MARK: - PlattingPlayList

private struct PlattingPlayList: View {
    var trackList: [Track]
    
    var body: some View {
        List(trackList) { track in
            VStack(alignment: .leading) {
                HStack {
                    // TODO: 음원 이미지가 없을 때 기본 이미지 설정하기
                    if let imgUrl = track.imageUrl {
                        AsyncImage(url: URL(string: imgUrl)) { img in
                            if let image = img.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("\(track.music.title)")
                            .font(.Body.body3)
                        Text("\(track.music.artist)・ \(track.platter.nickname)의 트랙")
                            .font(.Body.body5)
                            .foregroundStyle(.gray7)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparatorTint(.gray9)
            .listRowInsets(EdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 0))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    PlattingView(playList: .constant(MockDataBuilder.playlist))
}
