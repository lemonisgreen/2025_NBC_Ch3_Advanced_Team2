//  TimerListView.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.

import UIKit
import SnapKit

class TimerListView: UIView {

    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let runningLabel: UILabel = {
        let label = UILabel()
        label.text = "실행중인 타이머"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    let timerAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()

    let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 항목"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    let runningTimerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.tableFooterView = UIView()
        tableView.register(RunningTimerCell.self, forCellReuseIdentifier: RunningTimerCell.id)
        tableView.rowHeight = 80
        return tableView
    }()

    let recentTimerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.tableFooterView = UIView()
        tableView.register(RecentTimerCell.self, forCellReuseIdentifier: RecentTimerCell.id)
        tableView.rowHeight = 80
        return tableView
    }()

    private var runningTableHeightConstraint: Constraint?
    private var recentTableHeightConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = UIColor(named: "background")

        addSubview(timerLabel)
        addSubview(timerAddButton)
        addSubview(runningLabel)
        addSubview(runningTimerTableView)
        addSubview(recentLabel)
        addSubview(recentTimerTableView)

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            make.centerX.equalToSuperview()
        }

        timerAddButton.snp.makeConstraints { make in
            make.centerY.equalTo(timerLabel)
            make.trailing.equalToSuperview().inset(20)
        }

        runningLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(10)
        }

        runningTimerTableView.snp.makeConstraints { make in
            make.top.equalTo(runningLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            self.runningTableHeightConstraint = make.height.equalTo(0).constraint
        }

        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(runningTimerTableView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(10)
        }

        recentTimerTableView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
            self.recentTableHeightConstraint = make.height.equalTo(0).constraint
        }
    }

    func updateTableHeights(runningCount: Int, recentCount: Int) {
        let rowHeight: CGFloat = 80
        runningTableHeightConstraint?.update(offset: rowHeight * CGFloat(runningCount))
        recentTableHeightConstraint?.update(offset: rowHeight * CGFloat(recentCount))
    }
}
