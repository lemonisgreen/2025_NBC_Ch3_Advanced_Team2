//
//  TimerListTabBarController.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit

class TimerListTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "sub2")
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "main")
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "main") ?? .white]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "background")
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "background") ?? .gray]
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = UIColor(named: "sub2")
            tabBar.tintColor = UIColor(named: "main")
            tabBar.unselectedItemTintColor = UIColor(named: "background")
        }

        let timerViewController = TimerListViewController()
        timerViewController.tabBarItem = UITabBarItem(title: "타이머", image: UIImage(systemName: "timer"), tag: 0)
        
        let alarmViewController = TabBarAlarmViewController()
        alarmViewController.tabBarItem = UITabBarItem(title: "알람", image: UIImage(systemName: "alarm"), tag: 1)
        
        let stopWatchViewController = TabBarStopwatchViewController()
        stopWatchViewController.tabBarItem = UITabBarItem(title: "스톱워치", image: UIImage(systemName: "stopwatch"), tag: 2)
        
        viewControllers = [timerViewController, alarmViewController, stopWatchViewController]
    }
    
    
}
