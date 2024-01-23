//
//  CalendarController.swift
//  (1 to)UP beta
//
//  Created by 하상준 on 1/14/24.
//

import UIKit

class CalendarController: UIViewController {
    //MARK: - 기간 표시
    var todo: ToDo?
    
    //MARK: - Properties
        //Views
    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var headerView = CalendarHeaderView { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var footerView = CalendarFooterView(
        didTapLastMonth: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(byAdding: .month, value: -1, to: self.baseDate) ?? self.baseDate
            
            self.headerView.monthLabel.text = self.headerView.dateFormatter.string(from: baseDate)
        },
        didTapNextMonth: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(byAdding: .month, value: 1, to: self.baseDate) ?? self.baseDate
            self.headerView.monthLabel.text = self.headerView.dateFormatter.string(from: baseDate)
        }
    )
    
    // calendar Data Values
    let selectedDate: Date
        
    var baseDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            calendarCollectionView.reloadData()
        }
    }
    private lazy var days = generateDaysInMonth(for: baseDate)
    
    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    
    private let selectedDateChanged: ((Date) -> Void)
        
    let calendar = Calendar(identifier: .gregorian)
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    //MARK: - init
    init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        definesPresentationContext = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpCalendar()
        
        calendarCollectionView.register(
            CalendarDateCollectionViewCell.self,
            forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier
        )
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
    }
    override func viewWillTransition(
      to size: CGSize,
      with coordinator: UIViewControllerTransitionCoordinator
    ) {
      super.viewWillTransition(to: size, with: coordinator)
        calendarCollectionView.reloadData()
    }

    
    //MARK: - Helpers
    func setUpCalendar() {
        // 뷰들을 뷰 계층에 추가
        view.addSubview(headerView)
        view.addSubview(calendarCollectionView)
        view.addSubview(footerView)
        
        // headerView 제약조건 설정
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // calendarCollectionView 제약조건 설정
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
            calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            calendarCollectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
        
        // footerView 제약조건 설정
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}

// MARK: - UICollectionViewDataSource
extension CalendarController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
            for: indexPath) as! CalendarDateCollectionViewCell
        
        cell.day = day
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let day = days[indexPath.row]
        selectedDateChanged(day.date)
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
        return CGSize(width: width, height: height)
    }
}

