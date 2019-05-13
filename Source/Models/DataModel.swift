//
//  DataModel.swift
//  QRScannerModule
//
//  Created by  Vitaly Potlov on 26/04/2019.
//

import Foundation

internal struct DataModel: Codable {
    public var title: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "#title"
    }
    
    public init?(map: [String: Any]) {
        self.mapping(map: map)
    }
    
    public mutating func mapping(map: [String: Any]) {
        title = map[CodingKeys.title.rawValue] as? String
    }
}
