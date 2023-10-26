//
//  FigmaShadow+Shadows.swift
//  Nominations
//
//  Created by Sam Davis on 20/10/2023.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation
import CubeFoundationSwiftUI

extension FigmaShadow {

    static let light = FigmaShadow(x: 0, y: 0, blur: 10, color: .shadowLight)
    static let strong = FigmaShadow(x: 0, y: 2, blur: 10, color: .shadowStrong)
    static let none = FigmaShadow(x: 0, y: 0, blur: 0, color: .clear)
}
