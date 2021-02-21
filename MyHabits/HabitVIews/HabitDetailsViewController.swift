//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Дмитрий on 12.02.2021.
//

protocol HabitDetailsDelegate: class {
    func closeVCFromAnotherVC()
}

import UIKit

class HabitDetailsViewController: UIViewController {
    
    var habit: Habit?
    
    var index: IndexPath?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "milkGray")
        tableView.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: String(describing: HabitDetailsTableViewCell.self))
        return tableView
    }()
    
    lazy var constraints = [
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ]
    
//MARK: FUNCTIONS
    @objc func moveToHabit() {
        print("tap")
        let rvc = HabitViewController()
        let navi = UINavigationController(rootViewController: rvc)
        rvc.delegate = self
        rvc.reloadDetails = { self.title = HabitsStore.shared.habits[self.index!.item].name }
        rvc.existingHabit = habit!
        rvc.index = index
        present(navi, animated: true, completion: nil)

    }
    
//MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(moveToHabit))
        view.backgroundColor = UIColor(named: "milkGray")
        view.addSubview(tableView)
        NSLayoutConstraint.activate(constraints)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
}
    
//MARK: EXTENSIONS

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Активность"
    }
    
}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var calender = Calendar.current
        calender.timeZone = TimeZone.current
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HabitDetailsTableViewCell.self), for: indexPath) as! HabitDetailsTableViewCell
        let sortedDates = HabitsStore.shared.dates.sorted(by: >)
        let date = sortedDates[indexPath.item]
        
        switch Date().distance(from: date, only: .day) {
        case 0:
            cell.textLabel?.text = "Сегодня"
        case 1:
            cell.textLabel?.text = "Вчера"
        case 2:
            cell.textLabel?.text = "Позавчера"
        default:
            cell.textLabel?.text = date.getFormattedDate(format: "d EEEE yyyy")
        }
    
        guard HabitsStore.shared.habit(habit!, isTrackedIn: date) else { return cell }
        cell.accessoryType = .checkmark
        
        return cell
    }
}

extension HabitDetailsViewController: HabitDetailsDelegate {
    func closeVCFromAnotherVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
