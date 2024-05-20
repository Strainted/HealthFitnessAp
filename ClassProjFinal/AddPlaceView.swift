//
//  AddPlaceView.swift
//  ClassProjFinal
//
//  Created by Luke Benjamin Engel  on 11/19/23.
//


import SwiftUI

struct AddPlaceView: View { //basic view to add a place to display on the map
    @ObservedObject var viewModel: AppViewModel
    @Binding var isPresented: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Binding var name: String
    @Binding var address: String

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Address", text: $address)
                }

                Section {
                    Button("Add Place") {
                        if !name.isEmpty && !address.isEmpty {
                            viewModel.addPlace(name: name, address: address) //adds place to the list 
                            isPresented.toggle()
                        } else {
                            showAlert = true
                            alertMessage = "Name and Address cannot be empty."
                        }
                    }
                }
            }
            .navigationTitle("Add Place")
            .navigationBarItems(trailing:
                Button("Cancel") {
                    isPresented.toggle()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

