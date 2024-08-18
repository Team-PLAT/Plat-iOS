//
//  ApiTestView.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import SwiftUI

struct ApiTestView: View {
    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                Task {
                    await testcode()
                }
            }
    }
    
    func testcode() async {
        await FeedService.shared.testNumber()
    }
}

#Preview {
    ApiTestView()
}
