//
//  ReviewView.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import SwiftUI

struct ReviewView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var currentUser: CurrentUser

    let recipeId: Int
    @State private var showingCompose = false

    var body: some View {
        VStack {
            if reviewViewModel.reviews.isEmpty {
                Text("No reviews yet. Be the first to write one!")
                    .foregroundColor(.secondary)
                    .padding()
            }

            List {
                ForEach(reviewViewModel.reviews) { review in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(review.username)
                                .font(.headline)
                            Spacer()
                            Text(review.createdAt ?? Date.distantFuture, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Text(review.text)
                            .font(.body)
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Reviews")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingCompose = true
                } label: {
                    Text("Write Review")
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(reviewViewModel.userHasReview ? Color.gray.opacity(0.4) : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(reviewViewModel.userHasReview)
            }
        }
        .task {
            if let userId = currentUser.id {
                await reviewViewModel.loadReviews(for: recipeId, userId: userId)
            }
        }
        .sheet(isPresented: $showingCompose) {
            ReviewCreationView(recipeId: recipeId)
                .environmentObject(reviewViewModel)
                .environmentObject(currentUser)
        }
    }
}

struct ReviewCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var currentUser: CurrentUser

    let recipeId: Int
    @State private var text: String = ""
    @State private var isSaving = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Write your review for this recipe:")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 20)

                TextEditor(text: $text)
                    .padding()
                    .frame(minHeight: 150)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Write Review")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        Task { await save() }
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { errorMessage != nil },
                set: { _ in errorMessage = nil }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func save() async {
        guard let _ = currentUser.id else { return }
        isSaving = true
        defer { isSaving = false }

        do {
            try await reviewViewModel.submitReview(
                for: recipeId,
                text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                currentUser: currentUser
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
