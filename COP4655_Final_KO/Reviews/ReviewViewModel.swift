//
//  ReviewViewModel.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import SwiftUI
import FirebaseFirestore

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var userHasReview = false

    private let db = Firestore.firestore()

    func loadReviews(for recipeId: Int, userId: String) async {
        do {
            // Get the data from Firstore:
            let reviewData = try await db.collection("reviews")
                .whereField("recipeId", isEqualTo: recipeId)
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            // Turn them into Review models:
            self.reviews = reviewData.documents.compactMap { doc in try? doc.data(as: Review.self)
            }
            
            // Check if one of the reviews is ours:
            self.userHasReview = reviews.contains(where: { $0.userId == userId })
        } catch {
            print("Error loading reviews: \(error.localizedDescription)")
            self.reviews = []
            self.userHasReview = false
        }
    }

    func submitReview(for recipeId: Int, text: String, currentUser: CurrentUser) async throws {
            // If the user has already submitted a review, block the request:
            guard !userHasReview, let userId = currentUser.id else {
                throw NSError(domain: "Review", code: 1, userInfo: [NSLocalizedDescriptionKey: "You have already submitted a review"])
            }

            let review = Review(
                id: UUID().uuidString,
                recipeId: recipeId,
                userId: userId,
                username: currentUser.username,
                text: text,
                createdAt: Date()
            )

        try db.collection("reviews").document(review.id ?? UUID().uuidString).setData(from: review)

            // Update local array too
            reviews.insert(review, at: 0)
            userHasReview = true
        }
}
