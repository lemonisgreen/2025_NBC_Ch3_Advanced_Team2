//
//  RecentTimerCell.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecentTimerCell: UITableViewCell {

    static let id = "recentTimerCell"
    var disposeBag = DisposeBag()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .darkGray
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()

    let soundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        button.tintColor = UIColor(named: "sub2")
        button.isUserInteractionEnabled = true
        return button
    }()

    let vibrateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "iphone.radiowaves.left.and.right"), for: .normal)
        button.tintColor = UIColor(named: "sub2")
        button.isUserInteractionEnabled = true
        return button
    }()

    let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(named: "background")
        button.backgroundColor = UIColor(named: "main")
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "font2")
        return view
    }()

    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()

    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
  
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() 
    }

    func configure() {
        backgroundColor = .clear
        contentView.backgroundColor =  UIColor(named: "background")?.withAlphaComponent(0.3)

        buttonStack.addArrangedSubview(soundButton)
        buttonStack.addArrangedSubview(vibrateButton)

        topStack.addArrangedSubview(titleLabel)
        topStack.addArrangedSubview(buttonStack)
        topStack.addArrangedSubview(playPauseButton)

        contentView.addSubview(containerView)
        containerView.addSubview(topStack)
        containerView.addSubview(divider)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        playPauseButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        divider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(7)
            make.height.equalTo(1)
        }
    }

    func configure(with model: TimerModel) {
        titleLabel.text = model.timerLabel
        timeLabel.text = model.timeString
        updateToggleButton(soundButton, isOn: model.timerSound, iconOn: "speaker.wave.2.fill", iconOff: "speaker.slash.fill")
        updateToggleButton(vibrateButton, isOn: model.timerVibration, iconOn: "iphone.gen3.radiowaves.left.and.right", iconOff: "iphone.radiowaves.left.and.right")
        updatePlayPauseButton(isPlaying: model.timerPlay)
    }

    private func updatePlayPauseButton(isPlaying: Bool) {
        let icon = isPlaying ? "pause.fill" : "play.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        playPauseButton.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)
        playPauseButton.backgroundColor = isPlaying ? UIColor(named: "sub1") : UIColor(named: "main")
    }

    private func updateToggleButton(_ button: UIButton, isOn: Bool, iconOn: String, iconOff: String) {
        button.tintColor = isOn ? UIColor(named: "sub1") : UIColor(named: "sub2")
        button.setImage(UIImage(systemName: isOn ? iconOn : iconOff), for: .normal)
    }
}
