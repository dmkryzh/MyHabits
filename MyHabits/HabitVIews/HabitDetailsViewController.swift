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
        guard habit != nil else { return }
        let rvc = HabitViewController()
        let navi = UINavigationController(rootViewController: rvc)
        rvc.delegate = self
        rvc.existingHabit = habit!
        rvc.modalTransitionStyle = .flipHorizontal
        rvc.someCompletion = {
            self.viewWillAppear(true)
        }
        present(navi, animated: true, completion: nil)

    }
    
//MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(moveToHabit))
        view.backgroundColor = UIColor(named: "milkGray")
        view.addSubview(tableView)
        NSLayoutConstraint.activate(constraints)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard habit != nil else { return }
        let index = HabitsStore.shared.habits.firstIndex(where: {$0 == self.habit!})
        title = HabitsStore.shared.habits[index!].name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HabitDetailsTableViewCell.self), for: indexPath) as! HabitDetailsTableViewCell
        
        let sortedDates = HabitsStore.shared.dates.sorted(by: >)
        let date = sortedDates[indexPath.item]
     
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: HabitsStore.shared.dates.count - 1 - indexPath.item)

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
