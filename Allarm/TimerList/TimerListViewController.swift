import UIKit
import RxSwift
import RxCocoa

class TimerListViewController: UIViewController {

    private let mainView = TimerListView()
    private let viewModel = TimerListViewModel()
    private let disposeBag = DisposeBag()

    
    override func loadView() {
        let baseView = UIView()
        baseView.backgroundColor = .systemBackground
        self.view = baseView

        baseView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: baseView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.runningTimerTableView.delegate = self
        mainView.recentTimerTableView.delegate = self
        
        bindViewModel()
        viewModel.loadInitialData()
        
        // + 버튼 눌렀을 때 타이머 설정 화면 이동
        mainView.timerAddButton.rx.tap
            .bind { [weak self] in
                self?.showTimerSetting()
            }
            .disposed(by: disposeBag)
    }

    // ViewModel 바인딩
    private func bindViewModel() {
        // 실행 중인 타이머
        viewModel.runningTimers
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] timers in
                self?.mainView.updateTableHeights(
                    runningCount: timers.count,
                    recentCount: self?.viewModel.recentTimers.value.count ?? 0
                )
            })
            .bind(to: mainView.runningTimerTableView.rx.items(
                cellIdentifier: RunningTimerCell.id,
                cellType: RunningTimerCell.self)
            ) { [weak self] index, model, cell in
                cell.configure(with: model)

                cell.playPauseButton.rx.tap
                    .bind { self?.viewModel.togglePlayPause(for: model, isRecent: false) }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        // 최근 타이머
        viewModel.recentTimers
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] timers in
                self?.mainView.updateTableHeights(
                    runningCount: self?.viewModel.runningTimers.value.count ?? 0,
                    recentCount: timers.count
                )
            })
            .bind(to: mainView.recentTimerTableView.rx.items(
                cellIdentifier: RecentTimerCell.id,
                cellType: RecentTimerCell.self)
            ) { [weak self] index, model, cell in
                cell.configure(with: model)

                cell.playPauseButton.rx.tap
                    .bind { self?.viewModel.togglePlayPause(for: model, isRecent: true) }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }

    // 타이머 설정 화면 이동
    @objc private func showTimerSetting() {
        let settingVC = TimerSettingViewController()
        settingVC.newTimerSubject
            .bind { [weak self] model in
                self?.viewModel.addTimer(model)
            }
            .disposed(by: disposeBag)

        settingVC.modalPresentationStyle = .fullScreen
        present(settingVC, animated: true)
    }
}


extension TimerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {  // 각 셀 높이 설정
        return 130
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { // 푸터뷰 제거용
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // 셀 스와이프 삭제 기능 추가

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            guard let self = self else { return }

            if tableView == self.mainView.runningTimerTableView {
                self.viewModel.deleteRunningTimer(at: indexPath.row)
            } else if tableView == self.mainView.recentTimerTableView {
                self.viewModel.deleteRecentTimer(at: indexPath.row)
            }

            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
