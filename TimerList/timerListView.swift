//
//  timerListView.swift
//  Allarm
//
//  Created by 전원식 on 5/21/25.
//

import UIKit
import SnapKit

class timerListView : UIView {
    
    
    let timerLabel : UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = "타이머"
        return timerLabel
    }()
    
    let runningLabel : UILabel = {
        let runningLabel = UILabel()
        runningLabel.text = "실행중인 타이머"
        return runningLabel
    }()
    
    let timerAddButton : UIButton = {
        let timerAddButton = UIButton()
        timerAddButton.setTitle("+", for: .normal)
        return timerAddButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: <#T##CGRect#>)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(timerLabel)
        self.addSubview(runningLabel)
        self.addSubview(timerAddButton)

        timerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        runningLabel.snp.makeConstraints { make in
            make.top
        }
    }
    
    
}

