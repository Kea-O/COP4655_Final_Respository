//
//  Review.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import FirebaseFirestore

// A review model that'll save the poster's ID and username, but also the recipe ID.
struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var recipeId: Int
    var userId: String
    var username: String
    var text: String
    @ServerTimestamp var createdAt: Date?
}
