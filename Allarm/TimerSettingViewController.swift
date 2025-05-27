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
    
    let newTimerSubject = PublishSubject<TimerModel>()     // 타이머 모델 전달용 subject
    let timePicker = UIPickerView()
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    // 현재 선택된 값(초기화)
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
            button.setTitleColor(.background, for: .normal)
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
    
    lazy var presetButtonView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
        container.layer.cornerRadius = 10
        
        let label = UILabel()
        label.text = "프리셋"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        
        let horizontalStackView = UIStackView(arrangedSubviews: presetButtons)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        
        container.addSubview(label)
        container.addSubview(horizontalStackView)
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        return container
    }()
    
    let soundSwitch = UISwitch()
    let vibrateSwitch = UISwitch()
    
    lazy var soundView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
        container.layer.cornerRadius = 10
        
        let titleLabel = UILabel()
        titleLabel.text = "사운드"
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .white
        
        // 소리 라벨 & 스위치
        let soundLabel = UILabel()
        soundLabel.text = "알림"
        soundLabel.font = .systemFont(ofSize: 17, weight: .bold)
        soundLabel.textColor = .white
        soundSwitch.onTintColor = .sub1
        
        // 진동 라벨 & 스위치
        let vibrateLabel = UILabel()
        vibrateLabel.text = "무음 모드"
        vibrateLabel.font = .systemFont(ofSize: 17, weight: .bold)
        vibrateLabel.textColor = .white
        vibrateSwitch.onTintColor = .sub1
        
        [titleLabel, soundLabel, soundSwitch, vibrateLabel, vibrateSwitch].forEach {
            container.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        soundLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-18)
        }
        
        soundSwitch.snp.makeConstraints {
            $0.centerY.equalTo(soundLabel.snp.centerY)
            $0.leading.equalTo(soundLabel.snp.trailing).offset(20)
        }
        
        vibrateLabel.snp.makeConstraints {
            $0.centerY.equalTo(soundLabel.snp.centerY)
            $0.leading.equalTo(soundSwitch.snp.trailing).offset(80)
        }
        
        vibrateSwitch.snp.makeConstraints {
            $0.centerY.equalTo(vibrateLabel.snp.centerY)
            $0.leading.equalTo(vibrateLabel.snp.trailing).offset(20)
        }
        
        return container
    }()
    
    
    let labelTextField = UITextField()
    
    lazy var labelView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
        container.layer.cornerRadius = 10
        
        let label = UILabel()
        label.text = "라벨"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        
        labelTextField.borderStyle = .roundedRect
        labelTextField.textAlignment = .left
        labelTextField.textColor = .black
        labelTextField.backgroundColor = .sub2
        labelTextField.clearButtonMode = .whileEditing
        
        container.addSubview(label)
        container.addSubview(labelTextField)
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        labelTextField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.equalTo(319)
        }
        
        return container
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("실행", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.background, for: .normal)
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
    
    // 버튼 이벤트 바인드 함수
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
        
        
        //        soundSwitch.rx.isOn
        //            .skip(1)
        //            .distinctUntilChanged()
        //            .filter { $0 }
        //            .subscribe(onNext: { _ in
        //                if self.vibrateSwitch.isOn {
        //                    self.vibrateSwitch.setOn(false, animated: true)
        //                }
        //            })
        //            .disposed(by: disposeBag)
        //
        //        vibrateSwitch.rx.isOn
        //            .skip(1)
        //            .distinctUntilChanged()
        //            .filter { $0 }
        //            .subscribe(onNext: { _ in
        //                if self.soundSwitch.isOn {
        //                    self.soundSwitch.setOn(false, animated: true)
        //                }
        //            })
        //            .disposed(by: disposeBag)
        
        soundSwitch.rx.isOn
            .skip(1)
        // 불필요한 중복 이벤트를 제거
            .distinctUntilChanged()
            .subscribe(onNext: { isOn in
                if isOn {
                    self.vibrateSwitch.setOn(false, animated: true)
                    self.vibrateSwitch.isEnabled = false
                } else {
                    self.vibrateSwitch.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        vibrateSwitch.rx.isOn
            .skip(1)
        // 불필요한 중복 이벤트를 제거
            .distinctUntilChanged()
            .subscribe(onNext: { isOn in
                if isOn {
                    self.soundSwitch.setOn(false, animated: true)
                    self.soundSwitch.isEnabled = false
                } else {
                    self.soundSwitch.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.saveTimerSetting()
            })
            .disposed(by: disposeBag)
    }
    
    // 코어데이터에 저장
    func saveTimerSetting() {
        // datePicker의 시간(초 단위)
        let timerSeconds = selectedHours.value * 3600 + selectedMinutes.value * 60 + selectedSeconds.value
        let soundOn = soundSwitch.isOn
        let vibrateOn = vibrateSwitch.isOn
        let labelText = labelTextField.text ?? ""
        
        CoreDataManage.shared.saveTimer(timerTime: Int32(timerSeconds), timerSound: soundOn, timerVibration: vibrateOn, timerLabel: labelText, timerId: UUID(), timerPlay: Bool())
            .subscribe(
                onCompleted: { [weak self] in
                    guard let self = self else { return }

                    // 현재 recentTimers에 있는 타이머 중 동일 설정이 있는지 확인
                    let existingTimer = TimerListViewModel().recentTimers.value.first(where: {
                        $0.timerLabel == labelText &&
                        $0.timerTime == Int32(timerSeconds) &&
                        $0.timerSound == soundOn &&
                        $0.timerVibration == vibrateOn
                    })

                    // 기존 UUID 재사용 or 새로 생성
                    let newTimer = TimerModel(
                        timerId: existingTimer?.timerId ?? UUID(),
                        timerLabel: labelText,
                        timerPlay: true,
                        timerSound: soundOn,
                        timerTime: Int32(timerSeconds),
                        timerVibration: vibrateOn
                    )
                    
                    // 타이머 모델 만들어서 subject로 전달
//                    let newTimer = TimerModel(
//                        timerLabel: labelText,
//                        timerPlay: true,
//                        timerSound: soundOn,
//                        timerTime: Int32(timerSeconds),
//                        timerVibration: vibrateOn
//                    )

                    self.newTimerSubject.onNext(newTimer)  // ViewModel로 넘기기
                    self.dismiss(animated: true)           // 화면 닫기
                },
                onError: { error in
                    print("저장 실패: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        view.backgroundColor = .background
        
        [timePicker, presetButtonView, soundView, labelView, startButton].forEach {
            view.addSubview($0)
        }
        
        timePicker.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(58)
            $0.top.equalToSuperview().offset(90)
        }
        
        presetButtonView.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        soundView.snp.makeConstraints {
            $0.top.equalTo(presetButtonView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        labelView.snp.makeConstraints {
            $0.top.equalTo(soundView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(labelView.snp.bottom).offset(22)
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
    // widthForComponent 설정
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
}
