//
//  StopwatchVC.swift
//  Allarm
//
//  Created by 최영건 on 5/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class StopwatchViewController: UIViewController {

    private let titleLabel = UILabel()
    private let timerLabel = UILabel()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let lapTableView = UITableView()

    private let disposeBag = DisposeBag()
    private let viewModel = StopwatchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
        bindViewModel()
    }

    private func setupUI() {

        titleLabel.text = "스톱워치"
        titleLabel.textColor = .font1
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(62)
            $0.centerX.equalToSuperview()
        }

        timerLabel.font = .monospacedDigitSystemFont(ofSize: 80, weight: .light)
        timerLabel.textColor = .font1
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)

        timerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(128)
            $0.centerX.equalToSuperview()
        }

        leftButton.setTitle("재설정", for: .normal)
        leftButton.setTitleColor(.font1, for: .normal)
        leftButton.backgroundColor = .sub2
        leftButton.layer.cornerRadius = 35
        view.addSubview(leftButton)

        leftButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(291)
            $0.left.equalToSuperview().inset(36)
            $0.width.height.equalTo(70)
        }

        rightButton.setTitle("시작", for: .normal)
        rightButton.setTitleColor(.font1, for: .normal)
        rightButton.backgroundColor = .main
        rightButton.layer.cornerRadius = 35
        view.addSubview(rightButton)

        rightButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(291)
            $0.right.equalToSuperview().inset(36)
            $0.width.height.equalTo(70)

            lapTableView.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
            lapTableView.layer.cornerRadius = 12
            lapTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LapCell")
            view.addSubview(lapTableView)

            lapTableView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(389)
                $0.left.right.equalToSuperview().inset(12)
                $0.bottom.equalToSuperview().inset(110)
            }

        }
    }

    private func bindViewModel() {
        rightButton.rx.tap
            .bind(to: viewModel.toggleTrigger)
            .disposed(by: disposeBag)

        leftButton.rx.tap
            .bind(to: viewModel.resetOrLapTrigger)
            .disposed(by: disposeBag)

        viewModel.timerText
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.isRunning
            .subscribe(onNext: { [weak self] running in
                self?.rightButton.setTitle(running ? "중단" : "시작", for: .normal)
                self?.rightButton.backgroundColor = running ? .sub1 : .main
                self?.leftButton.setTitle(running ? "랩" : "재설정", for: .normal)
            }).disposed(by: disposeBag)

        viewModel.lapTimes
            .bind(to: lapTableView.rx.items(cellIdentifier: "LapCell")) { row, text, cell in
                cell.textLabel?.text = text
                cell.textLabel?.textColor = .font1
                cell.backgroundColor = .clear
            }.disposed(by: disposeBag)
    }
}
