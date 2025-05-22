//
//  timerListViewController.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit

class timerListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let mainView = timerListView()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.recentTimerTableView.delegate = self
        mainView.recentTimerTableView.dataSource = self
        
        mainView.runningTimerTableView.delegate = self
        mainView.runningTimerTableView.dataSource = self
               
    }
}

extension timerListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainView.recentTimerTableView {
            return 5
        } else if tableView == mainView.runningTimerTableView {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainView.recentTimerTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: recentTimerCell.id, for: indexPath) as? recentTimerCell {
                cell.recentTimerLabel.text = "최근 타이머 \(indexPath.row + 1)"
                return cell
            }
        } else if tableView == mainView.runningTimerTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: runningTimerCell.id, for: indexPath) as? runningTimerCell {
                cell.runningTimerLabel.text = "실행중 타이머 \(indexPath.row + 1)"
                return cell
            }
        }
        return UITableViewCell()
    }
}

