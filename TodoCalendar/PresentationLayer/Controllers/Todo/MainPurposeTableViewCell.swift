//
//  MainPurposeTableViewCell.swift
//  TodoCalendar
//

import UIKit

class MainPurposeTableViewCell: UITableViewCell {
    let colorView = UIView()
    let mainPurposeTextLabel = UILabel()
    
    var temporaryNum: Int64? = 1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀의 서브뷰 추가 및 레이아웃 설정
        addSubview(colorView)
        addSubview(mainPurposeTextLabel)
        // 레이아웃 설정은 여기에 추가
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with mainPurpose: MainPurpose) {
        mainPurposeTextLabel.text = mainPurpose.mainPurposeText
        colorView.backgroundColor = MyColor(rawValue: mainPurpose.color)?.colors
    }
    
    func setupLayout() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        mainPurposeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [colorView, mainPurposeTextLabel]
        lazy var stackView: UIStackView = {
            let stview = UIStackView(arrangedSubviews: views)
            stview.spacing = 15
            stview.axis = .vertical
            stview.distribution = .fillEqually
            stview.alignment = .fill
            stview.translatesAutoresizingMaskIntoConstraints = false
            return stview
        }()
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
