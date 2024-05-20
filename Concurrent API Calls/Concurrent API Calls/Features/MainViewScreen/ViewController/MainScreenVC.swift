//
//  MainScreenVC.swift
//  Concurrent API Calls
//
//  Created by Andrés Fonseca on 19/05/2024.
//

import UIKit

class MainScreenVC: UIViewController, StoryboardInfo {
    
    static var storyboard = "MainScreen"
    static var identifier = "MainScreenVC"
    
    var viewModel: MainViewScreenViewModel?
    
    @IBOutlet weak var everyTenTextView: UITextView!
    @IBOutlet weak var wordCountTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setViewModel(viewModel: MainViewScreenViewModel) {
        self.viewModel = viewModel
    }
    
    func updateEveryTenTextView(_ text: String) {
        DispatchQueue.main.async {
            self.everyTenTextView.text = text
        }
    }
    
    func updateWordCountTextView(_ text: String) {
        DispatchQueue.main.async {
            self.wordCountTextView.text = text
        }
    }
    
    @IBAction func runRequests(_ sender: Any) {
        viewModel?.fetchEvery10thCharacter { result in
            self.updateEveryTenTextView(result)
        }
        
        viewModel?.fetchWordCounts { result in
            let formattedCounts = result.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
            self.updateWordCountTextView(formattedCounts)
        }
    }
    
}
