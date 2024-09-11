//
//  PlaylistView.swift
//  PLAT
//
//  Created by 조우현 on 9/10/24.
//

import SwiftUI

struct PlaylistView: View {
    var playlist: [Playlist]
    var isShowDetailSheet: Bool = false
    
    var body: some View {
        ScrollView {
            ForEach(MockDataBuilder.playlist.indices, id: \.self) { index in
                
                let list = MockDataBuilder.playlist[index]
                
                HStack(spacing: 18) {
                    AsyncImage(url: URL(string: list.imageUrl)) { img in
                        if let image = img.image {
                            image
                                .resizable()
                                .frame(width: 68, height: 68)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 68, height: 68)
                        }
                    }
                    
                    Text("\(list.title)")
                        .font(.Body.body2)
                    
                    Spacer()
                    
                    Image(.icnVerticalDots)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 18)
                .padding(.vertical, 5)
            }
        }
    }
}

#Preview {
    PlaylistView(playlist: MockDataBuilder.playlist)
}
