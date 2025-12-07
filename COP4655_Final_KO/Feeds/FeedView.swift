//
//  FeedView.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/7/25.
//
import SwiftUI

struct FeedView: View {
    // Create a FeedViewModel instance so we can use its functions to call the API
    @EnvironmentObject var feedViewModel: FeedViewModel
    
    // A variable to contain the search parameters given in the FeedSearchView:
    let searchParams: RecipeSearchParameters

    var body: some View {
        // A ScrollView allows users to view items in an app as a scrolling list.
        ScrollView {
            // LazyVStack is a view that line sup elements in a vertical row. It only adds new items AS NEEDED. This makes it good for situations where there are a lot of items that need expensive tasks performed for each, such as downloading and displaying images.
            LazyVStack(spacing: 20) {
                ForEach(feedViewModel.searchRecipes) { searchRecipe in
                    // Pass in the recipe associated with the recipe row as the value
                    NavigationLink {
                        // The recipe row serves as the label for the NavigationLink
                        FeedDetailView(ID: searchRecipe.id)
                            .environmentObject(feedViewModel)
                    } label: {
                        RecipeRow(searchRecipe: searchRecipe)
                    }
                }
            }
            .padding(.top, 12)
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.large)
        .task {
            // Call the fetchRecipes function when the view appears.
            await feedViewModel.fetchRecipes(
                query: searchParams.query,
                include: Array(searchParams.includeTags),
                exclude: Array(searchParams.excludeTags))
        }
    }
}

// Create a function to handle creating the rectangles with images for the UI. Helps separate code into readable chunks for developers
struct RecipeRow: View {
    let searchRecipe: SearchRecipe

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Get image url from the Recipe sent in
            AsyncImage(url: URL(string: searchRecipe.image ?? "")) { image in
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
            Text(searchRecipe.title ?? "Unknown")
                .font(.title2.bold())
                .foregroundColor(.white)
                .shadow(radius: 5)
                .padding()
        }
        .padding(.horizontal)
    }
}
