//
//  AppViewModel.swift
//  AppCrypto
//
//  Created by Steve Pha on 1/31/23.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var coins: [CryptoModel]?
    @Published var currentCoin: CryptoModel?
    
    init(){
        Task{
            do{
                try await fetchCryptoData()
            }catch{
                //Handler Error
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Fetching Crypto Data
    func fetchCryptoData() async throws{
        // MARK: useing latest async/ await
        guard let url = url else {return}
        let session = URLSession.shared
        
        let response = try await session.data(from: url)
        let jsonData = try JSONDecoder().decode([CryptoModel].self, from: response.0)
        
        // Alternative for DispatchQueue main
        await MainActor.run(body: {
            self.coins = jsonData
            if let firstCoin = jsonData.first {
                self.currentCoin = firstCoin
            }
        })
    }
}

