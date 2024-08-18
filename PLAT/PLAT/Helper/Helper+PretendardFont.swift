//
//  Helper+PretendardFont.swift
//  PLAT
//
//  Created by 박준우 on 7/2/24.
//

import SwiftUI

extension Font {
    enum CustomTitle {
        static let customTitle1: Font = .custom("Pretendard-ExtraBold", size: 34)
        static let customTitle2: Font = .custom("Pretendard-SemiBold", size: 28)
    }
    
    enum Head {
        static let head1: Font = .custom("Pretendard-SemiBold", size: 28)
        static let head2: Font = .custom("Pretendard-SemiBold", size: 24)
        static let head3: Font = .custom("Pretendard-SemiBold", size: 22)
        static let head4: Font = .custom("Pretendard-SemiBold", size: 20)
        static let head5: Font = .custom("Pretendard-SemiBold", size: 18)
    }
    
    enum Body {
        static let body1: Font = .custom("Pretendard-Medium", size: 18)
        static let body2: Font = .custom("Pretendard-SemiBold", size: 16)
        static let body3: Font = .custom("Pretendard-Regular", size: 16)
        static let body4: Font = .custom("Pretendard-SemiBold", size: 14)
        static let body5: Font = .custom("Pretendard-Regular", size: 14)
    }
    
    enum Caption {
        static let caption1: Font = .custom("Pretendard-Regular", size: 12)
        static let caption2: Font = .custom("Pretendard-Regular", size: 10)
    }
}
