//
//  timerListView.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit

class timerListView : UIView {

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
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(runningTimerCell.self, forCellReuseIdentifier: runningTimerCell.id)
        tableView.rowHeight = 80
        return tableView
    }()

    let recentTimerTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(recentTimerCell.self, forCellReuseIdentifier: recentTimerCell.id)
        tableView.rowHeight = 80
        return tableView
    }()

    let runningTableContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "sub2")?.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    let recentTableContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "sub2")?.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = UIColor(named: "background")

        runningTableContainer.addSubview(runningTimerTableView)
        recentTableContainer.addSubview(recentTimerTableView)

        [timerLabel, timerAddButton, runningLabel, runningTableContainer, recentLabel, recentTableContainer].forEach {
            addSubview($0)
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            make.centerX.equalToSuperview()
        }

        runningLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(10)
        }

        timerAddButton.snp.makeConstraints { make in
            make.centerY.equalTo(timerLabel)
            make.trailing.equalToSuperview().inset(20)
        }

        runningTableContainer.snp.makeConstraints { make in
            make.top.equalTo(runningLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }

        runningTimerTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(runningTableContainer.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(10)
        }

        recentTableContainer.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
        }

        recentTimerTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
