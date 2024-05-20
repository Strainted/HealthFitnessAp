import SwiftUI
import CoreData
import Foundation


struct WorkoutLogView: View { //class to building the view that allows users to add workouts
    @State private var selectedWorkoutType: String = ""
    @State private var workoutDescription: String = ""
    @State private var workoutDuration: String = ""
    @State private var sets: String = ""
    @State private var reps: String = ""
    @State private var selectedMuscleGroup: String = ""
    @State private var selectedDate: Date = Date()
    @StateObject private var viewModel = AppViewModel()
    @State private var isShowingExerciseSheet = false

    let workoutTypes = ["Endurance", "Strength", "Balance", "Flexibility"]
    let muscleGroups = ["Chest", "Upper Back", "Lower Back", "Legs", "Bicepts", "Tricepts", "Shoulders", "Abs", "Glutes"]
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose Workout Type")) { //select the type of workouts from workoutTypes list
                    Picker("Workout Type", selection: $selectedWorkoutType) {
                        ForEach(workoutTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Workout Details")) {
                    
                    if selectedWorkoutType == "Strength" { //new UI Picker if the user selects a strenght exercise
                        Picker("Muscle Group", selection: $selectedMuscleGroup) {
                            ForEach(muscleGroups, id: \.self) { group in
                                Text(group)
                            }
                        }
                    }
                    HStack {
                        Text("Description")
                        TextField("Required", text: $workoutDescription)
                    }

                    HStack {
                        Text("Duration")
                        TextField("mins", text: $workoutDuration)
                    }

                    HStack {
                        Text("Sets")
                        Spacer()
                        TextField("Enter Sets", value: $sets, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("Reps")
                        Spacer()
                        TextField("Enter Reps", value: $reps, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    }
                    
                }

                Section {
                    Button("Save Workout") { //adds the workout to a new workoutObject and saves it to coredata
                        viewModel.saveWorkout(
                            date: selectedDate,
                            descriptionText: workoutDescription,
                            workoutType: selectedWorkoutType,
                            duration: workoutDuration,
                            sets: sets,
                            reps: reps,
                            muscleGroup: selectedMuscleGroup
                        )

                        // Optionally, you can clear the text fields after saving
                        selectedWorkoutType = ""
                        workoutDescription = ""
                        workoutDuration = ""
                        sets = ""
                        reps = ""
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                HStack {
                    Button("Find New Exercise") { //Json Button that pulls up the sheet to find new exercises 
                        isShowingExerciseSheet.toggle()
                    }
                    .sheet(isPresented: $isShowingExerciseSheet) {
                        NewExerciseJSON()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                }
            }
            .navigationTitle("Workout Log")
        }
    }
}

