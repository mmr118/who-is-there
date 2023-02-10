//
//  Avatar.swift
//  WhoIsThereSUI
//
//  Created by Monica Rondón on 09.02.23.
//

import Foundation

enum Avatar: String, CaseIterable, Identifiable, Codable {
    case capabray
    case dingo
    case kangaroo
    case koala
    case lemur
    case platypus
    
    var id: String { rawValue }
    var filename: String { rawValue }
    
}
