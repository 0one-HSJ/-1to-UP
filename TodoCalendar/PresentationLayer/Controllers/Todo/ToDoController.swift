//
//  ToDoController.swift
//  (1 to)UP beta
//
//  Created by 하상준 on 1/14/24.
//

import UIKit

class ToDoController: UIViewController {
    //MARK: - Properties
    
    private var tableView = UITableView()
    let mainPurposeManager = MainPurposeManager.shared
    var mainPurposes: [MainPurpose] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupTableView()
        setupTableViewConstraints()
        loadMainPurposes()
        
    }
    
    // 화면에 다시 진입할때마다 다시 테이블뷰 그리기 (업데이트 등 제대로 표시)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainPurposeTableViewCell.self, forCellReuseIdentifier: "MainPurposeTableViewCell")
        view.addSubview(tableView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    // 테이블뷰 자체의 오토레이아웃
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
    
    func setupNaviBar() {
        self.title = "Main 1 Purpose"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 네비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
        
    }
    
    //MARK: - Actions
    
    @objc func plusButtonTapped() {
        let detailVC = PurposeEditor()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//MARK: - TableView configure

extension ToDoController: UITableViewDataSource {
    
    func loadMainPurposes() {
        mainPurposes = MainPurposeManager.shared.fetchData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPurposeManager.fetchData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainPurposeTableViewCell", for: indexPath) as! MainPurposeTableViewCell
        
        let purposes = mainPurposeManager.fetchData()
        
        cell.configure(with: purposes[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
    }

}

extension ToDoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ToDoForEachPurposeController()
        let selectedToDo = mainPurposeManager.fetchData()[indexPath.row]
        detailVC.eachPurpose = selectedToDo
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let detailVC = PurposeEditor()
                let selectedToDo = mainPurposeManager.fetchData()[indexPath.row]
                detailVC.mainPurpose = selectedToDo
                
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}
