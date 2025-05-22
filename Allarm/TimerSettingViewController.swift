//
//
//  TimerSettingVC.swift
//  alarmApp
//
//  Created by 김은서 on 5/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TimerSettingViewController: UIViewController {
    let disposeBag = DisposeBag()
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.overrideUserInterfaceStyle = .dark
        return datePicker
    }()
    
    // 프리셋 버튼들
    let presetButtons: [UIButton] = {
        let titles = ["1분", "2분", "3분", "5분", "10분"]
        return titles.map { title in
            let button = UIButton()
            button.backgroundColor = .sub1
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            button.setTitleColor(.backgrond, for: .normal)
            button.layer.cornerRadius = 25
            button.clipsToBounds = true
            button.snp.makeConstraints { $0.size.equalTo(50) }
             
            // title에서 숫자만 추출해서 tag에 할당
            if let number = Int(title.replacingOccurrences(of: "분", with: "")) {
                button.tag = number
            }
            
            return button
        }
    }()
    
    lazy var presetButtonStackView: UIStackView = {
        let label = UILabel()
        label.text = "프리셋"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        
        let horizontalStackView = UIStackView(arrangedSubviews: presetButtons)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        
        let verticalStackView = UIStackView(arrangedSubviews: [label, horizontalStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
        verticalStackView.layer.cornerRadius = 10
        verticalStackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 9, right: 12)
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        
        return verticalStackView
    }()
    
    let soundSwitch = UISwitch()
    let vibrateSwitch = UISwitch()
    
    lazy var soundStackView: UIStackView = {
        let label = UILabel()
        label.text = "사운드"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        
        let soundLabel = UILabel()
        soundLabel.text = "소리"
        soundLabel.font = .systemFont(ofSize: 17, weight: .bold)
        soundLabel.textColor = .white
        soundSwitch.onTintColor = .sub1
        
        let soundRow = UIStackView(arrangedSubviews: [soundLabel, soundSwitch])
        soundRow.axis = .horizontal
        soundRow.distribution = .fillEqually
        soundRow.alignment = .center
        soundRow.spacing = 6
        
        let vibrateLabel = UILabel()
        vibrateLabel.text = "진동"
        vibrateLabel.font = .systemFont(ofSize: 17, weight: .bold)
        vibrateLabel.textColor = .white
        vibrateSwitch.onTintColor = .sub1
        
        let vibrateRow = UIStackView(arrangedSubviews: [vibrateLabel, vibrateSwitch])
        vibrateRow.axis = .horizontal
        vibrateRow.distribution = .fillEqually
        vibrateRow.alignment = .center
        vibrateRow.spacing = 6
        
        let hideView = UIView()
        hideView.backgroundColor = .clear
        
        let horizontalStackView = UIStackView(arrangedSubviews: [soundRow, hideView, vibrateRow])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 16
        
        let verticalStackView = UIStackView(arrangedSubviews: [label, horizontalStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
        verticalStackView.layer.cornerRadius = 10
        verticalStackView.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 18, right: 20)
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        
        return verticalStackView
    }()
    
    let labelTextField = UITextField()
    
    lazy var labelStackView: UIStackView = {
        let label = UILabel()
        label.text = "라벨"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        
        labelTextField.borderStyle = .roundedRect
        labelTextField.textAlignment = .center
        labelTextField.textColor = .black
        labelTextField.backgroundColor = .sub2
        labelTextField.snp.makeConstraints {
            $0.width.equalTo(319)
            $0.height.equalTo(44)
        }
        
        let stackView = UIStackView(arrangedSubviews: [label, labelTextField])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
        stackView.layer.cornerRadius = 10
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("실행", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.backgrond, for: .normal)
        button.backgroundColor = .sub1
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    func bind() {
        presetButtons.forEach { button in
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    let minutes = button.tag
                    self.datePicker.countDownDuration = TimeInterval(minutes * 60)
                })
                .disposed(by: disposeBag)
        }
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.saveTimerSetting()
            })
            .disposed(by: disposeBag)
    }
    
    func saveTimerSetting() {
        // datePicker의 시간(초 단위)
        let timerSeconds = Int32(datePicker.countDownDuration)
        let soundOn = soundSwitch.isOn
        let vibrateOn = vibrateSwitch.isOn
        let labelText = labelTextField.text ?? ""
        
        CoreDataManage.shared.saveTimer(timerTime: timerSeconds, timerSound: soundOn, timerVibration: vibrateOn, timerLabel: labelText)
            .subscribe(
                onCompleted: {
                    print("타이머 설정 완료")
                    self.dismiss(animated: true)
                },
                onError: { error in
                    print("저장 실패: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        view.backgroundColor = .backgrond
        
        [datePicker, presetButtonStackView, soundStackView, labelStackView, startButton].forEach {
            view.addSubview($0)
        }
        
        datePicker.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(58)
            $0.top.equalToSuperview().offset(90)
        }
        
        presetButtonStackView.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        soundStackView.snp.makeConstraints {
            $0.top.equalTo(presetButtonStackView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(soundStackView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(351)
            $0.height.equalTo(60)
        }
    }
}

