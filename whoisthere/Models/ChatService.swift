//
//  ChatService.swift
//  whoisthere
//
//  Created by Monica Rondón on 10.02.23.
//

import CoreBluetooth

struct ChatServiceConfiguration: BTServiceConfigurable {

    typealias CharacteristicKey = CharacteristicKeys

    static let uuid = CBUUID(string: "4DF91029-B356-463E-9F48-BAB077BF3EF5")

    var service: CBMutableService
    var advertDataDict: [String : Any] = Self.baseAdvertDataDict

    init() { self.service = Self.buildService() }

    enum CharacteristicKeys: String, BTCharacteristicKey, CaseIterable {
        case rx = "3B66D024-2336-4F22-A980-8095F4898C42"

        var properties: CBCharacteristicProperties { .write }
        var permissions: CBAttributePermissions { .writeable }
    }
}
