//
//  Workout.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/13/23.
//

import Foundation
import CoreData

// Define the Workout entity
public class Workout: NSManagedObject {
    @NSManaged public var date: Date
    @NSManaged public var exercise: String
    @NSManaged public var duration: String
    @NSManaged public var descriptionText: String
    @NSManaged public var workoutType: String
    @NSManaged public var sets: String
    @NSManaged public var reps: String
    
    // Add more attributes as needed for your workout data

    convenience init(date: Date, exercise: String, duration: String, descriptionText: String, workoutType: String, sets: String, reps: String , context: NSManagedObjectContext) {
        self.init(context: context)
        self.date = date
        self.exercise = exercise
        self.duration = duration
        self.descriptionText = descriptionText
        self.workoutType = workoutType
        self.sets = sets
        self.reps = reps
        // Initialize other attributes as needed
    }
}
