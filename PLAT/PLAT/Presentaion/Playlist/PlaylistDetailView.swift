//
//  PlaylistDetailView.swift
//  PLAT
//
//  Created by 박준우 on 9/17/24.
//

import SwiftUI

struct PlaylistDetailView: View {
    
    @Binding private(set) var selectedPlaylist: Playlist
    
    var body: some View {
        VStack(spacing: 0) {
            
            PlaylistDetailDataView(selectedPlaylist: $selectedPlaylist)
            
            PlaylistDetailPlayButton()
            
            Divider()
                .frame(height: 1)
                .background(.gray9)
            
            PlaylistDetailNewTrackButton()
            
            Spacer()
        }
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
                    Circle().fill(.gray9)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // TODO: 플레이리스트 삭제 기능 추가
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 12, height: 14)
                        .padding(.trailing, 8)
                        .foregroundStyle(.platPurple)
                }
                .frame(width: 24, height: 24)
                .background {
                    Circle().fill(.gray9)
                }
            }
        }
    }
}

// MARK: - PlaylistDetailDataView

private struct PlaylistDetailDataView: View {
    
    @Binding private(set) var selectedPlaylist: Playlist
    
    var body: some View {
        AsyncImage(url: URL(string: selectedPlaylist.imageUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(LinearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(EdgeInsets(top: 8, leading: 86, bottom: 16, trailing: 86))
        
        Text(selectedPlaylist.title)
            .font(.Head.head2)
            .padding(.bottom, 8)
        
        Text(selectedPlaylist.createdDate.yearMonthDayFormat)
            .foregroundStyle(.gray7)
            .font(.Body.body1)
    }
}

// MARK: - PlaylistDetailPlayButton

private struct PlaylistDetailPlayButton: View {
    
    var body: some View {
        HStack(spacing: 26) {
            Button {
                // TODO: 재생 기능 구현
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("재생")
                        }
                    }
            }
            
            Button {
                // TODO: 임의재생 기능 구현
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("임의재생")
                        }
                    }
            }
        }
        .frame(height: 44)
        .foregroundStyle(.platPurple)
        .font(.Body.body2)
        .padding(EdgeInsets(top: 24, leading: 18, bottom: 40, trailing: 18))
    }
}

// MARK: - PlaylistDetailNewTrackButton

private struct PlaylistDetailNewTrackButton: View {
    
    var body: some View {
        // TODO: 클릭 범위를 HStack으로 할지, + 버튼으로 할지 기획 논의 필요
        HStack(spacing: 10) {
            Button {
                // TODO: 새로운 트랙 생성 버튼 기능 구현
            } label: {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(.platBlack)
                    .overlay {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(.platPurple)
                            .padding(12)
                    }
            }
            .frame(width: 40, height: 40)
            
            Text("새로운 트랙 생성")
                .font(.Body.body2)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 18, bottom: 0, trailing: 18))
    }
}

#Preview {
    PlaylistDetailView(selectedPlaylist: .constant(MockDataBuilder.playlist))
}
