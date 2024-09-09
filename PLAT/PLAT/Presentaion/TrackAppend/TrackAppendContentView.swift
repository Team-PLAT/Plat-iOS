//
//  TrackAppendContentView.swift
//  PLAT
//
//  Created by 박준우 on 8/20/24.
//

import SwiftUI

enum ContentState {
    case none
    case picture
    case write
    case pictureAndWrite
}

struct TrackAppendContentView: View {
    @State var isAddWriting = false
    @State var contentText = ""
    @State var selectedImage: UIImage?
    @State var isPhotoAlbumSheet = false
    @State private var state: ContentState = .none
    @Binding var detent: PresentationDetent
    @Binding var music: Music
    @Binding var isTrackAppendViewSheet: Bool
    
    var body: some View {
        VStack {
            TrackAppendContentMainView(selectedImage: $selectedImage, isAddWriting: $isAddWriting, music: $music, detent: $detent, state: $state)
            
            TrackAppendContentAddView(selectedImage: $selectedImage, isAddWriting: $isAddWriting, contentText: contentText, state: $state)
        }
        .onAppear {
            detent = .fraction(0.25)
        }
        .onChange(of: state) {
            if state == .none {
                detent = .fraction(0.25)
            } else {
                detent = .fraction(1)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: 게시 기능 추가
                    isTrackAppendViewSheet = false
                } label: {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.platPurple)
                        .overlay {
                            Text("게시")
                                .font(.Body.body2)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 48, height: 28)
                }
            }
        }
    }
}

struct TrackAppendContentMainView: View {
    @State var isPhotoAlbumSheet = false
    @Binding var selectedImage: UIImage?
    @Binding var isAddWriting: Bool
    @Binding var music: Music
    @Binding var detent: PresentationDetent
    @Binding var state: ContentState
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: music.albumImageUrl)) { image in
                if let img = image.image {
                    img
                        .resizable()
                        .frame(width: (selectedImage != nil && isAddWriting) ? 72 : 128, height: (selectedImage != nil && isAddWriting) ? 72 : 128)
                        .cornerRadius(12, corners: .allCorners)
                        .padding(.leading, 18)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.red)
                        .frame(width: (selectedImage != nil && isAddWriting) ? 72 : 128, height: (selectedImage != nil && isAddWriting) ? 72 : 128)
                        .padding(.leading, 18)
                }
            }
            VStack(alignment: .leading) {
                
                Text("\(music.title)")
                    .foregroundStyle(.white)
                    .font(.Head.head2)
                    .padding(.bottom, 4)
                    .lineLimit(1)
                
                Text("\(music.artist)")
                    .foregroundStyle(.gray7)
                    .font(.Body.body3)
                    .padding(.bottom)
                    .lineLimit(1)
                
                HStack {
                    if selectedImage == nil {
                        Button {
                            if state == .write {
                                state = .pictureAndWrite
                            } else {
                                state = .picture
                            }
                            isPhotoAlbumSheet = true
                        } label: {
                            Circle()
                                .foregroundStyle(.gray9)
                                .overlay {
                                    Image(systemName: "camera")
                                        .foregroundStyle(.gray7)
                                }
                        }
                        .frame(width: 48, height: 48)
                    }
                    if state != .pictureAndWrite && state != .write {
                        Button {
                            if state == .picture {
                                state = .pictureAndWrite
                            } else {
                                state = .write
                            }
                        } label: {
                            Circle()
                                .foregroundStyle(.gray9)
                                .overlay {
                                    Image(systemName: "square.and.pencil")
                                        .foregroundStyle(.gray7)
                                }
                        }
                        .frame(width: 48, height: 48)
                    }
                }
            }
            .padding(.leading, 10)
            .sheet(isPresented: $isPhotoAlbumSheet) {
                if selectedImage == nil {
                    if state == .pictureAndWrite {
                        state = .write
                    } else {
                        state = .none
                    }
                }
            } content: {
                PhotoPicker(selectedImage: $selectedImage)
            }
            Spacer()
        }
        .padding(.top)
    }
}

struct TrackAppendContentAddView: View {
    @Binding var selectedImage: UIImage?
    @Binding var isAddWriting: Bool
    @State var contentText = ""
    @Binding var state: ContentState
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        if state == .none {
            Spacer()
        } else if state == .pictureAndWrite && selectedImage != nil {
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 56, height: 56)
                        .foregroundStyle(.gray9)
                        .overlay {
                            VStack(spacing: 0) {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("1 / 1")
                                    .font(.Body.body3)
                            }
                            .padding(.vertical, 10)
                            .foregroundStyle(.gray7)
                            .font(.Body.body3)
                        }
                    if let image = selectedImage {
                        Button {
                            selectedImage = nil
                            if state == .pictureAndWrite {
                                state = .write
                            } else {
                                state = .none
                            }
                        } label: {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 5, height: 5)
                                        .padding(.init(top: 2, leading: 0, bottom: 0, trailing: 2))
                                        .foregroundStyle(.gray7)
                                }
                        }
                        Spacer()
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 26)
                .padding(.leading, 18)
                
                VStack {
                    TextEditor(text: $contentText)
                        .font(.Body.body5)
                        .scrollContentBackground(.hidden)
                        .padding(.init(top: 12, leading: 12, bottom: 12, trailing: 78))
                        .frame(width: .infinity, height: 238)
                        .background {
                            if isTextEditorFocused {
                                RoundedRectangle(cornerRadius: 8).fill(.platBlack).stroke(.platPurple)
                            } else {
                                RoundedRectangle(cornerRadius: 8).fill(.gray9)
                            }
                        }
                        .overlay(alignment: .topLeading) {
                            if contentText.isEmpty && !isTextEditorFocused {
                                Text("장소, 노래, 상황과 관련된 말을 적어보세요.")
                                    .font(.Body.body5)
                                    .padding(.init(top: 12, leading: 12, bottom: 0, trailing: 0))
                                    .foregroundStyle(.gray7)
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            Button {
                                contentText = ""
                                state = .picture
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.top, 8)
                                    .padding(.trailing, 8)
                                    .foregroundStyle(.gray7)
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Text("\(contentText.count)/200")
                                .font(.Body.body5)
                                .padding(.bottom, 8)
                                .padding(.trailing, 8)
                                .foregroundStyle(.gray7)
                        }
                        .onChange(of: contentText) { _, newValue in
                            if newValue.count > 200 {
                                contentText = String(newValue.prefix(200))
                            }
                        }
                        .focused($isTextEditorFocused)
                    Spacer()
                }
                .padding(.horizontal, 18)
            }
        } else if state == .picture && selectedImage != nil {
            if let image = selectedImage {
                VStack {
                    Button {
                        selectedImage = nil
                        state = .none
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.gray7)
                                    .padding(.top, 8)
                                    .padding(.trailing, 8)
                            }
                            .padding(.top, 36)
                            .padding(.horizontal, 18)
                    }
                    Spacer()
                }
            }
        } else if state == .write {
            VStack {
                TextEditor(text: $contentText)
                    .font(.Body.body5)
                    .scrollContentBackground(.hidden)
                    .padding(.init(top: 12, leading: 12, bottom: 12, trailing: 78))
                    .frame(width: .infinity, height: 238)
                    .background {
                        if isTextEditorFocused {
                            RoundedRectangle(cornerRadius: 8).fill(.platBlack).stroke(.platPurple)
                        } else {
                            RoundedRectangle(cornerRadius: 8).fill(.gray9)
                        }
                    }
                    .overlay(alignment: .topLeading) {
                        if contentText.isEmpty && !isTextEditorFocused {
                            Text("장소, 노래, 상황과 관련된 말을 적어보세요.")
                                .font(.Body.body5)
                                .padding(.init(top: 12, leading: 12, bottom: 0, trailing: 0))
                                .foregroundStyle(.gray7)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        Button {
                            contentText = ""
                            state = .none
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.top, 8)
                                .padding(.trailing, 8)
                                .foregroundStyle(.gray7)
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Text("\(contentText.count)/200")
                            .font(.Body.body5)
                            .padding(.bottom, 8)
                            .padding(.trailing, 8)
                            .foregroundStyle(.gray7)
                    }
                    .onChange(of: contentText) { _, newValue in
                        if newValue.count > 200 {
                            contentText = String(newValue.prefix(200))
                        }
                    }
                    .focused($isTextEditorFocused)
                Spacer()
            }
            .padding(.top, 36)
            .padding(.horizontal, 18)
        }
    }
}

#Preview {
    TrackAppendContentView(
        detent: .constant(.fraction(0.25)),
        music: .constant(
            Music(
                isrc: "",
                title: "no pain",
                artist: "실리카겔",
                albumImageUrl: "https://i.namu.wiki/i/1P6LoQ_N9dwT4DZZcNb2MABa80X_AElIyA92uyrI_BTBu47gs1zKq6V1zvLH-J0oA7_KqrWVkqFRWE5Lgg1VUIsVeNYHU21_bTlbBJT-JER3bcCJzbC5mcZZ_LAIZXmVjWjdNSjMqFiOLsPC6Wi3hg.webp",
                duration: 0
            )
        ),
        isTrackAppendViewSheet: .constant(false)
    )
}
