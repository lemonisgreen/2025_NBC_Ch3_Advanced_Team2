//
//  BottomTabBarController.swift
//  Allarm
//
//  Created by Jin Lee on 5/25/25.
//

import UIKit

class BottomTabBarController: UITabBarController {
    
    let AlarmVC = AlarmListViewController()
    let mainVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = [AlarmVC, mainVC]
        self.viewControllers = controllers
        
        setupTabBar()
        configureTabBar()
    }
    
    private func setupTabBar() {
        
        AlarmVC.tabBarItem = UITabBarItem(title: "알람", image: UIImage(systemName: "alarm"), tag: 1)
        AlarmVC.tabBarItem.selectedImage = UIImage(systemName: "alarm.fill")
        
        mainVC.tabBarItem = UITabBarItem(title: "타이머", image: UIImage(systemName: "timer"), tag: 0)
        mainVC.tabBarItem.selectedImage = UIImage(systemName: "gauge.with.needle.fill")
    }
    
    private func configureTabBar() {
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        
        let appearance = UITabBarAppearance()
        
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        //standardAppearance랑 scrollEdgeAppearance 둘 다 지정해줘야 UITabBarAppearance()에 지정한 스타일이 먹음.
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = .sub2
        UITabBar.appearance().tintColor = .main
        UITabBar.appearance().selectedItem?.setTitleTextAttributes(attributes, for: .normal)
        UITabBar.appearance().selectedItem?.setTitleTextAttributes(attributes, for: .selected)
    }
}
