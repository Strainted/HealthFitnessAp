//
//  createGoalView.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/14/23.

import SwiftUI
import CoreData

struct createGoalView: View { //class for creating new goals
    @StateObject var viewModel: AppViewModel
    @State private var goalName: String = ""
    @State private var goalTargetDate: Date = Date()
    @State private var completionStatus: Bool = false
    @State private var goalDescription: String = ""
    
    var body: some View  {
        NavigationView {
            VStack {
                Form {
                    Section { //section for creating new goals
                        HStack {
                            Text("Goal Name")
                                .foregroundColor(.primary)
                            TextField("Required", text: $goalName)
                        }
                        HStack {
                            Text("Goal Description")
                                .foregroundColor(.primary)
                            TextField("Required", text: $goalDescription)
                        }
                        HStack {
                            Text("Target Completion Date")
                                .foregroundColor(.primary)
                            DatePicker("", selection: $goalTargetDate, displayedComponents: .date)
                                
                        }
                        
                        Button(action: { //save new goal 
                            viewModel.saveGoal(goalDescription: goalDescription, goalTargetDate: goalTargetDate, completionStatus: completionStatus, goalName: goalName)
                        }) {
                            Text("Add Goal")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle()).frame(alignment: .center)
                    }
                }
                .padding()
            }
            .navigationTitle("Create New Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(.blue) // Adjust the accent color
    }
}
