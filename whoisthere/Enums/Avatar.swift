//
//  Avatar.swift
//  WhoIsThereSUI
//
//  Created by Monica Rondón on 09.02.23.
//

import Foundation
import UIKit

enum Avatar: Int, CaseIterable, Identifiable, Codable {

    static let allCases: [Avatar] = [.capabray, .dingo, .kangaroo, .koala, .lemur, .platypus]

    case capabray
    case dingo
    case kangaroo
    case koala
    case lemur
    case platypus
    case none
    
    var id: Int { rawValue }

    var rawString: String { String(describing: self.self) }

    var uiImage: UIImage? { UIImage(named: "Avatar/\(rawString)") }

}
