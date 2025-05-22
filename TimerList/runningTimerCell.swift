//  recentTimerCell.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.

import UIKit
import SnapKit

class runningTimerCell: UITableViewCell {

    static let id = "runningTimerCell"

    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    
    let runningTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "실행중 타이머"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    
    private lazy var soundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        button.tintColor = UIColor(named: "sub2")
        button.addTarget(self, action: #selector(toggleSound), for: .touchUpInside)
        return button
    }()

    
    private lazy var vibrateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "iphone.radiowaves.left.and.right"), for: .normal)
        button.tintColor = UIColor(named: "sub2")
        button.addTarget(self, action: #selector(toggleVibrate), for: .touchUpInside)
        return button
    }()

    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(named: "background")
        button.backgroundColor = UIColor(named: "main")
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        return button
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
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }

    private func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        buttonStack.addArrangedSubview(soundButton)
        buttonStack.addArrangedSubview(vibrateButton)

        topStack.addArrangedSubview(runningTimerLabel)
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
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }



    @objc private func toggleSound() {
        let isOn = soundButton.tintColor == UIColor(named: "sub1")
        soundButton.tintColor = isOn ? UIColor(named: "sub2") : UIColor(named: "sub1")
        let icon = isOn ? "speaker.slash.fill" : "speaker.slash.fill"
        soundButton.setImage(UIImage(systemName: icon), for: .normal)
    }

    @objc private func toggleVibrate() {
        let isOn = vibrateButton.tintColor == UIColor(named: "sub1")
        vibrateButton.tintColor = isOn ? UIColor(named: "sub2") : UIColor(named: "sub1")
        let icon = isOn ? "iphone.radiowaves.left.and.right" : "iphone.gen3.radiowaves.left.and.right"
        vibrateButton.setImage(UIImage(systemName: icon), for: .normal)
    }

    @objc private func togglePlayPause() {
        let isPlaying = playPauseButton.currentImage == UIImage(systemName: "pause.fill")
        let nextImage = isPlaying ? "play.fill" : "pause.fill"
        playPauseButton.setImage(UIImage(systemName: nextImage), for: .normal)
        playPauseButton.backgroundColor = isPlaying ? UIColor(named: "main") : UIColor(named: "sub1")
    }
}
