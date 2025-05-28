//
//  TimerListView.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TimerListView: UIView {

    let scrollView = UIScrollView()
    let contentStack = UIStackView()
    let topBar = UIView()

    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let timerAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()

    let runningLabel: UILabel = {
        let label = UILabel()
        label.text = "실행중인 타이머"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    let runningTimerTableView: RunningTimerTableView = {
        let tableView = RunningTimerTableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 12
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.tableFooterView = UIView()
        return tableView
    }()

    let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 항목"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    let recentTimerTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 12
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.tableFooterView = UIView()
        
        tableView.register(RecentTimerCell.self, forCellReuseIdentifier: RecentTimerCell.id)
        
        return tableView
    }()

    let bottomSpaceView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = UIColor(named: "background")
        
        
        addSubview(topBar)
        topBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(0)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.alignment = .fill
        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.width.equalToSuperview().offset(-32)
        }

        topBar.addSubview(timerLabel)
        topBar.addSubview(timerAddButton)
        timerLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.center.equalToSuperview()
        }
        timerAddButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        // 스택뷰에 실행중인 타이머 요소들 추가
        contentStack.addArrangedSubview(runningLabel)
        contentStack.setCustomSpacing(4, after: runningLabel)
        contentStack.addArrangedSubview(runningTimerTableView)
        
        // 스택뷰에 최근 타이머 요소들 추가
        contentStack.addArrangedSubview(recentLabel)
        contentStack.setCustomSpacing(4, after: recentLabel)
        contentStack.addArrangedSubview(recentTimerTableView)
        contentStack.addArrangedSubview(bottomSpaceView)
        bottomSpaceView.snp.makeConstraints { $0.height.equalTo(40) }
    }
    
    // 셀 개수에 따라 높이 동적으로 설정
    func updateTableHeights(runningCount: Int, recentCount: Int) {
        runningTimerTableView.snp.updateConstraints { make in
            make.height.equalTo(max(CGFloat(runningCount) * 160, 160))
        }
        recentTimerTableView.snp.updateConstraints { make in
            make.height.equalTo(max(CGFloat(recentCount) * 160, 160))
        }
    }
}
