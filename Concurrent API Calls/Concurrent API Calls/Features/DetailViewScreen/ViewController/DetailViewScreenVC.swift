//
//  DetailViewScreenVC.swift
//  Concurrent API Calls
//
//  Created by Andrés Fonseca on 20/05/2024.
//

import UIKit

class DetailViewScreenVC: UIViewController, StoryboardInfo {
    
    static var storyboard = "DetailViewScreen"
    static var identifier = "DetailViewScreenVC"
    var textToShow: String? = "Default Text"
    
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView(with: textToShow!)
    }
    
    func setupView(with string: String) {
        textView.text = string
    }
}
