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
    var detailRequested: Bool = false {
        didSet {
            updateButtonUserInteraction()
        }
    }
    
    @IBOutlet weak var everyTenTextView: UITextView!
    @IBOutlet weak var wordCountTextView: UITextView!
    @IBOutlet weak var runRequestsButton: UIButton!
    @IBOutlet weak var everyTenActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wordCounterActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var everyTenTargetButton: UIButton!
    @IBOutlet weak var wordCounterTargetButton: UIButton!
    @IBOutlet weak var tapForDetailToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetups()
    }
    
    func setViewModel(viewModel: MainViewScreenViewModel) {
        self.viewModel = viewModel
    }
    
    func updateEveryTenTextView(_ text: String) {
        DispatchQueue.main.async {
            self.everyTenTextView.isHidden = false
            self.everyTenTextView.text = text
            self.runRequestsButton.isUserInteractionEnabled = true
        }
    }
    
    func updateWordCountTextView(_ text: String) {
        DispatchQueue.main.async {
            self.wordCountTextView.isHidden = false
            self.wordCountTextView.text = text
            self.runRequestsButton.isUserInteractionEnabled = true
        }
    }
    
    func initialSetups() {
        everyTenActivityIndicator.isHidden = true
        wordCounterActivityIndicator.isHidden = true
        everyTenActivityIndicator.hidesWhenStopped = true
        wordCounterActivityIndicator.hidesWhenStopped = true
        detailRequested = tapForDetailToggle.isOn
    }
    
    func hideTextViews() {
        everyTenActivityIndicator.startAnimating()
        wordCounterActivityIndicator.startAnimating()
        everyTenTextView.isHidden = true
        wordCountTextView.isHidden = true
    }
    
    @IBAction func runRequests(_ sender: Any) {
        runRequestsButton.isUserInteractionEnabled = false
        hideTextViews()
        viewModel?.fetchEvery10thCharacter { [weak self] result in
            switch result {
            case .success(let (text, every10thCharacter)):
                self?.everyTenActivityIndicator.stopAnimating()
                self?.updateEveryTenTextView(text)
                self?.updateEveryTenTextView(String(every10thCharacter))
            case .failure(let error):
                self?.everyTenActivityIndicator.stopAnimating()
                self?.showError(error)
            }
        }
        
        viewModel?.fetchWordCounts { [weak self] result in
            switch result {
            case .success(let result):
                let formattedCounts = result.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
                self?.wordCounterActivityIndicator.stopAnimating()
                self?.updateWordCountTextView(formattedCounts)
            case .failure(let error):
                self?.wordCounterActivityIndicator.stopAnimating()
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
    
    func presentDetailView(with textView: UITextView) {
        if let detailVC = UIStoryboard(name: DetailViewScreenVC.storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: DetailViewScreenVC.identifier) as? DetailViewScreenVC {
            let textViewText = textView.text ?? "Error sending data"
            detailVC.textToShow = textViewText
            detailVC.modalPresentationStyle = .popover
            self.present(detailVC, animated: true)
        }
    }
    
    func updateButtonUserInteraction() {
        everyTenTargetButton.isUserInteractionEnabled = detailRequested
        wordCounterTargetButton.isUserInteractionEnabled = detailRequested
    }
    
    @IBAction func everyTenTargetAction(_ sender: Any) {
        presentDetailView(with: everyTenTextView)
    }
    
    @IBAction func wordCounterTargetAction(_ sender: Any) {
        presentDetailView(with: wordCountTextView)
    }
    
    @IBAction func tapForDetailToggleChanged(_ sender: UISwitch) {
        detailRequested = sender.isOn
    }
}
