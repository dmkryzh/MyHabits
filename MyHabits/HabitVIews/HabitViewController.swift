//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Дмитрий on 09.02.2021.
//

import UIKit

class HabitViewController: UIViewController {
    
    weak var delegate: HabitDetailsDelegate?
    
    var someCompletion: (() -> ())?
 
    private var newHabitName = ""
    
    var existingHabit: Habit? {
        didSet {
            inputField.text = existingHabit!.name
            colorPicker.backgroundColor = existingHabit!.color
            datePicker.date = existingHabit!.date
            bottomButton.isHidden = false
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.toAutoLayout()
        return scrollView
    }()
    
    let contentContainer: UIView = {
        let container = UIView()
        container.toAutoLayout()
        return container
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.toAutoLayout()
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        return button
    }()
    
//MARK: ALERT POPUP
    
    lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(existingHabit!.name)\" ?", preferredStyle: .alert)
        alert.addAction(actionCancel)
        alert.addAction(actionOK)
        return alert
    }()
    
    lazy var actionOK = UIAlertAction(title: "OK", style: .destructive) { (action: UIAlertAction) in
        guard action.isEnabled else { return }
        HabitsStore.shared.habits = HabitsStore.shared.habits.filter { $0 != self.existingHabit! }
        self.dismiss(animated: true, completion: nil)
        self.delegate?.closeVCFromAnotherVC()
    }
    
    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
    
    let habitName: UILabel = {
       let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.toAutoLayout()
        return label
    }()
    
    let inputField: UITextField = {
       let input = UITextField()
        input.tintColor = UIColor(named: "deepBlue")
        input.placeholder = "Бегать по утрам, вставать в 6 утра и т.п."
        input.addTarget(self, action: #selector(saveName), for: .editingChanged)
        input.toAutoLayout()
        return input
    }()
    
    
    let color: UILabel = {
       let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.toAutoLayout()
        return label
    }()
    
    private var colorPicker: UIView = {
        let colorPicker = UIView()
        colorPicker.backgroundColor = .black
        colorPicker.layer.cornerRadius = 15
        colorPicker.toAutoLayout()
        colorPicker.isUserInteractionEnabled = true
        return colorPicker
    }()
    
    let time: UILabel = {
       let label = UILabel()
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.toAutoLayout()
        return label
    }()
    
    var dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "h:mm a"
        return date
    }()
    
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.timeZone = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        datePicker.toAutoLayout()
        return datePicker
    }()

    lazy var everyDayAt: UILabel = {
       let label = UILabel()
        label.toAutoLayout()
        return label
    }()
    
    lazy var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.toAutoLayout()
        stackView.addArrangedSubview(habitName)
        stackView.addArrangedSubview(inputField)
        stackView.addArrangedSubview(color)
        stackView.addSubview(colorPicker)
        stackView.addArrangedSubview(colorPicker)
        stackView.addArrangedSubview(time)
        stackView.addArrangedSubview(everyDayAt)
        stackView.setCustomSpacing(7, after: habitName)
        stackView.setCustomSpacing(15, after: inputField)
        stackView.setCustomSpacing(7, after: color)
        stackView.setCustomSpacing(15, after: colorPicker)
        stackView.setCustomSpacing(7, after: time)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.contentMode = .scaleAspectFill
        
        let constraints = [
            colorPicker.heightAnchor.constraint(equalToConstant: 30),
            colorPicker.widthAnchor.constraint(equalToConstant: 30)
        ]
        stackView.addConstraints(constraints)
        
        return stackView
    }()
    
    //MARK: CONSTRAINTS
    
    lazy var constraints = [
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
        contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22),
        contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        contentContainer.heightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.heightAnchor),
        contentContainer.widthAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.widthAnchor),
        
        stackView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
        stackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
        stackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
        
        datePicker.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15),
        datePicker.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
        datePicker.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
        
        bottomButton.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
        bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        
    ]
    
    //MARK: FUNCTIONS
    
    @objc func deleteHabit() {
        guard let _ = existingHabit else { return }
        present(alert, animated: true, completion: nil)
    }
    
    @objc func updateDate() {
        let attrTextCombined = NSMutableAttributedString()
        attrTextCombined.append(NSMutableAttributedString(string: "Каждый день в ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]))
        attrTextCombined.append(NSMutableAttributedString(string: dateFormatter.string(from: datePicker.date), attributes: [NSAttributedString.Key.foregroundColor:UIColor(named: "newPurple")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]))
        everyDayAt.attributedText = attrTextCombined
    }
    
    func moveToColorPickerGesture() {
        let moveToColorPicker = UITapGestureRecognizer(target: self, action: #selector(showColorPicker))
        colorPicker.addGestureRecognizer(moveToColorPicker)
    }
    
    @objc func showColorPicker() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func saveName(_ text: UITextField) {
        newHabitName = text.text!
    }
    
    @objc func addHabit() {
        if existingHabit == nil {
        let newHabit = Habit(name: newHabitName,
                             date: datePicker.date,
                             color: colorPicker.backgroundColor!)
            HabitsStore.shared.habits.append(newHabit)
            dismiss(animated: true, completion: someCompletion)
        }
        
        else {
            existingHabit!.name = inputField.text ?? ""
            existingHabit!.date = datePicker.date
            existingHabit!.color = colorPicker.backgroundColor!
            let index = HabitsStore.shared.habits.firstIndex(where: {$0 == existingHabit!})
            HabitsStore.shared.habits[index!] = existingHabit!
            dismiss(animated: true, completion: someCompletion)
        }
    }
    
    @objc func closeAddHabbitFrame() {
        dismiss(animated: true, completion: nil)
    }
    
    func navContSettings() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = .init(title: "Отменить", style: .plain, target: self, action: #selector(closeAddHabbitFrame))
        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor(named: "newPurple")
        navigationController?.navigationBar.topItem?.rightBarButtonItem = .init(title: "Сохранить", style: .plain, target: self, action: #selector(addHabit))
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor(named: "newPurple")
    }
    
    
    // MARK: Keyboard observers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Keyboard actions
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    

    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    //MARK: LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создать"
        view.backgroundColor = .white
        navContSettings()
        view.addSubview(scrollView)
        scrollView.addSubview(contentContainer)
        contentContainer.addSubviews(stackView, datePicker, bottomButton)
        NSLayoutConstraint.activate(constraints)
        stackView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.vertical)
        moveToColorPickerGesture()
        updateDate()
        //если передана дата, то выставляем её как изначальную
        if let date = existingHabit?.date { datePicker.setDate(date, animated: false) }
    }
    
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        self.colorPicker.backgroundColor = color
    }
    
}

