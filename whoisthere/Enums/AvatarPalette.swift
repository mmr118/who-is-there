//
//  AvatarPalette.swift
//  whoisthere
//
//  Created by Monica Rondón on 10.02.23.
//  Copyright © 2023 Efe Kocabas. All rights reserved.
//

import Foundation
import UIKit

enum AvatarPalette: Int, CaseIterable, ColorPalette, Codable {
    typealias RawColorValue = UIColor
    case jean
    case sky
    case grass
    case carrot
    case balloon
    case lipstick
    case banana
    case lavender
    case chocolate

    var name: String { String(describing: self.self) }

}


