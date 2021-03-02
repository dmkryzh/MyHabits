//
//  TabBarViewController.swift
//  MyHabits
//
//  Created by Дмитрий on 08.02.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabBar.tintColor = .purple
        
        let habits = HabitsViewController()
        let itemHabbits: UITabBarItem = {
            let itemHabbits = UITabBarItem()
            itemHabbits.title = "Привычки"
            itemHabbits.image = UIImage(named: "habits_tab_icon_v1")
            itemHabbits.tag = 0
            return itemHabbits
        }()
        habits.tabBarItem = itemHabbits
                
        
        let info = InfoViewController()
        
        let itemInfo: UITabBarItem = {
            let itemInfo = UITabBarItem()
            itemInfo.title = "Информация"
            itemInfo.image = UIImage(systemName: "info.circle.fill")
            itemInfo.tag = 1
            return itemInfo
        }()
        info.tabBarItem = itemInfo
        let tabBarList = [habits, info]
        viewControllers = tabBarList.map { UINavigationController(rootViewController: $0) }
   
    }
    
}

extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}
