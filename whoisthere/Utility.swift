//
//  Utility.swift
//  whoisthere
//
//  Created by Monica Rondón on 10.02.23.
//  Copyright © 2023 Efe Kocabas. All rights reserved.
//

import UIKit

extension UIColor {

    typealias Avatar = AvatarPalette

    
}


extension Array where Element: Encodable {

    func jsonData() -> Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}


extension Data {
    func jsonObject<T>(_ type: T.Type) -> T where T : Decodable {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            fatalError(error.localizedDescription)
        }

    }
}

extension Encodable {

    func jsonData() -> Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
