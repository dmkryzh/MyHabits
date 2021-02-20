//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Дмитрий on 08.02.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    let sometTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.text = "Привычка за 21 день"
        title.toAutoLayout()
        return title
    }()
    
    let text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:\n\nПровести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.\n\nВыдержать 2 дня в прежнем состоянии самоконтроля.\n\nОтметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.\n\nПоздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.\n\nДержать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.\n\nНа 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.\n\nИсточник: psychbook.ru\n\n\n"

    lazy var modifiedString = NSMutableAttributedString.init(string: self.text)
    
    lazy var mainTextLabel: UILabel = {
        let title = UILabel()
        title.text = text
        title.numberOfLines = 0
        title.toAutoLayout()
        return title
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.toAutoLayout()
        return scrollView
    }()
    
    let container: UIView = {
        let container = UIView()
        container.toAutoLayout()
        return container
    }()
    
    
    lazy var constraints = [
        
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
       
        container.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        container.topAnchor.constraint(equalTo: scrollView.topAnchor),
        container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
     
        sometTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
        sometTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
        sometTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        
        mainTextLabel.topAnchor.constraint(equalTo: sometTitle.bottomAnchor, constant: 16),
        mainTextLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
        mainTextLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        mainTextLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Информация"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubviews(sometTitle, mainTextLabel)
        NSLayoutConstraint.activate(constraints)

    }


}
