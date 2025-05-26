//
//  ViewController.swift
//  Allarm
//
//  Created by Jin Lee on 5/21/25.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let goToTimerButton = UIButton()
        goToTimerButton.setTitle("타이머 탭으로", for: .normal)
        goToTimerButton.addTarget(self, action: #selector(goToTimerTab), for: .touchUpInside)
        view.addSubview(goToTimerButton)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let timerVC = TimerListTabBarController()
        timerVC.modalPresentationStyle = .fullScreen
        present(timerVC, animated: true)
    }
    
    @objc func goToTimerTab() {
        let timerTabBar = TimerListTabBarController()
        navigationController?.pushViewController(timerTabBar, animated: true)
    }
    
    
}



