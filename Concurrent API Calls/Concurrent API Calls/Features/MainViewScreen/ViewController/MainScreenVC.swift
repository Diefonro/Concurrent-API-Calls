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

    @IBAction func runRequests(_ sender: Any) {
        viewModel?.fetchEvery10thCharacter()
        viewModel?.fetchWordCounts()
    }
    
}
