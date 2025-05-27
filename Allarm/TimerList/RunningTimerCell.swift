//  RunningTimerCell.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.

import UIKit
import SnapKit
import RxSwift

class RunningTimerCell: UITableViewCell {

    static let id = "runningTimerCell"
    var disposeBag = DisposeBag()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 55, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    let soundIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(named: "sub2")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let vibrateIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(named: "sub2")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(named: "background")
        button.backgroundColor = UIColor(named: "main")
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = true
        return button
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "font2")
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func setupLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 8
        containerView.addSubview(mainStack)
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }

        let midRow = UIStackView()
        midRow.axis = .horizontal
        midRow.alignment = .center
        midRow.distribution = .fill
        midRow.spacing = 12

        let textStack = UIStackView(arrangedSubviews: [titleLabel, timeLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading

        let iconStack = UIStackView(arrangedSubviews: [soundIconView, vibrateIconView])
        iconStack.axis = .horizontal
        iconStack.spacing = 8
        
        let iconWrapper = UIView()
        iconWrapper.addSubview(iconStack)
        iconStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        playPauseButton.snp.makeConstraints { $0.size.equalTo(56) }
        soundIconView.snp.makeConstraints { $0.size.equalTo(30) }
        vibrateIconView.snp.makeConstraints { $0.size.equalTo(30) }

        textStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        iconWrapper.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        playPauseButton.setContentHuggingPriority(.required, for: .horizontal)

        midRow.addArrangedSubview(textStack)
        midRow.addArrangedSubview(iconWrapper)
        midRow.addArrangedSubview(playPauseButton)

        mainStack.addArrangedSubview(midRow)
        mainStack.addArrangedSubview(divider)

        divider.snp.makeConstraints { $0.height.equalTo(1) }
    }

    func configure(with model: TimerModel) {
        titleLabel.text = model.timerLabel
        timeLabel.text = model.timeString
        updatePlayPauseButton(isPlaying: model.timerPlay)
        updateIcons(model: model)
    }

    private func updatePlayPauseButton(isPlaying: Bool) {
        let icon = isPlaying ? "pause.fill" : "play.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        playPauseButton.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)
        playPauseButton.backgroundColor = isPlaying ? UIColor(named: "sub1") : UIColor(named: "main")
    }

    private func updateIcons(model: TimerModel) {
        let soundIcon = model.timerSound ? "speaker.wave.2.fill" : "speaker.slash.fill"
        let vibrateIcon = model.timerVibration ? "iphone.gen3.radiowaves.left.and.right" : "iphone.radiowaves.left.and.right"

        soundIconView.image = UIImage(systemName: soundIcon)
        vibrateIconView.image = UIImage(systemName: vibrateIcon)

        soundIconView.tintColor = model.timerSound ? UIColor(named: "sub1") : UIColor(named: "sub2")
        vibrateIconView.tintColor = model.timerVibration ? UIColor(named: "sub1") : UIColor(named: "sub2")
    }
}
