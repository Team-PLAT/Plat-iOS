//
//  FeedView.swift
//  PLAT
//
//  Created by 조세연 on 8/14/24.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        ScrollView {
            FeedRowView()
        }
        
    }
}

// MARK: - FeedRowView

private struct FeedRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            FeedProfileImage()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    VStack(alignment:. leading, spacing: 2) {
                        FeedHeaderView()
                        FeedLocation()
                    }
                    .padding(.trailing, 96)
                    
                    FeedActionButton(
                        systemImage: "text.badge.plus",
                        tapGesture: {
                            // 신고 알럿 창 띄우기
                        }
                    )
                }
                .padding(.bottom, 8)
                
                FeedPlayer()
                    .padding(.bottom, 6)
                
                FeedContent(text: "안녕하세요 저는 앵지예요 오늘 날씨가 무척 더워서 쇠맛이 나는 노래를 좀 듣고 싶어가지구 박쥐단지 노래를 틀었는데 2003 꽤나 스껄하네요? 다들 들어보세요 어쩌구 저쩌구... 이런 저런 글들을 올리겠지용 홍홍표정~ 더 보기를 눌렀을 때 작성한 글의 전문이 펼쳐져서 보일 수 있도록 하고싶어욧")
                    .padding(.bottom, 8)
                
                FeedActionView()
            }
        }
    }
}

// MARK: - FeedProfileImage

private struct FeedProfileImage: View {
    var body: some View {
        
        // TODO: trackDetailUseCase.track.platter.profileImageUrl 변경
        AsyncImage(url: URL(string: " ")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
            } else {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

// MARK: - FeedHeaderView

private struct FeedHeaderView: View {
    var body: some View {
        HStack(spacing: 8) {
            // TODO: trackDetailUseCase.track.platter.nickname 변경
            Text("LOREMIPSUM")
                .font(.Body.body2)
                .foregroundStyle(.white)
            
            Circle()
                .frame(width: 2, height: 2)
            
            // TODO: trackDetailUseCase.track.createdDate.monthDayYearFormat 변경
            Text("07/31/2024")
                .font(.Body.body5)
                .foregroundStyle(.white)
            
        }
    }
}

// MARK: - FeedLocation

private struct FeedLocation: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(.imgFeedloacation)
                .resizable()
                .scaledToFill()
                .frame(width: 12, height: 16)
            
            // TODO: trackDetailUseCase.state.place.address 에서 대한민국 경상북도 제거 후 변경
            Text("포항시 남구 지곡동")
                .font(.Body.body5)
                .foregroundStyle(.white)
            
        }
    }
}

// MARK: - FeedPlayer

private struct FeedPlayer: View {
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.platBlack)
                .cornerRadius(8)
                .frame(width: 311, height: 56)
            
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(.clear)
                    .background(
                        FeedAlbumImage()
                    )
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // TODO: trackDetailUseCase.track.music.title 변경
                    Text("2003")
                        .font(.Body.body2)
                        .foregroundStyle(.white)
                        .frame(width: 145, alignment: .leading)
                    
                    // TODO: trackDetailUseCase.track.music.artist 변경
                    Text("김도언")
                        .font(.Body.body4)
                        .foregroundStyle(.gray7)
                        .frame(width: 87, alignment: .leading)
                }
                .padding(.trailing, 70)
                
                Button {
                    isPlaying.toggle()
                    // TODO: trackDetailUseCase.effect 변경
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.gray6)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 12)
                }
            }
            .frame(width: 311, height: 56)
        }
    }
}

// MARK: - FeedAlbumImage

private struct FeedAlbumImage: View {
    var body: some View {
        
        // TODO: trackDetailUseCase.track.music.albumImageUrl 변경
        AsyncImage(url: URL(string: "https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
            } else {
                Rectangle()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

// MARK: - FeedContent

private struct FeedContent: View {
    
    // TODO: trackDetailUseCase.track.content 변경
    private var text: String = "안녕하세요 저는 앵지예요 오늘 날씨가 무척 더워서 쇠맛이 나는 노래를 좀 듣고 싶어가지구 박쥐단지 노래를 틀었는데 2003 꽤나 스껄하네요? 다들 들어보세요 어쩌구 저쩌구... 이런 저런 글들을 올리겠지용 홍홍표정~ 더 보기를 눌렀을 때 작성한 글의 전문이 펼쳐져서 보일 수 있도록 하고싶어욧"
    
    @State private var isLimit: Bool?
    @State private var isExpended: Bool = false
    
    init(text: String) {
        self.text = text
    }
    
    private func calculateLimit() -> some View {
        ViewThatFits(in: .vertical) {
            Text(text)
                .font(.Body.body5)
                .foregroundColor(.white)
                .hidden()
                .onAppear {
                    guard isLimit == nil else { return }
                    isLimit = false
                }
            
            Color.clear
                .hidden()
                .onAppear {
                    guard isLimit == nil else { return }
                    isLimit = true
                }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if isExpended {
                Text(text)
                    .font(.Body.body5)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .background(calculateLimit())
                    .frame(width: 311)
            } else {
                Text(text)
                    .font(.Body.body5)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .background(calculateLimit())
                    .frame(width: 271)
                
                if isLimit == true {
                    Text("더 보기")
                        .foregroundColor(.platPurple)
                        .font(.Body.body5)
                        .padding(.top, 20)
                        .onTapGesture {
                            self.isExpended.toggle()
                        }
                }
            }
        }
    }
}

// MARK: - FeedActionView

private struct FeedActionView: View {
    var body: some View {
        HStack(spacing: 0) {
            FeedActionButton(
                systemImage: "heart.fill",
                tapGesture: {
                    // 좋아요 액션
                }
            )
            .padding(.trailing, 30)
            
            FeedActionButton(
                systemImage: "text.badge.plus",
                tapGesture: {
                    // 플리 추가 액션
                }
            )
            .padding(.trailing, 221)
            
            FeedActionButton(
                systemImage: "repeat",
                tapGesture: {
                    // 연속 재생 액션
                }
            )
        }
    }
}

// MARK: - FeedActionButton

private struct FeedActionButton: View {
    
    let systemImage: String
    let tapGesture: () -> Void
    
    var body: some View {
        Button {
            tapGesture()
        } label: {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    FeedRowView()
}
