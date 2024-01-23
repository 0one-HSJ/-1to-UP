//
//  ToDo+CoreDataProperties.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/20/24.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var purpose: String?
    @NSManaged public var mainPurpose: MainPurpose?
    @NSManaged public var parentTodo: ToDo?

}

extension ToDo : Identifiable {

}
