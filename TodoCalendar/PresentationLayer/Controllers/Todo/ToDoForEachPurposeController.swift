//
//  ToDoForEachPurposeController.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/21/24.
//

import UIKit

class ToDoForEachPurposeController: UIViewController {
    //MARK: - properties
    var eachPurpose: MainPurpose!
    private var tableView = UITableView()
    
    let todomanager = ToDoManager()
    var todoList: [ToDo] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupTableView()
        setupTableViewConstraints()
        loadTodoList()
    }
    
    // 화면에 다시 진입할때마다 다시 테이블뷰 그리기 (업데이트 등 제대로 표시)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //MARK: - Helpers
    
    func setupNaviBar() {
        self.title = eachPurpose.mainPurposeText
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = MyColor(rawValue: eachPurpose.color)?.colors
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 네비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: "TodoListTableViewCell")
        view.addSubview(tableView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    //MARK: - Actions
    @objc func plusButtonTapped() {
        let detailVC = TodoEditor(eachPurpose: eachPurpose)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ToDoForEachPurposeController: UITableViewDataSource {
    func loadTodoList() {
        todoList = todomanager.fetchData(for: eachPurpose)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todomanager.fetchData(for: eachPurpose).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableViewCell", for: indexPath) as! TodoListTableViewCell
        
        let todos = todomanager.fetchData(for: eachPurpose)
        
        cell.configure(with: todos[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ToDoForEachPurposeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedtodo = todomanager.fetchData(for: eachPurpose)[indexPath.row]
        todomanager.delete(todo: selectedtodo) {
            print("삭제 완료")
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
        
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let detailVC = TodoEditor(eachPurpose: eachPurpose)
                let selectedToDo = todomanager.fetchData(for: eachPurpose)[indexPath.row]
                detailVC.todo = selectedToDo
                detailVC.eachPurpose = eachPurpose
                
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}




