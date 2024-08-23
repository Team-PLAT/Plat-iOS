//
//  TrackAppendSearchView.swift
//  PLAT
//
//  Created by 박준우 on 8/20/24.
//

import SwiftUI
import MusicKit

struct TrackAppendSearchView: View {
    @Binding var isTrackAppendViewSheet: Bool
    @State private var trackAppendUseCase: TrackAppendUseCase = .init(trackAppendService: StubTrackAppendService())
    @State private var searchTimer: Timer?
    @State private var searchTerm = ""
    @State private var musicList: [Music] = []
    @State private var pathModel: PathModel = .init()
    @State private var selectedMusic: Music = Music(isrc: "", title: "", artist: "", albumImageUrl: "", duration: 0)
    @Binding var detent: PresentationDetent
    
    var body: some View {
        NavigationStack(path: $pathModel.trackAppendPaths) {
            if #available(iOS 17.1, *) {
                VStack {
                    
                    TrackAppendRecentTermView()
                        .environment(pathModel)
                        
                    Spacer()
                    
                    TrackAppendMusicListView(musicList: $musicList, selectedMusic: $selectedMusic)
                        .environment(pathModel)
                    
                }
                .navigationDestination(for: TrackAppendPath.self) { path in
                    switch path {
                    case .trackAppendContentView:
                        TrackAppendContentView(detent: $detent, music: $selectedMusic, isTrackAppendViewSheet: $isTrackAppendViewSheet)
                    }
                }
                .onAppear {
                    Task {
                        let status = await MusicAuthorization.request()
                        print(status == .authorized)
                    }
                    UISearchBar.appearance().showsCancelButton = false
                    detent = .large
                    searchTerm = ""
                }
                .onChange(of: searchTerm) {
                    searchTimer?.invalidate()
                    searchTimer = nil
                    
                    self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                        if searchTerm != "" {
                            print("검색중")
                            Task {
                                musicList = await trackAppendUseCase.searchMusic(term: searchTerm)
                            }
                        } else {
                            print("검색불가")
                        }
                    }
                }
                // TODO: 상위 컴포넌트에 넣으면 searchable의 X 버튼이 작동을 안함, 여기서는 작동은 하지만 NaivigationTitle부분에서는 키보드 내리기가 작동 안함
                // TODO: ContentView로 넘어갔을 때, back button title 변경되도록 하는 로직(뒤로 가기 했을 때 버퍼링 있음)
                .navigationTitle(pathModel.trackAppendPaths.isEmpty ? "검색" : "음악 선택")
                .tapDismissesKeyboard()
                .searchable(text: $searchTerm, prompt: "아티스트, 노래, 가사 등")
                // TODO: iOS 17.1 이상만 가능해서 그 이전 버전도 지원되게 해야함
                .searchPresentationToolbarBehavior(.avoidHidingContent)
                
            } else {
                
            }
            
        }
    }
}

private struct TrackAppendRecentTermView: View {
    var recentSearchTermList = ["2003", "Sunset Rollercoaster", "Aqua Man", "Snow Man", "2024", "small girl"]
    @Environment(PathModel.self) var pathModel
    
    var body: some View {
        HStack {
            Text("최근 검색어")
                .font(.Body.body3)
                .foregroundStyle(.gray7)
                .padding(.leading, 18)
            Spacer()
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                // TODO: 최근 검색어 기능 연결
                ForEach(recentSearchTermList, id: \.self) { term in
                    HStack(spacing: 8) {
                        Text(term)
                            .font(.Body.body5)
                            .padding(.leading, 12)
                        Button {
                            // TODO: 최근 검색어 삭제 기능 추가
                            pathModel.trackAppendPaths.append(.trackAppendContentView)
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.gray7)
                                .padding(.trailing, 8)
                        }
                    }
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.gray9)
                    )
                    .fixedSize()
                }
            }
            .padding(.leading, 18)
        }
        .frame(height: 32)
    }
}

private struct TrackAppendMusicListView: View {
    @Environment(PathModel.self) var pathModel
    @Binding var musicList: [Music]
    @Binding var selectedMusic: Music
    
    var body: some View {
        List($musicList, id: \.self.isrc) { music in
            HStack {
                // TODO: 이미지 캐싱 필요할 것 같습니다.
                AsyncImage(url: URL(string: music.albumImageUrl.wrappedValue)) { image in
                    image.image?
                        .resizable()
                        .frame(width: 72, height: 72)
                        .cornerRadius(4, corners: .allCorners)
                }
                VStack(alignment: .leading) {
                    Text("\(music.title.wrappedValue)")
                        .font(.Body.body3)
                    Text("\(music.artist.wrappedValue)")
                        .font(.Caption.caption1)
                }
                
                Spacer()
                
                // TODO: Button으로 했더니 Row 전체가 터치 영역이 돼서 onTapGesture로 변경
                Image(systemName: "plus.circle")
                    .foregroundStyle(.gray8)
                    .onTapGesture {
                        print("\(music.title.wrappedValue)")
                        pathModel.trackAppendPaths.append(.trackAppendContentView)
                        selectedMusic = music.wrappedValue
                    }

            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

extension View {
    func tapDismissesKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    TrackAppendSearchView(
        isTrackAppendViewSheet: .constant(false),
        detent: .constant(.medium)
    )
}
