//
//  TodoListTableViewCell.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/22/24.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var titleLabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var startDate: Date? = nil
    var endDate: Date? = nil
    var parentTodo: ToDo?
    var purpose = ""
    let mainPurpose: MainPurpose? = nil
    
    
    var deleteButtonAction: (() -> Void)?
    
    //MARK: - Helpers
    func configure(with todo: ToDo) {
        titleLabel.text = todo.title
        parentTodo = todo.parentTodo
        startDate = todo.startDate
        endDate = todo.endDate
        purpose = parentTodo?.title ?? "?"
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀의 서브뷰 추가 및 레이아웃 설정
        contentView.addSubview(titleLabel)
        // 레이아웃 설정은 여기에 추가
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    
    
}
