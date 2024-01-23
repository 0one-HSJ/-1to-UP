//
//  ToDoManager.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/22/24.
//

import UIKit
import CoreData

class ToDoManager {
    //MARK: - Core Data Context
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName = "ToDo"
    
    
    //MARK: - Create
    func createTodo(for mainPurpose: MainPurpose, title: String, startDate: Date, endDate: Date, parentTodo: ToDo? = nil, completion: @escaping (ToDo?, Bool) -> Void) {
        
        guard let context = context else { return }
        
        guard let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) else {
            completion(nil, false)
            return
        }
        
        guard let newTodo = NSManagedObject(entity: entity, insertInto: context) as? ToDo else {
            completion(nil, false)
            return
        }
        
        newTodo.title = title
        newTodo.startDate = startDate
        newTodo.endDate = endDate
        newTodo.uuid = UUID()
        newTodo.mainPurpose = mainPurpose
        newTodo.parentTodo = parentTodo
        
        mainPurpose.addToTodos(newTodo)
        
        if context.hasChanges {
            do {
                try context.save()
                completion(newTodo, true)
            } catch {
                print("Error saving context: \(error)")
                completion(nil, false)
            }
        } else {
            completion(newTodo, true)
        }
    }
    
    //MARK: - Read
    
    func fetchData(for purpose: MainPurpose) -> [ToDo] {
        var todoList: [ToDo] = []
        
        guard let context = context else { return [] }
        let request = NSFetchRequest<NSManagedObject>(entityName: modelName)
        
        // NSPredicate를 사용하여 특정 MainPurpose와 관련된 ToDo만 필터링
        let predicate = NSPredicate(format: "mainPurpose == %@", purpose)
        request.predicate = predicate
        
        do {
            if let fetchedToDoList = try context.fetch(request) as? [ToDo] {
                todoList = fetchedToDoList
            }
        } catch {
            print("가져오는 것 실패")
        }
        return todoList
    }
    
    //MARK: - Update
    
    func updateTodo(for todo: ToDo, title: String, startDate: Date, endDate: Date, parentTodo: ToDo? = nil, completion: @escaping (Bool) -> Void) {
        
        guard let context = context else { return }
        
        todo.parentTodo = parentTodo
        todo.startDate = startDate
        todo.endDate = endDate
        
        todo.title = title
        
        if context.hasChanges {
            do {
                try context.save()
                completion(true)
            } catch {
                print("Error saving context: \(error)")
                completion(false)
            }
        } else {
            completion(true)
        }
    }
    
    //MARK: - Delete

    func delete(todo: ToDo, completion: @escaping () -> Void) {
        guard let context = context else { return }
        
        // Core Data Context에서 객체 삭제
        context.delete(todo)
        
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
