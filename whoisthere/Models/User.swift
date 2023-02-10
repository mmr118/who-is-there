//
//  User.swift
//  whoisthere
//
//  Created by Efe Kocabas on 13/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var name: String
    var avatar: Avatar = .allCases.randomElement()!
    var paletteValue: Int? // = 0

    var color: UIColor? {
        guard let paletteValue = paletteValue else { return nil }
        return AvatarPalette(rawValue: paletteValue)?.color
    }

    var hasAllDataFilled: Bool { !name.isEmpty && avatar != .none }

    init(_ value: String = String()) {
        self.name = value
        self.avatar = .none
        self.paletteValue = nil
    }

    init(_ name: String, avatar: Avatar, colorId: Int) {
        self.name = name
        self.avatar = avatar
        self.paletteValue = colorId
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(avatar.rawValue)
    }
    
}
