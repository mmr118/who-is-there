//
//  ColorPalette.swift
//  whoisthere
//
//  Created by Monica Rondón on 10.02.23.
//

import Foundation

public protocol ColorPalette: CaseIterable, Codable where AllCases == [Self] {

    /// A value that can be used to initialize a `UIColor` and `Color`.
    associatedtype RawColorValue

    /// A name for the value.
    var name: String { get }

    /// The value used to create the color.
    var rawColorValue: RawColorValue { get }

}

// MARK: ColorPalette: RawRepresentable & Identifiable
//public extension ColorPalette where Self: RawRepresentable & Identifiable {
//
//    var id: RawValue { rawValue }
//
//}

// MARK: ColorPalette: RawRepresentable & RawColorValue == RawValue
public extension ColorPalette where Self: RawRepresentable, RawColorValue == RawValue {

    var rawColorValue: RawColorValue { rawValue }

}


import UIKit

// MARK: ColorPalette+RawColorValue == String
//extension ColorPalette where RawColorValue == String {
//    public var uiColor: UIColor { UIColor(hex: self.rawColorValue) }
//}
//
//// MARK: ColorPalette+RawColorValue == UInt64
//extension ColorPalette where RawColorValue == UInt64 {
//    public var uiColor: UIColor { UIColor(hex: self.rawColorValue) }
//}


//#if canImport(SwiftUI)
//import SwiftUI
//
//// MARK: ColorPalette+RawColorValue == String
//extension ColorPalette where RawColorValue == String {
//    public var color: Color { Color(hex: self.rawColorValue) }
//}
//
//// MARK: ColorPalette+RawColorValue == UInt64
//extension ColorPalette where RawColorValue == UInt64 {
//    public var color: Color { Color(hex: self.rawColorValue) }
//}
//#endif
