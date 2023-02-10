//
//  BTServiceConfigurable.swift
//  whoisthere
//
//  Created by Monica Rondón on 10.02.23.
//

import CoreBluetooth

// MARK: - BTCharacteristicKey
protocol BTCharacteristicKey: Hashable {
    var uuid: CBUUID { get }
    var properties: CBCharacteristicProperties { get }
    var permissions: CBAttributePermissions { get }
}

extension BTCharacteristicKey where Self: RawRepresentable, Self.RawValue == String {
    var uuid: CBUUID { CBUUID(string: rawValue) }
}



// MARK: - BTServiceConfigurable
protocol BTServiceConfigurable {
    associatedtype CharacteristicKey: BTCharacteristicKey
    static var uuid: CBUUID { get }
    var service: CBMutableService { get set }
    var advertDataDict: [String: Any] { get set }
}

extension BTServiceConfigurable {

    static var baseAdvertDataDict: [String: Any] { [CBAdvertisementDataServiceUUIDsKey: [uuid]] }

    mutating func setDataDictValue(_ value: Any, for key: String) {
        self.advertDataDict[key] = value
    }

    func characteristic(for key: CharacteristicKey) -> CBCharacteristic? {
        return service.characteristics?.first(where: { $0.uuid == key.uuid })
    }
}

extension BTServiceConfigurable where CharacteristicKey: CaseIterable, CharacteristicKey.AllCases == [CharacteristicKey] {

    static func buildService(primary: Bool = true) -> CBMutableService {
        let service = CBMutableService(type: uuid, primary: primary)
        service.characteristics = CharacteristicKey.allCases.map { CBMutableCharacteristic(type: $0.uuid, properties: $0.properties, value: nil, permissions: $0.permissions) }
        return service
    }

}
