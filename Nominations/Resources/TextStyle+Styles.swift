//
//  TextStyle+Styles.swift
//  Nominations
//
//  Created by Sam Davis on 20/10/2023.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation
import CubeFoundationSwiftUI

extension TextStyle {

    // MARK: Bold

    static let boldHeadlineLarge = TextStyle(.poppins, weight: 700, size: 32, lineHeight: 48, letter: 0.2)
    static let boldHeadlineMedium = TextStyle(.poppins, weight: 700, size: 24, lineHeight: 38, letter: 0.2)
    static let boldHeadlineSmall = TextStyle(.poppins, weight: 700, size: 18, lineHeight: 24, letter: 0.2)
    static let boldHeadlineSmallest = TextStyle(.poppins, weight: 700, size: 16, lineHeight: 24, letter: 0.3)

    // MARK: Body

    static let body = TextStyle(.anonymousPro, weight: 400, size: 16, lineHeight: 24)
    static let bodyBold = TextStyle(.anonymousPro, weight: 700, size: 16, lineHeight: 30, letter: 0.32)

    // MARK: Button

    static let button = TextStyle(.poppins, weight: 700, size: 14, lineHeight: 24, letter: 0.2)

    // MARK: Navigation Bar

    static let navigationBar = TextStyle(.poppins, weight: 500, size: 16, lineHeight: 24)
}
