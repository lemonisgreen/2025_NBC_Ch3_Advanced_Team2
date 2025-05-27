//
//  RecentTimerTableView.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit

class RecentTimerTableView : UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
            setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        separatorStyle = .none
        
        self.register(RecentTimerCell.self, forCellReuseIdentifier: RecentTimerCell.id)
    }
}
