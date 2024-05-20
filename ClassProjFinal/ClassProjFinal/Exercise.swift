import SwiftUI
import Foundation

struct Exercise: Codable, Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let muscle: String
    let equipment: String
    let difficulty: String
    let instructions: String

    private enum CodingKeys: String, CodingKey {
        case name, type, muscle, equipment, difficulty, instructions
    }
}

