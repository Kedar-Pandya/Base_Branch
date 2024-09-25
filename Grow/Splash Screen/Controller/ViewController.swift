//
//  ViewController.swift
//  Grow
//
//  Created by Kedarnath Pandya on 24/09/24.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    private var animationView: LottieAnimationView?
    
    @IBOutlet weak var logoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        animationView = .init(name: "plant.json")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.animationSpeed = 0.5
        view.addSubview(animationView!)
        
        animationView?.play{ [weak self] finished in
            if finished {
                self?.navigateToHomeVC()
            }
        }
        
        view.addSubview(logoView)
        logoView.alpha = 0.0
        logoView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 8.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.logoView.alpha = 1.0
            self.logoView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func navigateToHomeVC() {
        let vc = HomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

