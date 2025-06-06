//
//  AlarmListCell.swift
//  Allarm
//
//  Created by Jin Lee on 5/21/25.
//

import UIKit
import SnapKit

class AlarmListCell: UITableViewCell {
    static let id = "AlarmListCell"
    
    let alarmTitleLabel = UILabel()
    let alarmTimeLabel = UILabel()
    let alarmDateLabel = UILabel()
    let alarmSoundImageView = UIImageView()
    let alarmMuteImageView = UIImageView()
    let alarmAmPmLabel = UILabel()
    let alarmSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.font2.withAlphaComponent(0.1)
        
    }
    
    private func setupCell() {
        
        self.backgroundColor = .background
        
        alarmTitleLabel.textColor = .font1
        alarmTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        alarmTimeLabel.textColor = .font1
        alarmTimeLabel.font = .systemFont(ofSize: 48, weight: .medium)
        
        alarmAmPmLabel.textColor = .font1
        alarmAmPmLabel.font = .systemFont(ofSize: 24, weight: .medium)
        
        alarmDateLabel.textColor = .font1
        alarmDateLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        alarmSoundImageView.image = UIImage(systemName: "speaker.wave.2.fill")
        alarmSoundImageView.tintColor = .sub1
        
        alarmMuteImageView.image = UIImage(systemName: "iphone.gen2.radiowaves.left.and.right")
        alarmMuteImageView.tintColor = .sub1
        
        alarmSwitch.onTintColor = UIColor(named: "sub1")
        alarmSwitch.backgroundColor = UIColor(named: "font2")
        alarmSwitch.layer.cornerRadius = alarmSwitch.frame.height / 2
        alarmSwitch.isOn = true
        alarmSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc private func switchChanged() {
        if alarmSwitch.isOn {
            alarmSoundImageView.tintColor = .sub1
            alarmMuteImageView.tintColor = .sub1
            alarmDateLabel.textColor = .font1
            alarmTimeLabel.textColor = .font1
            alarmAmPmLabel.textColor = .font1
            print("알람 활성화됨 (ON)")
        } else {
            alarmSoundImageView.tintColor = .font2
            alarmMuteImageView.tintColor = .font2
            alarmDateLabel.textColor = .font2
            alarmTimeLabel.textColor = .font2
            alarmAmPmLabel.textColor = .font2
            print("알람 비활성화됨 (OFF)")
        }
        // 나중에 기능 추가
    }
    
    func configureCell() {
        [
            alarmTitleLabel,
            alarmTimeLabel,
            alarmAmPmLabel,
            alarmDateLabel,
            alarmSoundImageView,
            alarmMuteImageView,
            alarmSwitch,
            
        ].forEach{
            contentView.addSubview($0)
        }
        
        alarmTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(22)
        }
        
        alarmTimeLabel.snp.makeConstraints {
            $0.top.equalTo(alarmTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalTo(133)
            $0.height.equalTo(56)
        }
        
        alarmAmPmLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.equalTo(alarmTimeLabel.snp.trailing).offset(0)
            $0.width.equalTo(37)
            $0.height.equalTo(28)
        }
        
        alarmDateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.equalTo(alarmAmPmLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.equalTo(170)
            $0.height.equalTo(28)
        }
        
        alarmSoundImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(alarmTitleLabel.snp.trailing).offset(8)
            $0.width.equalTo(28)
            $0.height.equalTo(24)
        }
        
        alarmMuteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(alarmTitleLabel.snp.trailing).offset(8)
            $0.width.equalTo(35)
            $0.height.equalTo(24)
        }
        
        alarmSwitch.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

