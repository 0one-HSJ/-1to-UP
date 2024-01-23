//
//  MainPurpose+CoreDataProperties.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/23/24.
//
//

import Foundation
import CoreData


extension MainPurpose {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainPurpose> {
        return NSFetchRequest<MainPurpose>(entityName: "MainPurpose")
    }

    @NSManaged public var color: Int64
    @NSManaged public var mainPurposeText: String?
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension MainPurpose {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}

extension MainPurpose : Identifiable {

}
