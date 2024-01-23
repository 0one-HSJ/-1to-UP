//
//  PurposeManager.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/19/24.
//

import UIKit
import CoreData

final class MainPurposeManager {
    static let shared = MainPurposeManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName = "MainPurpose"
    
    //MARK: - Create
    func saveData(mainPurposeText: String?, color: Int64, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        guard let context = context else { return }
        // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) else { return }
                
        // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> MainPurpose)
        guard let mainPurpose = NSManagedObject(entity: entity, insertInto: context) as? MainPurpose else { return }
                    
        // ToDoData에 실제 데이터 할당
        mainPurpose.mainPurposeText = mainPurposeText
        mainPurpose.color = color
                    
        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                print(error)
                completion()
            }
        }
        completion()
    }
    
    //MARK: - Read
    
    func fetchData() -> [MainPurpose] {
        var mainPurpose: [MainPurpose] = []
        
        guard let context = context else { return [] }
        let request = NSFetchRequest<NSManagedObject>(entityName: modelName)
        
        do {
            if let fetchedToDoList = try context.fetch(request) as? [MainPurpose] {
                mainPurpose = fetchedToDoList
            }
        } catch {
            print("가져오는 것 실패")
        }
        return mainPurpose
    }
    
    //MARK: - Update
    func update(mainPurpose: MainPurpose, newText: String?, newColor: Int64, completion: @escaping () -> Void) {
        guard let context = context else { return }

        // MainPurpose 객체의 속성 업데이트
        mainPurpose.mainPurposeText = newText
        mainPurpose.color = newColor

        // 변경사항 저장
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                print("업데이트 실패: \(error)")
                completion()
            }
        } else {
            completion()
        }
    }

    
    //MARK: - Delete
    func delete(mainPurpose: MainPurpose, completion: @escaping () -> Void) {
        guard let context = context else { return }

        // Core Data Context에서 객체 삭제
        context.delete(mainPurpose)

        // 변경사항 저장
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                print("삭제 실패: \(error)")
                completion()
            }
        } else {
            completion()
        }
    }

    
    
}
