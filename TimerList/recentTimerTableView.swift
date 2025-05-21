//
//  recentTimerTableView.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit

class recentTimerTableView : UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
            setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        backgroundColor = .gray
        separatorStyle = .none
        rowHeight = 40
        
        self.register(recentTimerCell.self, forCellReuseIdentifier: recentTimerCell.id)
    }
}
