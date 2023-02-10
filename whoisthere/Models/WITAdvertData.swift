////
////  WITAdvertData.swift
////  whoisthere
////
////  Created by Monica Rondón on 10.02.23.
////
//
//import Foundation
//import CoreBluetooth
//
//struct WITAdvertData {
//
//    static let SERVICE_UUID = CBUUID(string: "4DF91029-B356-463E-9F48-BAB077BF3EF5")
//    static let RX_UUID = CBUUID(string: "3B66D024-2336-4F22-A980-8095F4898C42")
//
//    static let RX_PROPERTIES: CBCharacteristicProperties = .write
//    static let RX_PERMISSIONS: CBAttributePermissions = .writeable
//
//
//    var properties: CBCharacteristicProperties = .write
//    var permissions: CBAttributePermissions = .writeable
//
//    var dict: [String: Any]
//    var user: User
//
//    init(user: User) {
//        self.user = user
//        self.dict = [
//            CBAdvertisementDataServiceUUIDsKey: [Self.SERVICE_UUID],
//            CBAdvertisementDataLocalNameKey: String(data: user.jsonData(), encoding: .utf8) ?? "ERROR"
//        ]
//    }
//
//    init(dict: [String: Any]) {
//        var user = User("ERROR")
//        if let data = (dict[CBAdvertisementDataLocalNameKey] as? String)?.data(using: .utf8) {
//            user = data.jsonObject(User.self)
//        }
//        self.dict = dict
//        self.user = user
//    }
//
//}
