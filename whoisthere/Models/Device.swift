//
//  Peripheral.swift
//  whoisthere
//
//  Created by Efe Kocabas on 06/07/2017.
//

import Foundation
import CoreBluetooth

struct Device {
    var peripheral : CBPeripheral
    var name : String
    var messages = Array<String>()

    var advertDataDict: [String: Any]
    
    init(peripheral: CBPeripheral, name: String, advertData: [String: Any]) {
        self.peripheral = peripheral
        self.name = name
        self.advertDataDict = advertData
    }

    mutating func updateAdvertData(_ advertData: [String: Any]) {
        self.advertDataDict = advertData
    }

    var user: User? {
        guard let dataString = advertDataDict[CBAdvertisementDataLocalNameKey] as? String else { return nil }
        return dataString.data(using: .utf8)?.jsonObject(User.self)
    }

}
