import SwiftUI

struct CalendarView: View {
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date) //start date for coreData fetching
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()

                DatePicker("End Date", selection: $endDate, displayedComponents: .date) //end date for coreData fetching
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()

                Button("Filter Workouts") {
                    viewModel.fetchWorkoutsInRange(startDate: startDate, endDate: endDate)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                // Display a list of filtered workouts
                Section(header: Text("Filtered Workouts")) { //list of filtered saved workouts 
                    List(viewModel.filteredWorkouts) { workout in
                        VStack(alignment: .leading) {
                            Text("Date: \(workout.date ?? Date()), Type: \(workout.workoutType ?? "")")
                                .font(.headline)
                            Text("Description: \(workout.descriptionText ?? "")")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Workout History")
        }
    }
}

