//
//  SpotifyView.swift
//  PLAT
//
//  Created by 조우현 on 8/9/24.
//

import SwiftUI

struct SpotifyView: View {
    @EnvironmentObject var viewModel: SpotifyViewModel
    
    var body: some View {
        VStack {
            if let albumCover = viewModel.albumCover {
                Image(uiImage: albumCover)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "music.note")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Text(viewModel.trackName)
                .font(.title)
            
            Text(viewModel.artistName)
                .font(.subheadline)
            
            Text("Duration: \(viewModel.trackDuration)")
                .font(.footnote)
            
            Button {
                viewModel.togglePlayback()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Button {
                viewModel.connect()
            } label: {
                Text("Connect to Spotify")
            }
        }
        .padding()
        .onAppear {
                    viewModel.connect()
                }
    }
}

#Preview {
    SpotifyView()
}
