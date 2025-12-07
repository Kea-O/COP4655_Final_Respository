//
//  DownloadFeed.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import SwiftUI

// Here's a view similar to FeedView for the downloaded recipes:
struct DownloadFeedView: View {
    // Create an instance of the downloadViewModel for it's functions:
    @EnvironmentObject var downloadViewModel: DownloadViewModel

    // Create a variable to store the downloaded recipes in an array:
    @State private var downloadedRecipes: [Recipe] = []
    
    // Display them similarily to FeedView;
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(downloadedRecipes, id: \.id) { recipe in
                    NavigationLink {
                        DownloadDetailView(recipe: recipe)
                            .environmentObject(downloadViewModel)
                    } label: {
                        DownloadedRecipeRow(recipe: recipe)
                    }
                }
            }
            .padding(.top, 12)
        }
        .navigationTitle("Saved Recipes")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            downloadedRecipes = downloadViewModel.loadAllRecipes()
        }
    }
}

// Create a RecipeRow like FeedView to break up the code
struct DownloadedRecipeRow: View {
    let recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Get image url from the Recipe sent in
            AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color(.systemGray4)
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(16)
            
            // Gradient overlay to make text pop
            LinearGradient(
                colors: [.black.opacity(0.6), .black.opacity(0)],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height:150)
            .cornerRadius(16)
            
            // Text label
            Text(recipe.title ?? "Unknown")
                .font(.title2.bold())
                .foregroundColor(.white)
                .shadow(radius: 5)
                .padding()
        }
        .padding(.horizontal)
    }
}
