//
//  StockDecodable.swift
//  Jestock
//
//  Created by Jeremy Jason on 20/12/20.
//

import Foundation

struct GlobalQuote: Decodable {
    var globalQuote: StockQuote
    
    private enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}

struct StockQuote: Decodable {
    var symbol: String
    var open: String
    var low: String

    private enum CodingKeys: String, CodingKey {
        case symbol = "01. symbol"
        case open = "02. open"
        case low = "04. low"
    }
}

