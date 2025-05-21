//
//  timerListTabBarController.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit

class timerListTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        self.viewDidLoad()
        
        
        let alarmViewController = tabBarAlarmViewController()
        alarmViewController.tabBarItem = UITabBarItem(title: "알람", image: UIImage(systemName: "alarm"), tag: 0)
        
        let timerViewController = timerListViewController()
        timerViewController.tabBarItem = UITabBarItem(title: "타이머", image: UIImage(systemName: "timer"), tag: 1)
        
        let stopWatchViewController = tabBarStopwatchViewController()
        stopWatchViewController.tabBarItem = UITabBarItem(title: "스톱워치", image: UIImage(systemName: "stopwatch"), tag: 2)
        
        viewControllers = [timerViewController]
    }
    
    
}
