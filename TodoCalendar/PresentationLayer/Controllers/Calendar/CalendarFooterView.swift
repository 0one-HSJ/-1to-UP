//
//  CalendarFooterView.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/18/24.
//

import UIKit

class CalendarFooterView: UIView {
    //MARK: - Properties
    lazy var separatorView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
      return view
    }()

    lazy var previousMonthButton: UIButton = {
      let button = UIButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
      button.titleLabel?.textAlignment = .left

      if let chevronImage = UIImage(systemName: "chevron.left.circle.fill") {
        let imageAttachment = NSTextAttachment(image: chevronImage)
        let attributedString = NSMutableAttributedString()

        attributedString.append(
          NSAttributedString(attachment: imageAttachment)
        )

        attributedString.append(
          NSAttributedString(string: " Previous")
        )

        button.setAttributedTitle(attributedString, for: .normal)
      } else {
        button.setTitle("Previous", for: .normal)
      }

      button.titleLabel?.textColor = .label

      button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
      return button
    }()

    lazy var nextMonthButton: UIButton = {
      let button = UIButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
      button.titleLabel?.textAlignment = .right

      if let chevronImage = UIImage(systemName: "chevron.right.circle.fill") {
        let imageAttachment = NSTextAttachment(image: chevronImage)
        let attributedString = NSMutableAttributedString(string: "Next ")

        attributedString.append(
          NSAttributedString(attachment: imageAttachment)
        )

        button.setAttributedTitle(attributedString, for: .normal)
      } else {
        button.setTitle("Next", for: .normal)
      }

      button.titleLabel?.textColor = .label

      button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
      return button
    }()
    
    
    //MARK: - init
    var didTapLastMonth: (() -> Void)?
    var didTapNextMonth: (() -> Void)?
    
    init(didTapLastMonth: (() -> Void)?, didTapNextMonth: (() -> Void)?) {
        self.didTapLastMonth = didTapLastMonth
        self.didTapNextMonth = didTapNextMonth
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        super.layoutSubviews()
        
        addSubview(separatorView)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
        
        previousMonthButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        nextMonthButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        NSLayoutConstraint.activate([
          separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
          separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
          separatorView.topAnchor.constraint(equalTo: topAnchor),
          separatorView.heightAnchor.constraint(equalToConstant: 1),

          previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
          previousMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor),

          nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
          nextMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    //MARK: - Actions
    @objc func didTapPreviousMonthButton() {
        didTapLastMonth!()
    }
    
    @objc func didTapNextMonthButton() {
        didTapNextMonth!()
    }
}
