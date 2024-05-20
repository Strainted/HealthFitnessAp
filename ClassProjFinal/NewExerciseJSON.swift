import SwiftUI

struct NewExerciseJSON: View {
    @State private var selectedType = ""
    @State private var selectedMuscle = ""
    @State private var exercises: [Exercise] = []
    @State private var isShowingSheet = false
    
    let type = ["","cardio", "olympic_weightlifting", "plyometrics", "powerlifting", "strength", "stretching", "strongman"]
    let muscles = [
        "",
        "abdominals",
        "abductors",
        "adductors",
        "biceps",
        "calves",
        "chest",
        "forearms",
        "glutes",
        "hamstrings",
        "lats",
        "lower_back",
        "middle_back",
        "neck",
        "quadriceps",
        "traps",
        "triceps"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Type Picker with Label
                
                HStack {
                    Text("Select a Muscle")
                        .foregroundColor(.blue) // Change text color
                    Picker("", selection: $selectedMuscle) {
                        ForEach(muscles, id: \.self) { muscle in
                            Text(muscle)
                                .tag(muscle)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .foregroundColor(.blue) // Change picker color
                }
                .padding()
                
                // Fetch Exercises Button
                Button("Fetch Exercises") {
                    fetchExercises()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
                ExerciseList(exercises: exercises)
            }
            .navigationTitle("New Exercise Generator")
            .padding()
        }
    }
    func fetchExercises() { //JSON parsing function provided by RAPID-API.com
        if let encodedMuscle = selectedMuscle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "https://exercises-by-api-ninjas.p.rapidapi.com/v1/exercises?muscle=\(encodedMuscle)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "X-RapidAPI-Key": "154da4c6d9msh55bc89ec2dfaa59p17f7fajsneb37771b521b",
                "X-RapidAPI-Host": "exercises-by-api-ninjas.p.rapidapi.com"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode([Exercise].self, from: data) //add the decoded data to an exercise object
                    DispatchQueue.main.async {
                        self.exercises = decodedData
                        // Show the list of exercises when data is fetched
                        self.isShowingSheet = true
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }
}

struct ExerciseList: View { //display the returned JSON Exercises
    var exercises: [Exercise]

    var body: some View {
        NavigationView {
            List(exercises) { exercise in
                VStack(alignment: .leading) {
                    Text("Name: \(exercise.name)").foregroundColor(.red)
                    Text("Instructions: \(exercise.instructions)").foregroundColor(.black)                }
            }
            .navigationTitle("Exercise List")
        }
    }
}


struct NewExerciseJSON_Preview: PreviewProvider {
    static var previews: some View {
        NewExerciseJSON()
    }
}

