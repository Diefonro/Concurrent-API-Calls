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
    @IBOutlet weak var runRequestsButton: UIButton!
    
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
        viewModel?.fetchEvery10thCharacter { [weak self] result in
            switch result {
            case .success(let (text, every10thCharacter)):
                self?.updateEveryTenTextView(text)
                self?.updateEveryTenTextView(String(every10thCharacter))
            case .failure(let error):
                self?.showError(error)
            }
        }
        
        viewModel?.fetchWordCounts { [weak self] result in
            switch result {
            case .success(let result):
                let formattedCounts = result.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
                self?.updateWordCountTextView(formattedCounts)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }

    private func showError(_ error: FetchError) {
        DispatchQueue.main.async {
            self.everyTenTextView.text = error.errorMessage
            self.wordCountTextView.text = error.errorMessage
        }
    }
    
}
