//
//  AlarmListViewController.swift
//  Allarm
//
//  Created by Jin Lee on 5/21/25.
//

import UIKit
import SnapKit
import CoreData
import RxSwift

class AlarmListViewController: UIViewController {
    
    var viewModel = AlarmListViewModel()
    var disposeBag = DisposeBag()
    
    let alarmLabel = UILabel()
    let addAlarmButton = UIButton()
    
    private var alarmList = [Alarm]()
    private lazy var alarmListTableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        loadAlarms()
    }
    
    private func loadAlarms() {
        CoreDataManage.shared.fetchAlarm()
            .subscribe(onSuccess: { [weak self] alarms in
                self?.alarmList = alarms
                self?.alarmListTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func addAlarmButtonTapped() {
        print("버튼 클릭됨")
        let modalVC = AlarmSettingViewController()
        self.present(modalVC, animated: true, completion: nil)
        modalVC.modalPresentationStyle = .fullScreen
    }
    
    private func setupUI() {
        
        view.backgroundColor = .background
        
        alarmLabel.text = "알람"
        alarmLabel.textColor = .font1
        alarmLabel.font = .systemFont(ofSize: 24, weight: .medium)
        
        addAlarmButton.setTitle("+", for: .normal)
        addAlarmButton.setTitleColor(.font1, for: .normal)
        addAlarmButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        addAlarmButton.addTarget(self, action: #selector(addAlarmButtonTapped), for: .touchUpInside)
        
        alarmListTableView.dataSource = self
        alarmListTableView.delegate = self
        alarmListTableView.register(AlarmListCell.self, forCellReuseIdentifier: AlarmListCell.id)
        alarmListTableView.rowHeight = 110
        alarmListTableView.backgroundColor = .background
    }
    
    private func configureUI() {
        [
            alarmLabel,
            addAlarmButton,
            alarmListTableView,
        ].forEach {
            view.addSubview($0)
        }
        
        alarmLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        addAlarmButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.height.equalTo(44)
        }
        
        alarmListTableView.snp.makeConstraints {
            $0.top.equalTo(alarmLabel.snp.bottom).offset(38)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
            
        }
    }
}

extension AlarmListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexpath: IndexPath) {
        let modalVC = AlarmSettingViewController()
        
        self.present(modalVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexpath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmToDelete = alarmList[indexPath.section]
            
            CoreDataManage.shared.deleteAlarm(alarmId: alarmToDelete.alarmId)
                .subscribe(onCompleted: { [weak self] in
                    
                    self?.alarmList.remove(at: indexPath.section)
                    tableView.deleteSections([indexPath.section], with: .fade)
                }, onError: { error in
                    print("삭제 실패: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListCell.id, for: indexPath) as? AlarmListCell else {
            return UITableViewCell()
        }
        
        let alarm = alarmList[indexPath.row]
        
        // 알람 라벨 설정
        cell.alarmTitleLabel.text = alarm.alarmLabel
        
        // 시간 표시 설정
        let hour24 = Int(alarm.alarmTime) / 60
        let minute = Int(alarm.alarmTime) % 60
        var hour12 = hour24 % 12
        if hour12 == 0 { hour12 = 12 }

        cell.alarmTimeLabel.text = String(format: "%02d:%02d", hour12, minute)
        cell.alarmAmPmLabel.text = alarm.alarmAmPm
        
        // 요일 표시 설정
        let selectedDays = alarm.alarmDate.map { ($0) }
        let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
        let attributedString = NSMutableAttributedString()
        
        for (index, weekday) in weekdays.enumerated() {
            let weekdayNumber = index + 1
            let isSelected = selectedDays?.contains(Int32(weekdayNumber))
            let color = isSelected ?? isSelected! ? UIColor.main : UIColor.font1
            
            let attributedWeekday = NSAttributedString(
                string: "\(weekday)  ",
                attributes: [.foregroundColor: color]
            )
            attributedString.append(attributedWeekday)
        }
        
        if attributedString.length > 0 {
            attributedString.deleteCharacters(in: NSRange(
                location: attributedString.length - 1,
                length: 1
            ))
        }
        
        cell.alarmDateLabel.attributedText = attributedString
        
        // 사운드 or 진동모드 표시 설정
        cell.alarmSoundImageView.isHidden = !alarm.alarmSound
        cell.alarmMuteImageView.isHidden = !alarm.alarmMute
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alarmList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
