//
//  MainViewScreenViewModel.swift
//  Concurrent API Calls
//
//  Created by Andrés Fonseca on 20/05/2024.
//

import UIKit
import Alamofire
import SwiftSoup

class MainViewScreenViewModel {
    
    let url = "https://www.compass.com/about/"
    
    func fetchEvery10thCharacter(completion: @escaping (String) -> Void) {
        AF.request(url).response { response in
            if let data = response.data, let htmlString = String(data: data, encoding: .utf8) {
                do {
                    let doc = try SwiftSoup.parse(htmlString)
                    let text = try doc.text()
                    
                    var index = text.index(text.startIndex, offsetBy: 9)
                    var every10thCharacter: [Character] = []
                    
                    while index < text.endIndex {
                        every10thCharacter.append(text[index])
                        index = text.index(index, offsetBy: 10, limitedBy: text.endIndex) ?? text.endIndex
                    }
                    
                    completion(String(every10thCharacter))
                } catch {
                    completion("Error parsing HTML")
                }
            } else {
                completion("Error fetching HTML")
            }
        }
    }
    
    func fetchWordCounts(completion: @escaping ([String: Int]) -> Void) {
        AF.request(url).responseString { response in
            if let htmlString = response.value {
                do {
                    let doc = try SwiftSoup.parse(htmlString)
                    let text = try doc.text()
                    
                    let words = text.lowercased().components(separatedBy: .whitespacesAndNewlines)
                    var wordCounts: [String: Int] = [:]
                    for word in words {
                        wordCounts[word, default: 0] += 1
                    }
                    completion(wordCounts)
                } catch {
                    completion(["Error parsing HTML": 0])
                }
            } else {
                completion(["Error fetching word counts": 0])
            }
        }
    }
}
