//
//  Goal.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/14/23.
//

import Foundation
import CoreData

public class Goal: NSManagedObject {
    @NSManaged public var goalDescription: String
    @NSManaged public var goalTargetDate: Date
    @NSManaged public var completionStatus: Bool
    @NSManaged public var goalName: String
    // Add more attributes as needed

    // Ensure the correct initialization
    convenience init(goalDescription: String, goalTargetDate: Date, completionStatus: Bool, goalName: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GoalEntity", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.goalDescription = goalDescription
        self.goalTargetDate = goalTargetDate
        self.completionStatus = completionStatus
        self.goalName = goalName
    }
}

