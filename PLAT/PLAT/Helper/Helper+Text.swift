//
//  Helper+Text.swift
//  PLAT
//
//  Created by 박준우 on 7/14/24.
//

import SwiftUI

extension Text {
    
    // Text에서 특정 문자만 다른 폰트를 적용시켜야할 경우에 사용할 수 있는 Text extension
    init(_ textString: String, targetString: String, targetFont: Font) {
        
        var attributedString: AttributedString {

            var attributedString = AttributedString(textString)
            
            if let target = attributedString.range(of: targetString) {
                attributedString[target].font = targetFont
            }
            
            return attributedString
        }
        
        self.init(attributedString)
    }

}
