//
//  TrackAppendSearchSheet.swift
//  PLAT
//
//  Created by 박준우 on 8/20/24.
//

import SwiftUI
import MusicKit

// MARK: - TrackAppendSearchSheet

struct TrackAppendSearchSheet: View {
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackAppendUseCase.self) private var trackAppendUseCase

    @State private var searchTimer: Timer?
    @State private var searchTerm = ""
    @State private var musicList: [Music] = []
    @State private var recentSearchTermList: [String] = []
    
    var body: some View {
        VStack {
            TrackAppendSearchbar(searchTerm: $searchTerm)
            
            TrackAppendRecentTerm(trackAppendUseCase: $trackAppendUseCase, searchTerm: $searchTerm, recentSearchTermList: $recentSearchTermList)
            
            Spacer()
            
            TrackAppendMusicList(musicList: $musicList, selectedMusic: $selectedMusic)
        }
        .tint(.white)
        .presentationDragIndicator(.visible)
        .presentationDetents([.large])
        // TODO: ContentSheet로 넘어갔을 때, back button title 변경되도록 하는 로직(뒤로 가기 했을 때 버퍼링 있음)
        // .navigationTitle(pathModel.trackAppendPaths.isEmpty ? "검색" : "음악 선택")
//        .navigationDestination(for: TrackAppendPath.self) { path in
//            switch path {
//            case .trackAppendContentView:
//                TrackAppendContentView(detent: $detent, music: $selectedMusic, isTrackAppendViewSheet: $isTrackAppendViewSheet)
//            }
//        }
        .onAppear {
            Task {
                let status = await MusicAuthorization.request()
            }
            UISearchBar.appearance().showsCancelButton = false
            // detent = .large
            searchTerm = ""
            recentSearchTermList = trackAppendUseCase.fetchRecentSearchTermList()
        }
        .onDisappear {
            searchTerm = ""
            musicList = []
        }
        .onChange(of: searchTerm) {
            searchTimer?.invalidate()
            searchTimer = nil
            
            self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
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
        .onSubmit {
            trackAppendUseCase.updateRecentSearchTermList(searchTerm: searchTerm)
            recentSearchTermList = trackAppendUseCase.fetchRecentSearchTermList()
        }
        .scrollDismissesKeyboard(.immediately)
        .tapDismissesKeyboard()
    }
}

// MARK: - TrackAppendSearchbar

private struct TrackAppendSearchbar: View {
    @Binding var searchTerm: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray8)
                .padding(.leading, 10)
            
            TextField("", text: $searchTerm, prompt: Text("아티스트, 노래, 가사 등").foregroundStyle(.gray8).font(.Body.body3))
                .foregroundStyle(.white)
                .tint(.platPurple)
            
            Spacer()
            
            if !searchTerm.isEmpty {
                Button {
                    searchTerm = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray8)
                        .padding(.leading, 10)
                }
                .padding(.trailing, 10)
            }
        }
        .frame(height: 42)
        .background {
            RoundedRectangle(cornerRadius: 8).fill(.gray9)
        }
        .padding(EdgeInsets(top: 10, leading: 18, bottom: 8, trailing: 18))
    }
}

// MARK: - TrackAppendRecentTerm

private struct TrackAppendRecentTerm: View {
    @Environment(TrackAppendUseCase.self) private var trackAppendUseCase
    
    @Binding var searchTerm: String
    @Binding var recentSearchTermList: [String]
    
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
                ForEach(Array(recentSearchTermList.enumerated()), id: \.offset) { index, term in
                    HStack(spacing: 8) {
                        Button {
                            searchTerm = term
                        } label: {
                            Text(term)
                                .foregroundStyle(.white)
                                .font(.Body.body5)
                                .padding(.leading, 12)
                        }
                        
                        Button {
                            trackAppendUseCase.removeRecentSearchTerm(index: index)
                            recentSearchTermList = trackAppendUseCase.fetchRecentSearchTermList()
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

// MARK: - TrackAppendMusicList

private struct TrackAppendMusicList: View {
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackAppendUseCase.self) private var trackAppendUseCase
    
    @Binding var musicList: [Music]
    
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
                        trackAppendUseCase.selectMusic(music: music.wrappedValue)
                    }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    TrackAppendSearchSheet()
}
