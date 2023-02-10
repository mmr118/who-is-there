//
//  Peripheral.swift
//  whoisthere
//
//  Created by Efe Kocabas on 06/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Device {
    var peripheral : CBPeripheral
    var name : String
    var messages = Array<String>()

    var wisAdvertData: WITAdvertData
    
    init(peripheral: CBPeripheral, name: String, advertData: [String: Any]) {
        self.peripheral = peripheral
        self.name = name
        self.wisAdvertData = WITAdvertData(dict: advertData)
    }

    mutating func updateAdvertData(_ advertData: [String: Any]) {
        self.wisAdvertData = WITAdvertData(dict: advertData)
    }
}
