//
//  TrackAppendSearchSheet.swift
//  PLAT
//
//  Created by 박준우 on 8/20/24.
//

import SwiftUI
import MusicKit
import Kingfisher

// MARK: - TrackAppendSearchSheet

struct TrackAppendSearchSheet: View {
    @Environment(PathModel.self) private var pathModel
    @Environment(MusicControlUseCase.self) private var musicControlUseCase

    @State private var searchTimer: Timer?
    @State private var searchTerm = ""
    @State private var musicList: [Music] = []
    @State private var recentSearchTermList: [String] = []
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        @Bindable var pathModel = pathModel
        
        NavigationStack(path: $pathModel.sheetPath) {
            VStack {
                TrackAppendSearchbar(searchTerm: $searchTerm, isTextEditorFocused: $isTextFieldFocused)
                
                TrackAppendRecentTerm(searchTerm: $searchTerm, recentSearchTermList: $recentSearchTermList, isTextEditorFocused: $isTextFieldFocused)
                
                Spacer()
                
                TrackAppendMusicList(musicList: $musicList, searchTerm: $searchTerm)
            }
            .tint(.white)
            // TODO: ContentSheet로 넘어갔을 때, back button title 변경되도록 하는 로직(뒤로 가기 했을 때 버퍼링 있음)
            .navigationTitle(pathModel.sheetPath.isEmpty ? "검색" : "음악 선택")
            .navigationDestination(for: Sheet.self) { sheet in
                pathModel.build(sheet)
            }
            .onAppear {
                pathModel.sheetDetent = .large
                searchTerm = ""
                recentSearchTermList = UserDefaults.standard.recentSearchTermList
            }
            .onDisappear {
                searchTerm = ""
                musicList = []
            }
            .onChange(of: searchTerm) {
                searchTimer?.invalidate()
                searchTimer = nil
                
                self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                    Task {
                        @MainActor in
                        let result = await musicControlUseCase.searchMusic(term: searchTerm)
                        switch result {
                        case .success(let musicList):
                            self.musicList = musicList
                        case .failure:
                            break
                        }
                    }
                }
            }
            .onSubmit {
                recentSearchTermList.append(searchTerm)
                UserDefaults.standard.recentSearchTermList = recentSearchTermList
            }
            .scrollDismissesKeyboard(.immediately)
            .tapDismissesKeyboard()
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([pathModel.sheetDetent])
    }
}

// MARK: - TrackAppendSearchbar

private struct TrackAppendSearchbar: View {
    @Binding var searchTerm: String
    private(set) var isTextEditorFocused: FocusState<Bool>.Binding
    
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
                .focused(isTextEditorFocused)
            
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
    @Binding private(set) var searchTerm: String
    @Binding private(set) var recentSearchTermList: [String]
    
    private(set) var isTextEditorFocused: FocusState<Bool>.Binding
    
    var body: some View {
        if !recentSearchTermList.isEmpty && !isTextEditorFocused.wrappedValue {
            HStack {
                Text("최근 검색어")
                    .font(.Body.body3)
                    .foregroundStyle(.gray7)
                    .padding(.leading, 18)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
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
                                recentSearchTermList.remove(at: index)
                                UserDefaults.standard.recentSearchTermList = recentSearchTermList
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
}

// MARK: - TrackAppendMusicList

private struct TrackAppendMusicList: View {
    @Environment(PathModel.self) private var pathModel
    @Environment(MusicControlUseCase.self) private var musicControlUseCase
    @Environment(TrackUseCase.self) private var trackUseCase
    
    @Binding var musicList: [Music]
    @Binding var searchTerm: String
    
    var body: some View {
        List(Array($musicList.enumerated()), id: \.self.offset) { index, music in
            HStack {
                KFImage(URL(string: music.albumImageUrl.wrappedValue))
                    .placeholder {
                        LinearGradient(colors: [.orange, .indigo], startPoint: .top, endPoint: .bottom)
                            .frame(width: 72, height: 72)
                            .cornerRadius(4, corners: .allCorners)
                    }
                    .resizable()
                    .frame(width: 72, height: 72)
                    .cornerRadius(4, corners: .allCorners)
                
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
                        trackUseCase.selectTrackAppendMusic(music: music.wrappedValue)
                        pathModel.pushSheet(.trackAppendContent)
                    }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .onAppear {
                if $musicList.count == (index + 1) {
                    Task {
                        let result = await musicControlUseCase.searchMusic(term: searchTerm, isPagination: true)
                        switch result {
                        case .success(let musicList):
                            self.musicList.append(contentsOf: musicList)
                        case .failure:
                            break
                        }
                    }
                }
            }
        }
        .contentMargins(.top, 0, for: .scrollContent)
    }
}

#Preview {
    TrackAppendSearchSheet()
        .injectDIContainer()
}
