//
//  TrackAppendContentSheet.swift
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

// MARK: - TrackAppendContentSheet

struct TrackAppendContentSheet: View {
    
    @Environment(PathModel.self) private var pathModel
    @Environment(TrackAppendUseCase.self) private var trackAppendUseCase
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAddWriting = false
    @State private var contentText = ""
    @State private var selectedImage: UIImage?
    @State private var isPhotoAlbumSheet = false
    @State private var state: ContentState = .none
    
    var body: some View {
        ScrollView {
            VStack {
                TrackAppendContentMainSheet(selectedImage: $selectedImage, isAddWriting: $isAddWriting, state: $state)
                
                TrackAppendContentAddSheet(selectedImage: $selectedImage, isAddWriting: $isAddWriting, contentText: $contentText, state: $state)
            }
        }
        .onAppear {
            pathModel.sheetDetent = .fraction(0.25)
        }
        .onChange(of: state) {
            if state == .none {
                pathModel.sheetDetent = .fraction(0.25)
            } else {
                pathModel.sheetDetent = .large
            }
        }
        .presentationDetents([pathModel.sheetDetent])
        .tapDismissesKeyboard()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: 게시하기 기능 구현
                    dismiss()
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

// MARK: - TrackAppendContentMainSheet

struct TrackAppendContentMainSheet: View {
    @Environment(TrackAppendUseCase.self) private var trackAppendUseCase
    
    @State private var isPhotoAlbumSheet = false
    @Binding var selectedImage: UIImage?
    @Binding var isAddWriting: Bool
    @Binding var state: ContentState
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: trackAppendUseCase.state.selectedMusic.albumImageUrl)) { image in
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
                
                Text("\(trackAppendUseCase.state.selectedMusic.title)")
                    .foregroundStyle(.white)
                    .font(.Head.head2)
                    .lineLimit(1)
                
                Text("\(trackAppendUseCase.state.selectedMusic.artist)")
                    .foregroundStyle(.gray7)
                    .font(.Body.body3)
                    .lineLimit(1)
                
                Spacer()
                
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
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(.gray7)
                                }
                        }
                        .frame(width: 38, height: 38)
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
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(.gray7)
                                        .padding(EdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 0))
                                }
                        }
                        .frame(width: 38, height: 38)
                    }
                }
            }
            .frame(height: 128)
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
    }
}

// MARK: - TrackAppendContentAddSheet

struct TrackAppendContentAddSheet: View {
    @Binding var selectedImage: UIImage?
    @Binding var isAddWriting: Bool
    @Binding var contentText: String
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
                        .padding(.init(top: 12, leading: 12, bottom: 12, trailing: 44))
                        .frame(height: 238)
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
                                    .padding(.init(top: 14, leading: 12, bottom: 0, trailing: 0))
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
                    .padding(.init(top: 12, leading: 12, bottom: 12, trailing: 44))
                    .frame(height: 238)
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
                                .padding(.init(top: 14, leading: 12, bottom: 0, trailing: 0))
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
    TrackAppendContentSheet()
}
