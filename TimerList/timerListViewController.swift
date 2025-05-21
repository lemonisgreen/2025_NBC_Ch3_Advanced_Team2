//
//  timerListViewController.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit

class timerListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let recentTimerTableView = recentTimerTableView()
    private let runningTimerTableView = runningTimerTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(recentTimerTableView)
        view.addSubview(runningTimerTableView)
        
        recentTimerTableView.delegate = self
        recentTimerTableView.dataSource = self
        recentTimerTableView.register(recentTimerCell.self, forCellReuseIdentifier:  recentTimerCell.id)
        
        runningTimerTableView.delegate = self
        runningTimerTableView.dataSource = self
        runningTimerTableView.register(runningTimerTableView.self, forCellReuseIdentifier: runningTimerCell.id)
        
        recentTimerTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        runningTimerTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension timerListViewController {
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableview: UITableView, cellForRowAt: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: recentTimerCell.id, for: IndexPath) as? recentTimerCell else {
            return UITableViewCell()
        }
    }
}
