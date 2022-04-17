//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Matheus Diniz on 18/02/2022.
//  Copyright © 2022 co.Matheus.Chat. All rights reserved.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A488D5A8-8A5C-4DF5-8C52-AA7295DF0D47"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","USD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                    if let safeData = data {
                        if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
            }
        }
           task.resume()
        }
    }
        func parseJSON(_ data: Data) -> Double? {
            let decoder = JSONDecoder()
            do {
                let decodedData =  try decoder.decode(CoinData.self, from: data)
                let lastPrice = decodedData.rate
                print(lastPrice)
                return lastPrice
                
            } catch {
                print(error)
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
  }


