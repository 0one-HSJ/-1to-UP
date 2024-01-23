//
//  CalendarHeaderView.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/18/24.
//

import UIKit

class CalendarHeaderView: UIView {
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Month"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        
        button.tintColor = .secondaryLabel
        button.contentMode = .scaleAspectFill
        button.isUserInteractionEnabled = true
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Close Picker"
        return button
    }()
    
    lazy var dayOfWeekStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.distribution = .fillEqually
      return stackView
    }()

    lazy var separatorView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
      return view
    }()
    
    lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.locale = Locale.autoupdatingCurrent
      dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
      return dateFormatter
    }()
    
    var baseDate = Date() {
      didSet {
        monthLabel.text = dateFormatter.string(from: baseDate)
      }
    }

    //MARK: - init
    var exitButtonDidTapHandler: (() -> Void)?

    init(exitButtonDidTapHandler: (() -> Void)?) {
        self.exitButtonDidTapHandler = exitButtonDidTapHandler
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGroupedBackground
        configureUI()
        setUpContraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        addSubview(monthLabel)
        addSubview(closeButton)
        addSubview(dayOfWeekStackView)
        addSubview(separatorView)
        
        monthLabel.text = dateFormatter.string(from: baseDate)
        
        for dayNumber in 1...7 {
          let dayLabel = UILabel()
          dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
          dayLabel.textColor = .secondaryLabel
          dayLabel.textAlignment = .center
          dayLabel.text = dayOfWeekLetter(for: dayNumber)
          dayLabel.isAccessibilityElement = false
          dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
        
        closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
    }
    
    
    private func dayOfWeekLetter(for dayNumber: Int) -> String {
      switch dayNumber {
      case 1:
        return "Sun"
      case 2:
        return "Mon"
      case 3:
        return "Tue"
      case 4:
        return "Wed"
      case 5:
        return "Thu"
      case 6:
        return "Fri"
      case 7:
        return "Sat"
      default:
        return ""
      }
    }
    
    func setUpContraints() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
          monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
          monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
          monthLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: 5),

          closeButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
          closeButton.heightAnchor.constraint(equalToConstant: 28),
          closeButton.widthAnchor.constraint(equalToConstant: 28),
          closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

          dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
          dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
          dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),

          separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
          separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
          separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
          separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    //MARK: - Actions
    @objc func didTapExitButton() {
        exitButtonDidTapHandler!()
    }
}
