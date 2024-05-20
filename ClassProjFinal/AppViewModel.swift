//
//  AppViewModel.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/13/23.
//
import SwiftUI
import CoreData
import CoreLocation

class AppViewModel: ObservableObject {
    private var persistentContainer: NSPersistentContainer
    @Published var places: [Place] = []
    @Published var selectedGoal: GoalEntity?
    @Published var savedWorkouts: [WorkoutEntity] = []
    @Published var savedGoals: [GoalEntity] = []
    @Published var completedGoals: [CompletedGoalEntity] = []
    @Published var filteredWorkouts: [WorkoutEntity] = []

    init() {
        persistentContainer = NSPersistentContainer(name: "ClassProjFinal") 
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error)")
            }
        }

        // Fetch saved workouts when initializing the view model
        fetchSavedWorkouts()
        fetchSavedGoals()
        fetchCompletedGoals()
    }

    func saveWorkout(date: Date, descriptionText: String, workoutType: String, duration: String, sets: String, reps: String, muscleGroup: String) { //create new workout object and save it to coredata
        let context = persistentContainer.viewContext

        
        
        let workout = WorkoutEntity(context: context)
        workout.date = date
        workout.descriptionText = descriptionText
        workout.workoutType = workoutType
        workout.duration = duration
        workout.sets = sets
        workout.reps = reps
        workout.muscleGroup = muscleGroup

        do {
            try context.save()
            // After saving, update the list of saved workouts
            fetchSavedWorkouts()
        } catch {
            print("Error saving workout: \(error.localizedDescription)")
        }
    }

    private func fetchSavedWorkouts() { //fetch saved workouts from coreData
        let context = persistentContainer.viewContext

        do {
            savedWorkouts = try context.fetch(WorkoutEntity.fetchRequest())
        } catch {
            print("Error fetching workouts: \(error.localizedDescription)")
        }
    }
    
    
    func saveGoal(goalDescription: String, goalTargetDate: Date, completionStatus: Bool, goalName: String) { //saves new goal unless greater 3 goals are already saved
        let context = persistentContainer.viewContext
        
        if savedGoals.count >= 3 { //limiter
            print("Active goal limit reached. You can't add more active goals until some are completed.")
            return
        }
        
        let newGoal = GoalEntity(context: context) //newGoal constructor
        newGoal.goalDescription = goalDescription
        newGoal.goalTargetDate = goalTargetDate
        newGoal.completionStatus = completionStatus
        newGoal.goalName = goalName
        
        do {
            try context.save()
            fetchSavedGoals()
        } catch {
            print("Error saving goals: \(error.localizedDescription)")
        }
    }
    
    private func fetchSavedGoals() {
            let context = persistentContainer.viewContext
            
            do {
                savedGoals = try context.fetch(GoalEntity.fetchRequest())
            } catch {
                print("Error fetching Goals: \(error.localizedDescription)")
            }
        }
    
    func deleteGoal(_ goal: GoalEntity) {
            let context = persistentContainer.viewContext

            // Delete the goal from the context
            context.delete(goal)

            do {
                // Save the context after deletion
                try context.save()
                // Fetch the updated list of goals
                fetchSavedGoals()
            } catch {
                print("Error deleting goal: \(error.localizedDescription)")
            }
        }
    
    func selectGoal(_ goal: GoalEntity) {
        selectedGoal = goal
    }
    
    func toggleCompletionStatus(_ goal: GoalEntity) {
        goal.completionStatus.toggle() // Toggle the completion status

        if goal.completionStatus {
            // If goal is completed, move it to completedGoals
            completeGoal(goal)
        }

        // Save the context after updating the goal
        saveContext()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func completeGoal(_ goal: GoalEntity) {
        let context = persistentContainer.viewContext

        // Move the completed goal to the completedGoals list
        if let index = savedGoals.firstIndex(of: goal) {
            let completedGoal = CompletedGoalEntity(context: context)
            completedGoal.goalDescription = goal.goalDescription
            completedGoal.goalTargetDate = goal.goalTargetDate
            completedGoal.completionStatus = goal.completionStatus
            completedGoal.goalName = goal.goalName

            // Add the completed goal to the completedGoals list
            completedGoals.append(completedGoal)

            // Delete the goal from the savedGoals list
            savedGoals.remove(at: index)

            //delete the goal so it removes it completely from the homeView list
            deleteGoal(goal)
            
            saveContext()

            // Fetch the updated list of goals
            fetchSavedGoals()

            DispatchQueue.main.async { [unowned self] in
                // Notify SwiftUI to refresh the view
                self.objectWillChange.send()
            }

        }
    }
    
    func fetchCompletedGoals() {
            let context = persistentContainer.viewContext

            do {
                completedGoals = try context.fetch(CompletedGoalEntity.fetchRequest())
            } catch {
                print("Error fetching completed goals: \(error.localizedDescription)")
            }
        }
    


    class GeocodingManager { //basic reverse geocding function
        static func reverseGeocode(address: String, completion: @escaping (CLPlacemark?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("No placemark found")
                    completion(nil)
                    return
                }
                
                completion(placemark)
            }
        }
    }
    
    func addPlace(name: String, address: String) { //adds new place to the placeView
        // Use the geocoding manager to get latitude and longitude
        GeocodingManager.reverseGeocode(address: address) { placemark in
            guard let location = placemark?.location else {
                print("Unable to get location from address")
                return
            }
            
            let place = Place(name: name, address: address, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.places.append(place)
        }
    }
    
    

    func fetchWorkoutsInRange(startDate: Date, endDate: Date) { //fetches workouts saved within range of dates selected by user
        let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)

        do {
            filteredWorkouts = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching filtered workouts: \(error.localizedDescription)")
        }
    }


}

    
    
    
    
    
    
    

