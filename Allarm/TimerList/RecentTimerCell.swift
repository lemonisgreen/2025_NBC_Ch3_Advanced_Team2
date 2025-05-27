//
//  RecentTimerCell.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit
import RxSwift

class RecentTimerCell: UITableViewCell {

    static let id = "recentTimerCell"
    var disposeBag = DisposeBag()

    private let containerView: UIView = {
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
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "sub2")
        imageView.snp.makeConstraints { $0.size.equalTo(30) }
        return imageView
    }()

    let vibrateIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "sub2")
        imageView.snp.makeConstraints { $0.size.equalTo(30) }
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
        button.snp.makeConstraints { $0.size.equalTo(56) }
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
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
        }

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 8
        containerView.addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        let midRow = UIStackView()
        midRow.axis = .horizontal
        midRow.alignment = .center
        midRow.distribution = .equalCentering

        let leftStack = UIStackView(arrangedSubviews: [titleLabel, timeLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2
        leftStack.alignment = .leading

        let centerStack = UIStackView(arrangedSubviews: [soundIconView, vibrateIconView])
        centerStack.axis = .horizontal
        centerStack.spacing = 8
        centerStack.alignment = .center

        midRow.addArrangedSubview(leftStack)
        midRow.addArrangedSubview(centerStack)
        midRow.addArrangedSubview(playPauseButton)

        leftStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        centerStack.setContentHuggingPriority(.required, for: .horizontal)
        playPauseButton.setContentHuggingPriority(.required, for: .horizontal)

        midRow.setCustomSpacing(8, after: leftStack)
        midRow.setCustomSpacing(8, after: centerStack)

        mainStack.addArrangedSubview(midRow)
        mainStack.addArrangedSubview(divider)

        divider.snp.makeConstraints { $0.height.equalTo(1) }
    }

    func configure(with model: TimerModel) {
        titleLabel.text = model.timerLabel
        timeLabel.text = model.timeString
        updateIcon(soundIconView, isOn: model.timerSound,
                   iconOn: "speaker.wave.2.fill", iconOff: "speaker.slash.fill")
        updateIcon(vibrateIconView, isOn: model.timerVibration,
                   iconOn: "iphone.gen3.radiowaves.left.and.right", iconOff: "iphone.radiowaves.left.and.right")
        updatePlayPauseButton(isPlaying: model.timerPlay)
    }

    private func updatePlayPauseButton(isPlaying: Bool) {
        let icon = isPlaying ? "pause.fill" : "play.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        playPauseButton.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)
        playPauseButton.backgroundColor = isPlaying ? UIColor(named: "sub1") : UIColor(named: "main")
    }

    private func updateIcon(_ imageView: UIImageView, isOn: Bool, iconOn: String, iconOff: String) {
        imageView.tintColor = isOn ? UIColor(named: "sub1") : UIColor(named: "sub2")
        imageView.image = UIImage(systemName: isOn ? iconOn : iconOff)
    }
}
