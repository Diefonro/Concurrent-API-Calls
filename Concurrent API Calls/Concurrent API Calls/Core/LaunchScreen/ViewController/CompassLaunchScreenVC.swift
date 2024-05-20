//
//  CompassLaunchScreenVC.swift
//  Concurrent API Calls
//
//  Created by Andrés Fonseca on 19/05/2024.
//

import UIKit

class CompassLaunchScreenVC: UIViewController, StoryboardInfo {
    
    static var storyboard = "CompassLaunchScreen"
    static var identifier = "CompassLaunchScreenVC"
    
    @IBOutlet weak var compassLogoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBehavior()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupImageAppearance()
    }
    
    func setupNavigationBehavior() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupImageAppearance() {
        UIView.animate(withDuration: 1.5) {
            self.compassLogoImageView.alpha = 1
            self.compassLogoImageView.showScaleEffectAnimated()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.pushToMainView()
            }
        }
        
    }
    
    func pushToMainView() {
        UIView.animate(withDuration: 3.0) {
            if let mainView = UIStoryboard(name: MainScreenVC.storyboard, bundle: nil)
                .instantiateViewController(withIdentifier: MainScreenVC.identifier) as? MainScreenVC {
                mainView.setViewModel(viewModel: MainViewScreenViewModel())
                mainView.modalPresentationStyle = .fullScreen
                self.present(mainView, animated: false)
            }
        }
    }
}
