//
//  AlarmSettingViewController.swift
//  Allarm
//
//  Created by 형윤 on 5/21/25.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AlarmSettingViewController: UIViewController {
    
    let alarmListViewModel = AlarmListViewModel()
    let viewModel = AlarmSettingViewModel()
    let disposeBag = DisposeBag()
    
    // UI 컴포넌트
    private let datePicker = UIDatePicker()
    
    private let repeatSection = UIView()
    private let repeatTitleLabel = UILabel()
    private let dayTitles = ["월", "화", "수", "목", "금", "토", "일"]
    private var dayButtons: [UIButton] = []
    
    private let soundSection = UIView()
    private let soundTitleLabel = UILabel()
    private let soundLabel = UILabel()
    private let soundSwitch = UISwitch()
    private let MuteLabel = UILabel()
    private let MuteSwitch = UISwitch()
    
    private let labelSection = UIView()
    private let labelTitleLabel = UILabel()
    private let alarmLabelField = UITextField()
    
    private let saveButton = UIButton()
    
    // 뷰 로드될 때 실행되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        setupUI()
        bindViewModel()
        
        // 저장버튼 누르면 모달 내려가게
        viewModel.saveCompleted
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
                NotificationCenter.default.post(name: .alarmDidUpdate, object: nil)
                
            })
            .disposed(by: disposeBag)
    }
    
    
    
    private func setupUI() {
        
        let font2Background = UIColor(named: "font2")?.withAlphaComponent(0.1) // 라벨들의 배경 색
        
        // 시간 선택 피커
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor(named: "font1"), forKey: "textColor")
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        // 요일 섹션
        repeatSection.backgroundColor = font2Background
        repeatSection.layer.cornerRadius = 10
        view.addSubview(repeatSection)
        repeatSection.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        // 반복 라벨
        repeatTitleLabel.text = "반복"
        repeatTitleLabel.textColor = UIColor(named: "font1")
        repeatTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        repeatSection.addSubview(repeatTitleLabel)
        repeatTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        // 요일 버튼
        dayTitles.forEach { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor(named: "font1"), for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 8
            button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
            repeatSection.addSubview(button)
            dayButtons.append(button)
        }
        
        // 요일 버튼 위치
        for (i, button) in dayButtons.enumerated() {
            button.snp.makeConstraints {
                $0.top.equalTo(repeatTitleLabel.snp.bottom).offset(15)
                $0.leading.equalToSuperview().offset(40 + i * 40)
                $0.width.height.equalTo(30)
            }
        }
        
        // 사운드 섹션
        soundSection.backgroundColor = font2Background
        soundSection.layer.cornerRadius = 10
        view.addSubview(soundSection)
        soundSection.snp.makeConstraints {
            $0.top.equalTo(repeatSection.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        // 사운드 라벨
        soundTitleLabel.text = "사운드"
        soundTitleLabel.textColor = UIColor(named: "font1")
        soundTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        soundSection.addSubview(soundTitleLabel)
        soundTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        // 소리 라벨 & 스위치
        soundLabel.text = "소리"
        soundLabel.textColor = UIColor(named: "font1")
        soundLabel.font = .systemFont(ofSize: 17, weight: .medium)
        soundSection.addSubview(soundLabel)
        soundLabel.snp.makeConstraints {
            $0.top.equalTo(soundTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        soundSwitch.onTintColor = UIColor(named: "sub1")
        soundSwitch.backgroundColor = UIColor(named: "font2")
        soundSwitch.layer.cornerRadius = soundSwitch.frame.height / 2
        soundSection.addSubview(soundSwitch)
        soundSwitch.snp.makeConstraints {
            $0.centerY.equalTo(soundLabel)
            $0.leading.equalTo(soundLabel.snp.trailing).offset(20)
        }
        
        // 무음 라벨 & 스위치
        MuteLabel.text = "무음모드"
        MuteLabel.textColor = UIColor(named: "font1")
        MuteLabel.font = .systemFont(ofSize: 17, weight: .medium)
        soundSection.addSubview(MuteLabel)
        MuteLabel.snp.makeConstraints {
            $0.centerY.equalTo(soundLabel)
            $0.leading.equalTo(soundSwitch.snp.trailing).offset(100)
        }
        
        MuteSwitch.onTintColor = UIColor(named: "sub1")
        MuteSwitch.backgroundColor = UIColor(named: "font2")
        MuteSwitch.layer.cornerRadius = soundSwitch.frame.height / 2
        soundSection.addSubview(MuteSwitch)
        MuteSwitch.snp.makeConstraints {
            $0.centerY.equalTo(soundSwitch)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        // 라벨 섹션
        labelSection.backgroundColor = font2Background
        labelSection.layer.cornerRadius = 10
        view.addSubview(labelSection)
        labelSection.snp.makeConstraints {
            $0.top.equalTo(soundSection.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
        
        labelTitleLabel.text = "라벨"
        labelTitleLabel.textColor = UIColor(named: "font1")
        labelTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        labelSection.addSubview(labelTitleLabel)
        labelTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        alarmLabelField.borderStyle = .roundedRect
        alarmLabelField.textColor = .black
        alarmLabelField.backgroundColor = UIColor(named: "sub2")
        alarmLabelField.placeholder = ""
        labelSection.addSubview(alarmLabelField)
        alarmLabelField.snp.makeConstraints {
            $0.top.equalTo(labelTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        // 저장 버튼
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        saveButton.backgroundColor = UIColor(named: "sub1")
        saveButton.layer.cornerRadius = 10
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalTo(labelSection.snp.bottom).offset(30)
            $0.leading.equalTo(labelSection.snp.leading)
            $0.trailing.equalTo(labelSection.snp.trailing)
            $0.height.equalTo(60)
        }
    }
    
    private func bindViewModel() { // ViewModel 바인딩
        datePicker.rx.date // 선택된 시간을 Int로 변환
            .map { Calendar.current.component(.hour, from: $0) * 60 + Calendar.current.component(.minute, from: $0) }
            .bind(to: viewModel.alarmTime)
            .disposed(by: disposeBag)
        
        soundSwitch.rx.isOn // 스위치 상태를 ViewModel에 바인딩
            .bind(to: viewModel.alarmSound)
            .disposed(by: disposeBag)
        
        MuteSwitch.rx.isOn
            .bind(to: viewModel.alarmMute)
            .disposed(by: disposeBag)
        
        alarmLabelField.rx.text.orEmpty
            .bind(to: viewModel.alarmLabel)
            .disposed(by: disposeBag)
        
        for (index, button) in dayButtons.enumerated() { // 요일 버튼 클릭 시 ViewModel 상태 업데이트
            button.rx.tap
                .subscribe(onNext: {
                    var current = self.viewModel.alarmDate.value
                    let weekdaysMap: [Int32] = [2, 3, 4, 5, 6, 7, 1] // 월~일 순서
                    let day = weekdaysMap[index] // 월~일을 1~7로 변환
                    if current.contains(day) {
                        current.removeAll{$0 == day}
                        button.setTitleColor(UIColor(named: "font1"), for: .normal)
                    } else {
                        current.append(day)
                        button.setTitleColor(UIColor(named: "main"), for: .normal)
                    }
                    self.viewModel.alarmDate.accept(current)
                })
                .disposed(by: disposeBag)
        }
        
        saveButton.rx.tap //저장 버튼 탭 시 ViewModel에 이벤트 전달
            .bind(to: viewModel.saveTapped)
            .disposed(by: disposeBag)        
        
        //소리,무음모드 중복방지
        soundSwitch.rx.isOn
            .skip(1)
            .subscribe(onNext: {[weak self] isOn in
                if isOn {
                    self?.MuteSwitch.setOn(false, animated: true)
                    self?.viewModel.alarmMute.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        MuteSwitch.rx.isOn
            .skip(1)
            .subscribe(onNext: {[weak self] isOn in
                if isOn {
                    self?.soundSwitch.setOn(false, animated: true)
                    self?.viewModel.alarmSound.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
    }
}
