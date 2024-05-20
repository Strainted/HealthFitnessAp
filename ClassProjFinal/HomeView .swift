import SwiftUI

struct HomeView: View {
    @State private var isCreateGoalSheetPresented = false
    @StateObject var viewModel: AppViewModel
    @State private var isShowingExerciseSheet = false
    @State private var isShowingCompletedGoalsSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.savedGoals, id: \.self) { goal in //list of goals saved
                        NavigationLink(
                            destination: goalDetailView(viewModel: viewModel, selectedGoal: $viewModel.selectedGoal),
                            tag: goal,
                            selection: $viewModel.selectedGoal
                        ) {
                            VStack(alignment: .leading) {
                                Text("Goal: \(goal.goalName ?? "")")
                            }
                            .padding()
                        }
                        .isDetailLink(false)
                    }
                }
                
                
                Button("Add New Goal") { //create new goals
                    isCreateGoalSheetPresented.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
                Button("View Completed Goals") { //pulls up sheet of completed goals 
                    isShowingCompletedGoalsSheet.toggle()
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                .sheet(isPresented: $isShowingCompletedGoalsSheet) {
                    CompletedGoalsView(viewModel: viewModel)
                }

            }
            .sheet(isPresented: $isCreateGoalSheetPresented) {
                createGoalView(viewModel: viewModel)
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: AppViewModel())
    }
}

