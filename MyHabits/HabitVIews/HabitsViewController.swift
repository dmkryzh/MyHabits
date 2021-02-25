//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Дмитрий on 08.02.2021.
//

import UIKit

class HabitsViewController: UIViewController {
    
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "milkGray")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        collectionView.toAutoLayout()
        return collectionView
    }()
    
    
    
    lazy var constraints = [
        collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ]
    
    //MARK: FUNCTIONS
    
    @objc func moveToHabbitCreator() {
        let rvc = HabitViewController()
        let navi = UINavigationController(rootViewController: rvc)
        //передаю комплишн чтобы обновлялся список с ячейками после закрытия
        rvc.someCompletion = { self.collectionView.reloadData() }
        present(navi, animated: true, completion: nil)
    }
    
    
    func navContSettings() {
        
        let addHabit = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(moveToHabbitCreator))
        addHabit.tintColor = UIColor(named: "newPurple")
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = addHabit
        navigationController?.navigationBar.prefersLargeTitles = true
        let naviBarAppearance = UINavigationBarAppearance()
        naviBarAppearance.backgroundEffect = .init(style: .systemChromeMaterial)
        navigationController?.navigationBar.topItem?.standardAppearance = naviBarAppearance
        navigationController?.navigationBar.topItem?.compactAppearance = naviBarAppearance
        navigationController?.navigationBar.topItem?.scrollEdgeAppearance = naviBarAppearance
    }
    
    @objc func reloadProgress() {
        self.collectionView.reloadData()
    }
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сегодня"
        view.backgroundColor = .white
        navContSettings()
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(constraints)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProgress), name: NSNotification.Name(rawValue: "ticked"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
}

//MARK: CV DATA SOURCE

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return HabitsStore.shared.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let progressFloat = HabitsStore.shared.todayProgress
            let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
            progressCell.layer.cornerRadius = 8
            progressCell.progressBar.setProgress(progressFloat, animated: true)
            progressCell.percents.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
            return progressCell
        default:
            let habit = HabitsStore.shared.habits[indexPath.item]
            let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
            habitCell.habit = habit
            habitCell.layer.cornerRadius = 8
            
            // считаем сколько раз ПОДРЯД юзер трекнул привычку
            
            var item = 0
            var count = 0
            
            while item < HabitsStore.shared.dates.count - 1 {
                if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[item]) && HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[item + 1])
                {
                    count += 1
                }
                else {
                    count = 0
                }
                item += 1
            }
            
            if count > 0 {
                count += 1
            }
            
            habitCell.inSequence.text = "Подряд: \(count)"
            
            return habitCell
        }
        
    }
    
}

//MARK: CV DELEGATE FLOW

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width - 16 - 16, height: 80)
        default:
            return CGSize(width: view.frame.width - 16 - 16, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
        default:
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let habit = HabitsStore.shared.habits[indexPath.item]
        let details = HabitDetailsViewController()
        details.title = HabitsStore.shared.habits[indexPath.item].name
        details.habit = habit
        navigationController?.pushViewController(details, animated: true)
    }
    
}


