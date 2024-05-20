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
    let every10thCharacterKey = "every10thCharacterKey"
    let wordCountsKey = "wordCountsKey"
    
    private func checkInternet(completion: @escaping (Bool) -> Void) {
        completion(NetworkReachabilityManager()?.isReachable ?? false)
    }
    
    func fetchEvery10thCharacter(completion: @escaping (Result<String, FetchError>) -> Void) {
        checkInternet { isReachable in
            guard isReachable else {
                if let cachedData = UserDefaults.standard.string(forKey: "every10thCharacterKey") {
                    completion(.success(cachedData))
                } else {
                    completion(.failure(.noInternet))
                }
                return
            }
            
            AF.request(self.url).response { response in
                guard let data = response.data, response.error == nil else {
                    completion(.failure(.networkError))
                    return
                }
                
                if let htmlString = String(data: data, encoding: .utf8) {
                    do {
                        let doc = try SwiftSoup.parse(htmlString)
                        let text = try doc.text()
                        
                        var index = text.index(text.startIndex, offsetBy: 9)
                        var every10thCharacter: [Character] = []
                        
                        while index < text.endIndex {
                            every10thCharacter.append(text[index])
                            index = text.index(index, offsetBy: 10, limitedBy: text.endIndex) ?? text.endIndex
                        }
                        
                        let result = String(every10thCharacter)
                        UserDefaults.standard.set(result, forKey: "every10thCharacterKey")
                        completion(.success(result))
                    } catch {
                        completion(.failure(.parsingError))
                    }
                } else {
                    completion(.failure(.parsingError))
                }
            }
        }
    }
    
    func fetchWordCounts(completion: @escaping (Result<[String: Int], FetchError>) -> Void) {
        checkInternet { isReachable in
            guard isReachable else {
                if let cachedData = UserDefaults.standard.dictionary(forKey: "wordCountsKey") as? [String: Int] {
                    completion(.success(cachedData))
                } else {
                    completion(.failure(.noInternet))
                }
                return
            }
            
            AF.request(self.url).responseString { response in
                guard let htmlString = response.value else {
                    completion(.failure(.networkError))
                    return
                }
                
                do {
                    let doc = try SwiftSoup.parse(htmlString)
                    let text = try doc.text()
                    
                    let words = text.lowercased().components(separatedBy: .whitespacesAndNewlines)
                    var wordCounts: [String: Int] = [:]
                    for word in words {
                        wordCounts[word, default: 0] += 1
                    }
                    UserDefaults.standard.set(wordCounts, forKey: "wordCountsKey")
                    completion(.success(wordCounts))
                } catch {
                    completion(.failure(.parsingError))
                }
            }
        }
    }
}

enum FetchError: Error {
    case noInternet
    case networkError
    case serverError
    case parsingError
    
    var errorMessage: String {
        switch self {
        case .noInternet:
            return "No internet connection"
        case .networkError:
            return "Network error"
        case .serverError:
            return "Server error"
        case .parsingError:
            return "Parsing error"
        }
    }
}
