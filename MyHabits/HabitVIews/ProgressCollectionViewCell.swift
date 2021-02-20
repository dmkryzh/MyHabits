//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Дмитрий on 11.02.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Всё получится!"
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.toAutoLayout()
        return label
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 4
        progressBar.subviews[1].clipsToBounds = true
        progressBar.progress = HabitsStore.shared.todayProgress
        progressBar.progressTintColor = UIColor(named: "newPurple")
        progressBar.trackTintColor = UIColor(named: "milkGray")
        progressBar.layer.cornerRadius = 4
        progressBar.toAutoLayout()
        return progressBar
    }()
    
    var percents: UILabel = {
        let percents = UILabel()
        let incommingFloat = Int(HabitsStore.shared.todayProgress * 100)
        percents.text = "\(incommingFloat)%"
        percents.textColor = UIColor.systemGray
        percents.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        percents.toAutoLayout()
        return percents
    }()
    
    lazy var newConstraints = [
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
        
        percents.centerYAnchor.constraint(equalTo: label.centerYAnchor),
        percents.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
 
        progressBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
        progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
        progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
        progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
        progressBar.heightAnchor.constraint(equalToConstant: 7)
        
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews(label, percents, progressBar)
        NSLayoutConstraint.activate(newConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

