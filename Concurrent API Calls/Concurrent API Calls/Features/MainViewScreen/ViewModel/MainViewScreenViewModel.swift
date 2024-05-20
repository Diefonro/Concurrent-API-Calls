//
//  MainViewScreenViewModel.swift
//  Concurrent API Calls
//
//  Created by Andrés Fonseca on 20/05/2024.
//

import UIKit
import Alamofire

class MainViewScreenViewModel {
    
    let url = "https://www.compass.com/about/"
    
    func fetchEvery10thCharacter() {
        AF.request(url).response { response in
            if let data = response.value {
                print("DATA: \(data)")
            } else {
                print("Couldn't get data")
            }
        }
    }
    
    func fetchWordCounts() {
        AF.request(url).responseString { response in
            if let data = response.value {
                print("DATA: \(data)")
            } else {
                print("Couldn't get data")
            }
        }
    }
}
