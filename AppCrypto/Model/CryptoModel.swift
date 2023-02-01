//
//  CryptoModel.swift
//  AppCrypto
//
//  Created by Steve Pha on 1/31/23.
//

import SwiftUI

//MARK: Crypto Model for Json fetching
struct CryptoModel: Codable, Identifiable {
    let id, symbol, name, image : String
    let current_price: Double
    let last_updated: String
    let price_change: Double
    let last_7days_price: GraphModel
    
    enum CodingKeys: String,CodingKey{
        case id, symbol, name, image
        case current_price = "current_price"
        case last_updated = "last_updated"
        case price_change = "price_change_percentage_24h"
        case last_7days_price = "sparkline_in_7d"
    }
}

struct GraphModel: Codable {
    let price: [Double]
    enum Codingkeys: String,CodingKey {
        case price
    }
}


// JSON Url

let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&sparkline=true&price_change_percentage=24h")
