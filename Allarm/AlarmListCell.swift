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
    let alarmVibrationImageView = UIImageView()
    let alarmAmPmLabel = UILabel()
    
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
        
        let selectedAlarmDate = [String]()
        
        alarmTitleLabel.text = "예시라벨"
        alarmTitleLabel.textColor = .font1
        alarmTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        alarmTimeLabel.text = "10:28"
        alarmTimeLabel.textColor = .font1
        alarmTimeLabel.font = .systemFont(ofSize: 48, weight: .medium)
        
        alarmAmPmLabel.text = "AM"
        alarmAmPmLabel.textColor = .font1
        alarmAmPmLabel.font = .systemFont(ofSize: 24, weight: .medium)
        
        alarmDateLabel.text = "월 화 수 목 금 토 일"
        alarmDateLabel.textColor = .font1
        alarmDateLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        alarmSoundImageView.image = UIImage(systemName: "speaker.wave.2.fill")
        alarmSoundImageView.tintColor = .sub1
        //alarmSoundImageView.layer.frame.size = CGSize(width: 37, height: 37)
        
        alarmVibrationImageView.image = UIImage(systemName: "iphone.gen2.radiowaves.left.and.right")
        alarmVibrationImageView.tintColor = .sub1
        //alarmVibrationImageView.layer.frame.size = CGSize(width: 37, height: 37)
        
    }
    
    func configureCell() {
        [
            alarmTitleLabel,
            alarmTimeLabel,
            alarmAmPmLabel,
            alarmDateLabel,
            alarmSoundImageView,
            alarmVibrationImageView,
            
        ].forEach{
            contentView.addSubview($0)
        }
        
        alarmTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(8)
            $0.width.equalTo(260)
            $0.height.equalTo(22)
        }
        
        alarmTimeLabel.snp.makeConstraints {
            $0.top.equalTo(alarmTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalTo(130)
            $0.height.equalTo(56)
        }
        
        alarmAmPmLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.equalTo(alarmTimeLabel.snp.trailing).offset(1)
            $0.width.equalTo(37)
            $0.height.equalTo(28)
        }
        
        alarmDateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.equalTo(alarmAmPmLabel.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.equalTo(160)
            $0.height.equalTo(28)
        }
        
        alarmSoundImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(alarmTitleLabel.snp.trailing).offset(6)
            $0.width.equalTo(28)
            $0.height.equalTo(24)
        }
        
        alarmVibrationImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(alarmSoundImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(35)
            $0.height.equalTo(24)
        }
    }
}

