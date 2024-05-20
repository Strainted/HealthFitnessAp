import SwiftUI

struct goalDetailView: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var selectedGoal: GoalEntity?
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) { //display the goal descriptions
                    Text("Goal Name: \(selectedGoal?.goalName ?? "")")
                    Text("Goal Description: \(selectedGoal?.goalDescription ?? "")")
                    Text("Target Date: \(selectedGoal?.goalTargetDate ?? Date())")
                    Text("Status: \(selectedGoal?.completionStatus ?? false ? "Completed" : "Not Completed")")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))

                Button(action: { //complete the goal and remove it from the list
                    viewModel.toggleCompletionStatus(selectedGoal!)
                }) {
                    Text(selectedGoal?.completionStatus ?? false ? "Mark as Incomplete" : "Mark as Completed")
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))

                Button( action: { //deletes the goal from the savedGoals list 
                    showAlert = true
                }) {
                    Text("Delete Goal")
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.red))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Delete Goal"),
                        message: Text("Are you sure you want to delete this goal?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let goalToDelete = selectedGoal {
                                viewModel.deleteGoal(goalToDelete)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
            .navigationTitle("Goal Details")
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}

struct goalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        goalDetailView(viewModel: AppViewModel(), selectedGoal: .constant(nil))
    }
}

