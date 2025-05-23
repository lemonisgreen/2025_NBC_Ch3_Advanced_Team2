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
    
    let timePicker = UIPickerView()
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    // 현재 선택된 값
    let selectedHours = BehaviorRelay<Int>(value: 0)
    let selectedMinutes = BehaviorRelay<Int>(value: 0)
    let selectedSeconds = BehaviorRelay<Int>(value: 0)
    
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
        timePicker.delegate = self
        timePicker.dataSource = self
        configureUI()
        bind()
    }
    
    func bind() {
        presetButtons.forEach { button in
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    let minutes = button.tag
                    self?.selectedHours.accept(0)
                    self?.selectedMinutes.accept(minutes)
                    self?.selectedSeconds.accept(0)
                    self?.timePicker.selectRow(0, inComponent: 0, animated: true)
                    self?.timePicker.selectRow(minutes, inComponent: 1, animated: true)
                    self?.timePicker.selectRow(0, inComponent: 2, animated: true)
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
        let timerSeconds = selectedHours.value * 3600 + selectedMinutes.value * 60 + selectedSeconds.value
        let soundOn = soundSwitch.isOn
        let vibrateOn = vibrateSwitch.isOn
        let labelText = labelTextField.text ?? ""
        
        CoreDataManage.shared.saveTimer(timerTime: Int32(timerSeconds), timerSound: soundOn, timerVibration: vibrateOn, timerLabel: labelText)
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
        
        [timePicker, presetButtonStackView, soundStackView, labelStackView, startButton].forEach {
            view.addSubview($0)
        }
        
        timePicker.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(58)
            $0.top.equalToSuperview().offset(90)
        }
        
        presetButtonStackView.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(37)
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

// PickerView DataSource & Delegate
extension TimerSettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // PickerView에 표시할 컴포넌트(열)의 수 지정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // 시, 분, 초의 3가지 컴포넌트 사용
    }
    // 각 컴포넌트에 표시할 행의 수 설정
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return hours.count // (시) 0 ~ 23, 24개의 행
        case 1: return minutes.count // (분) 0 ~ 59, 60개의 행
        case 2: return seconds.count // (초) 0 ~ 59, 60개의 행
        default: return 0
        }
    }
    // 각 행에 표시할 텍스트 반환
    // pickerView(_:titleForRow:forComponent:) 대신 pickerView(_:attributedTitleForRow:forComponent:) 메서드를 구현하면, 글자에 원하는 색상이나 폰트 같은 속성을 줄 수 있음.
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title: String
        switch component {
        case 0:
            title = "\(hours[row])시간"
        case 1:
            title = "\(minutes[row])분"
        case 2:
            title = "\(seconds[row])초"
        default:
            return nil
        }
        // 흰색 글자색으로 NSAttributedString 생성
        return NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.white])
    }
    // 사용자가 PickerView의 값을 선택했을 때 호출되는 메서드
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedHours.accept(hours[row]) // 선택된 시 값을 BehaviorRelay에 반영
        case 1:
            selectedMinutes.accept(minutes[row]) // 선택된 분 값을 BehaviorRelay에 반영
        case 2:
            selectedSeconds.accept(seconds[row]) // 선택된 초 값을 BehaviorRelay에 반영
        default:
            break
        }
    }
}
