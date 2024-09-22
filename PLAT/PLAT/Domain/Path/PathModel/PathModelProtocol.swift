//
//  PathModelProtocol.swift
//  PLAT
//
//  Created by 김민준 on 9/20/24.
//

import SwiftUI

protocol PathModelProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    
    func push(_ screen: Screen)
    func pushSheet(_ sheet: Sheet)
    func presentSheet(_ sheet: Sheet)
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenCover()
}
