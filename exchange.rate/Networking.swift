//
//  Networking.swift
//  exchange.rate
//
//  Created by 細川聖矢 on 2019/10/01.
//  Copyright © 2019 Seiya. All rights reserved.
//

import Foundation

struct rates:Decodable{
    var date:String
    var base:String
    var rates:[String:Double]
}

enum Result{
    case failure
    case success(rates)
}

let urlString = "https://api.exchangeratesapi.io/latest"

func getLatest(completion:@escaping(Result)->Void){
    guard let url = URL(string:urlString)else{completion(.failure);return}
    
URLSession.shared.dataTask(with: url){
    (data,response,error)in
    guard error == nil,let urlResponse = response as?HTTPURLResponse,urlResponse.statusCode == 200,let data = data else{completion(.failure);return}
    do{
        let exchangeRates = try JSONDecoder().decode(rates.self,from:data)
        completion(.success(exchangeRates))
    }
    catch{completion(.failure)}
    }.resume()
}
