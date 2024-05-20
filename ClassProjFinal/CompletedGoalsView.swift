//
//  CompletedGoalsView.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/21/23.
//

import Foundation
import SwiftUI

struct CompletedGoalsView: View { //view for displaying completed goals 
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.completedGoals, id: \.id) { goal in
                    VStack(alignment: .leading) {
                        Text("Goal Name: \(goal.goalName ?? "")")
                        Text("Goal Description: \(goal.goalDescription ?? "")")
                        Text("Target Date: \(goal.goalTargetDate ?? Date())")
                        Text("Status: Completed")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                }
            }
            .navigationTitle("Completed Goals")
        }
    }
}
