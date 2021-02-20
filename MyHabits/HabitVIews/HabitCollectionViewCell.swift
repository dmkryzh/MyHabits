//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Дмитрий on 11.02.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit? {
        didSet {
            habbitName.text = habit!.name
            habbitName.textColor = habit!.color
            everyTimeAt.text = habit!.dateString
            colorCircle.layer.borderColor = habit!.color.cgColor
            colorCircle.backgroundColor = .white
            guard habit!.isAlreadyTakenToday == true else { return }
            colorCircle.backgroundColor = habit!.color
            tick.isHidden = false
        }
    }
    
    var habbitName: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.toAutoLayout()
        return label
    }()
    
    var everyTimeAt: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor.systemGray2
        label.toAutoLayout()
        return label
    }()
    
    var inSequence: UILabel = {
       let label = UILabel()
        label.text = "Подряд: 0"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.systemGray
        label.toAutoLayout()
        return label
    }()
    
    var colorCircle: UIView = {
        let color = UIView()
        color.backgroundColor = .white
        color.layer.cornerRadius = 18
        color.layer.borderWidth = 2
        color.toAutoLayout()
        color.isUserInteractionEnabled = true
        return color
    }()
    
    let tick: UIImageView = {
        let tickConfig = UIImage.SymbolConfiguration.init(weight: .bold)
        let tick = UIImageView()
        tick.image = UIImage(systemName: "checkmark", withConfiguration: tickConfig)
        tick.tintColor = .white
        tick.isHidden = true
        tick.toAutoLayout()
        return tick
    }()
    
    lazy var newConstraints = [
        habbitName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
        habbitName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        habbitName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),

        everyTimeAt.topAnchor.constraint(equalTo: habbitName.bottomAnchor, constant: 4),
        everyTimeAt.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

        inSequence.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        inSequence.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
        
        colorCircle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        colorCircle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26),
        colorCircle.heightAnchor.constraint(equalToConstant: 36),
        colorCircle.widthAnchor.constraint(equalToConstant: 36),
        
        tick.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        tick.trailingAnchor.constraint(equalTo: colorCircle.trailingAnchor, constant: -8),
        tick.heightAnchor.constraint(equalToConstant: 20),
        tick.widthAnchor.constraint(equalToConstant: 20),
    ]
    
    
    //MARK: FUNCTIONS
    
    func tickHabitGesture() {
        let tickHabitGesture = UITapGestureRecognizer(target: self, action: #selector(trackHabit))
        colorCircle.addGestureRecognizer(tickHabitGesture)
    }

    @objc func trackHabit() {
        colorCircle.backgroundColor = habit!.color
        tick.isHidden = false
        HabitsStore.shared.track(habit!)
 
    //отправляем нотификацию, что объект отмечен
        NotificationCenter.default.post(name: NSNotification.Name("ticked"), object: nil)
    }
    
    //MARK: INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews(habbitName, everyTimeAt, inSequence, colorCircle, tick)
        NSLayoutConstraint.activate(newConstraints)
        tickHabitGesture()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

