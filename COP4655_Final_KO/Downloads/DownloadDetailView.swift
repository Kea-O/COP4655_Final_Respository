//
//  DownloadDetailView.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import SwiftUI

// Create a function that behaves similar to FeedDetailView but uses DownloadViewModel functions to load the data:
struct DownloadDetailView: View {
    // Connect to downloadViewModel
    @EnvironmentObject var downloadViewModel: DownloadViewModel
    
    // A dismiss variable to get out of the detail view:
    @Environment(\.dismiss) private var dismiss
    
    // Create a recipe variable to get the recipe data sent in to this View;
    let recipe: Recipe?
    
    var body: some View {
        ScrollView {
            if let recipe = recipe {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Image
                    AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(7/5, contentMode: .fill)
                    } placeholder: {
                        Color(.systemGray4)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(16)
                    
                    // Title + Source
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recipe.title ?? "Unknown Recipe")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("by \(recipe.sourceName ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let url = recipe.sourceUrl {
                            Text(url)
                                .font(.caption)
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    
                    // No download button
                    
                    // Prep / Cook info
                    HStack(spacing: 16) {
                        Label("\(recipe.readyInMinutes ?? 0) min", systemImage: "clock")
                        Label("\(recipe.servings ?? 0) servings", systemImage: "person.2")
                    }
                    .font(.subheadline)
                    
                    // Summary
                    if let summary = recipe.summary {
                        Divider()
                        Text("Summary")
                            .font(.headline)
                        Text(summary.htmlStripped())
                    }
                    
                    Divider()
                    
                    // Tags
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Diet & Tags")
                            .font(.headline)
                        
                        HStack {
                            if recipe.cheap == true { TagView(label: "Cheap") }
                            if recipe.dairyFree == true { TagView(label: "Dairy Free") }
                            if recipe.glutenFree == true { TagView(label: "Gluten Free") }
                            if recipe.ketogenic == true { TagView(label: "Keto") }
                            if recipe.lowFodmap == true { TagView(label: "Low FODMAP") }
                            if recipe.sustainable == true { TagView(label: "Sustainable") }
                            if recipe.vegan == true { TagView(label: "Vegan") }
                            if recipe.veryHealthy == true { TagView(label: "Healthy") }
                            if recipe.veryPopular == true { TagView(label: "Popular") }
                            if recipe.whole30 == true { TagView(label: "Whole30") }
                        }
                        .lineLimit(nil)
                        .padding(.vertical, 4)
                    }
                    
                    Divider()
                    
                    // Ingredients
                    if let ingredients = recipe.extendedIngredients, !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)
                            
                            ForEach(ingredients, id: \.self) { ingredient in
                                Text("• \(ingredient.original ?? "")")
                            }
                        }
                    }
                    
                    // Instructions
                    if let instructions = recipe.analyzedInstructions, !instructions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.headline)
                            RecipeInstructionsView(instructions: instructions)
                        }
                    }
                    
                    // Nutrition
                    if let nutrients = recipe.nutrition?.nutrients, !nutrients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutrition")
                                .font(.headline)
                            
                            VStack(spacing: 4) {
                                ForEach(nutrients, id: \.self) { nutrient in
                                    HStack {
                                        Text(nutrient.name ?? "")
                                        Spacer()
                                        Text("\(nutrient.amount ?? 0, specifier: "%.1f") \(nutrient.unit ?? "")")
                                            .foregroundColor(.secondary)
                                    }
                                    Divider()
                                }
                            }
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Saved Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    if let recipe = recipe, let id = recipe.id {
                        downloadViewModel.deleteRecipe(id: id)
                        dismiss()
                    }
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}
