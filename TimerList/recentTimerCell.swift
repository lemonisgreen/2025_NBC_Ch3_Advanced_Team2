//
//  recentTimerCell.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit

class recentTimerCell : UITableViewCell {
    
    static let id = "recentTimerCell"
    
    let recentTimerLabel : UILabel = {
        let recentTimerLabel = UILabel()
        recentTimerLabel.text = "최근 항목"
        return recentTimerLabel
    }()
    
    let playButton : UIButton = {
        let playButton = UIButton()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        return playButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        contentView.addSubview(recentTimerLabel)
        contentView.addSubview(playButton)
        
        recentTimerLabel.snp.makeConstraints { make in
                 make.top.equalToSuperview().offset(16)
                 make.leading.equalToSuperview().offset(20)
             }
             
             playButton.snp.makeConstraints { make in
                 make.centerY.equalTo(recentTimerLabel)
                 make.trailing.equalToSuperview().inset(20)
                 make.width.height.equalTo(30)
             }
    }
}
