//
//  TimerListViewController.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import RxSwift
import RxCocoa

class TimerListViewController: UIViewController {

    private let mainView = TimerListView()
    private let viewModel = TimerListViewModel()
    private let disposeBag = DisposeBag()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindTableViews()
        viewModel.loadInitialData()
        
        mainView.timerAddButton.rx.tap
            .bind { [weak self] in
                self?.showTimerSetting()
            }
            .disposed(by: disposeBag)
    }

    private func configure() {
        mainView.recentTimerTableView.register(RecentTimerCell.self, forCellReuseIdentifier: RecentTimerCell.id)
        mainView.runningTimerTableView.register(RunningTimerCell.self, forCellReuseIdentifier: RunningTimerCell.id)

        [mainView.recentTimerTableView, mainView.runningTimerTableView].forEach {
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
        }
    }

    private func bindTableViews() {
        viewModel.runningTimers
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] runningTimers in
                let recentCount = self?.viewModel.recentTimers.value.count ?? 0
                self?.mainView.updateTableHeights(runningCount: runningTimers.count, recentCount: recentCount)
            })
            .bind(to: mainView.runningTimerTableView.rx.items(cellIdentifier: RunningTimerCell.id, cellType: RunningTimerCell.self)) { [weak self] index, model, cell in
                cell.configure(with: model)
                cell.soundButton.rx.tap
                    .bind { self?.viewModel.runningSoundToggleTapped.onNext(index) }
                    .disposed(by: cell.disposeBag)

                cell.vibrateButton.rx.tap
                    .bind { self?.viewModel.runningVibrateToggleTapped.onNext(index) }
                    .disposed(by: cell.disposeBag)

                cell.playPauseButton.rx.tap
                    .bind { self?.viewModel.runningPlayPauseTapped.onNext(index) }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        viewModel.recentTimers
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] recentTimers in
                let runningCount = self?.viewModel.runningTimers.value.count ?? 0
                self?.mainView.updateTableHeights(runningCount: runningCount, recentCount: recentTimers.count)
            })
            .bind(to: mainView.recentTimerTableView.rx.items(cellIdentifier: RecentTimerCell.id, cellType: RecentTimerCell.self)) { [weak self] index, model, cell in
                cell.configure(with: model)
                cell.soundButton.rx.tap
                    .bind { self?.viewModel.recentSoundToggleTapped.onNext(index) }
                    .disposed(by: cell.disposeBag)

                cell.vibrateButton.rx.tap
                    .bind { self?.viewModel.recentVibrateToggleTapped.onNext(index) }
                    .disposed(by: cell.disposeBag)

                cell.playPauseButton.rx.tap
                    .bind { self?.viewModel.recentPlayPauseTapped.onNext(index) }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    
    @objc private func showTimerSetting() {
        let vc = UIViewController() // 임시 빈 뷰컨
        vc.view.backgroundColor = .black

        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
