//
//  MainTabController.swift
//  (1 to)UP beta
//
//  Created by 하상준 on 1/14/24.
//

import UIKit

class MainTabController: UITabBarController {
    
    // 현재 날짜를 기준 날짜로 설정
    let baseDate = Date()

    // 선택된 날짜가 변경되었을 때 실행할 클로저 정의
    let selectedDateChanged: (Date) -> Void = { selectedDate in
        print("선택된 날짜: \(selectedDate)")
    }

    // CalendarController 인스턴스 생성
    private lazy var calendarController = CalendarController(baseDate: baseDate, selectedDateChanged: selectedDateChanged)

    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTab()
        
    }
    
   
    //MARK: - Helpers
    
    func configureTab() {
        //tabBarappearance객체를 이용해야 ui설정 가능
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        let todo = templateNavigationController(unselectedImage: UIImage(systemName: "checkmark.seal")!, selectedImage: UIImage(systemName: "checkmark.seal.fill")!, rootVC: ToDoController())
        
        let calendar = templateNavigationController(unselectedImage: UIImage(systemName: "calendar.circle")!, selectedImage: UIImage(systemName: "calendar.circle.fill")!, rootVC: calendarController)
        
        viewControllers = [todo, calendar]
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        //navigationBarappearance객체를 이용해야 ui설정 가능
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        if #available(iOS 15, *) {
            nav.navigationBar.scrollEdgeAppearance = appearance
        }

        return nav
    }
    
}

