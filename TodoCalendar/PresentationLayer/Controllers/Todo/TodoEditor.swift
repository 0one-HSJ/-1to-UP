//
//  TodoEditor.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/22/24.
//

import UIKit

class TodoEditor: UIViewController {
    
    var todo: ToDo?
    var eachPurpose: MainPurpose
    let todomanager = ToDoManager()
    
    //MARK: - Propeties
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Todo"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let startDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.preferredDatePickerStyle = .compact
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let endDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.preferredDatePickerStyle = .compact
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let saveOrUpdateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - LifeCycle
    
    init(eachPurpose: MainPurpose) {
            self.eachPurpose = eachPurpose
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        configureUI()
    }
    //MARK: - Helpers
        // 다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Actions
    
    @objc func saveOrUpdateTodoTapped() {
        
        let title = titleTextField.text ?? ""
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        if let todo = self.todo {
            self.saveOrUpdateButton.setTitle("UPDATE", for: .normal)
            todomanager.updateTodo(for: todo, title: title,  startDate: startDate, endDate: endDate) { success in
                if success {
                    print("Todo Updated")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Faild to update todo")
                }
            }
            
        } else {
            todomanager.createTodo(for: eachPurpose, title: title, startDate: startDate, endDate: endDate) { success, _ in
                if let success = success {
                    DispatchQueue.main.async {
                        if let todos = self.eachPurpose.todos as? Set<ToDo>, let newTodo = todos.sorted(by: { $0.startDate < $1.startDate }).last {
                            self.todo = newTodo
                        }
                        print("Todo Created")
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else {
                    print("Faild to update todo")
                }
            }
        }
    }
}
extension TodoEditor {
    func configureUI() {
        
        view.backgroundColor = .white
        let startLabel = {
            let label = UILabel()
            label.text = "Set Start Date/Time"
            label.widthAnchor.constraint(equalToConstant: 120).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let endLabel = {
            let label = UILabel()
            label.text = "Set End Date/Time"
            label.widthAnchor.constraint(equalToConstant: 120).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let startStackView = {
            let start = [startLabel, startDatePicker]
            let sv = UIStackView(arrangedSubviews: start)
            sv.axis = .horizontal
            sv.alignment = .center
            sv.spacing = 8
            sv.distribution = .fill
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        let endStackView = {
            let end = [endLabel, endDatePicker]
            let sv = UIStackView(arrangedSubviews: end)
            sv.axis = .horizontal
            sv.alignment = .center
            sv.spacing = 8
            sv.distribution = .fill
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        view.addSubview(titleTextField)
        view.addSubview(startStackView)
        view.addSubview(endStackView)
        view.addSubview(saveOrUpdateButton)
        
    
        saveOrUpdateButton.addTarget(self, action: #selector(saveOrUpdateTodoTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
        startStackView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
        startStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        startStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        endStackView.topAnchor.constraint(equalTo: startStackView.bottomAnchor, constant: 20),
        endStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        endStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
        // saveOrUpdateButton 레이아웃
        saveOrUpdateButton.topAnchor.constraint(equalTo: endStackView.bottomAnchor, constant: 20),
        saveOrUpdateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        saveOrUpdateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        saveOrUpdateButton.heightAnchor.constraint(equalToConstant: 50) // 버튼의 높이
        ])
        
        if let todo = self.todo {
            titleTextField.placeholder = todo.title
        } else {
            titleTextField.placeholder = "set New ToDo"
        }
    }
    
    
}
extension TodoEditor: UITextFieldDelegate {
    private func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Set Todo." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    private func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Set Todo."
            textView.textColor = .lightGray
        }
    }
}
