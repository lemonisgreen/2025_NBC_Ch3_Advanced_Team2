//
//  AlarmListViewController.swift
//  Allarm
//
//  Created by Jin Lee on 5/21/25.
//

import UIKit
import SnapKit
import CoreData

class AlarmListViewController: UIViewController {
    
    var viewModel = AlarmListViewModel()
    
    let alarmLabel = UILabel()
    let addAlarmButton = UIButton()
    
    private var alarmList = [Alarm]()
    private lazy var alarmListTableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
    }
    
    @objc func addAlarmButtonTapped() {
        
    }
    
    private func setupUI() {
        
        view.backgroundColor = .backgrond
        
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
        alarmListTableView.backgroundColor = .backgrond
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
            $0.top.equalToSuperview().inset(66)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        addAlarmButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().inset(66)
            $0.width.height.equalTo(30)
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
        let modalVC = MainViewController()//나중에 변경해야 함
        
        self.present(modalVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexpath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.beginUpdates() // beginUpdate
            alarmList.remove(at: indexPath.row) // 데이터 소스에서 해당 셀의 데이터 삭제
            tableView.deleteRows(at: [indexPath], with: .fade) // 셀 삭제 애니메이션 설정
            //CoreData 삭제
            tableView.endUpdates() // endUpdate
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListCell.id, for: indexPath) as? AlarmListCell else {
            return UITableViewCell()
        }
        //        let alarm = alarmList[indexPath.row]
        //
        //        cell.alarmTitleLabel.text = alarm.alarmLabel
        //        cell.alarmTimeLabel.text = String(alarm.alarmTime)
        //        // 데이터 추가해야 함
        //        //cell.alarmAmPmLabel.text = alarmList[indexPath.row]
        //
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return alarmList.count
        return 10
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
