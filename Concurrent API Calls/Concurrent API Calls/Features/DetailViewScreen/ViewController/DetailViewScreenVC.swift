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

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
