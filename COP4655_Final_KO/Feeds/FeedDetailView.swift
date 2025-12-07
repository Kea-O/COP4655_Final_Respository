//
//  FeedDetailView.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/7/25.
//
import SwiftUI

struct FeedDetailView: View {
    // A feedViewModel variable to hold an instance of the viewModel. Will be passed into this view via .environmentObject()
    @EnvironmentObject var feedViewModel: FeedViewModel
    
    // Get the DownloadViewModel so we can check if the recipe has been downloaded already:
    @EnvironmentObject var downloadViewModel: DownloadViewModel
    
    // A boolean value to gray out the recipe if it's been downloaded:
    @State private var isDownloaded: Bool = false
    
    // ID variable to get the ID from a previous View:
    let ID: Int
        
    var body: some View {
        ScrollView {
            // Get the recipe after using .onAppear to get the details of the recipe and send them into the Recipe model configuration.
            if let recipe = feedViewModel.recipe, recipe.id == ID  {
                VStack(alignment: .leading, spacing: 20) {
                    // Display the Recipe Image
                    AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(7/5, contentMode: .fill)
                    } placeholder: {
                        Color(.systemGray4)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(16)
                    
                    // Display the Title & Source of the recipe
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recipe.title ?? "Unknown Recipe")
                            .font(.largeTitle)
                            .bold()
                        Text("by \(recipe.sourceName ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(recipe.sourceUrl ?? "")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    
                    // Create a button to download the recipe. If it is already downloaded, grey out the button:
                    Button {
                        downloadRecipe(recipe)
                    } label: {
                        HStack {
                            Image(systemName: isDownloaded ? "checkmark.circle.fill" : "arrow.down.circle")
                            Text(isDownloaded ? "Downloaded" : "Download")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isDownloaded ? Color.gray.opacity(0.4) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isDownloaded)
                    
                    // A button to review the recipe. Only available when online:
                    NavigationLink {
                        // pass recipe id to the reviewView
                        ReviewView(recipeId: recipe.id ?? 0)
                    } label: {
                        HStack {
                            Image(systemName: "pencil.circle")
                            Text("Reviews")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    
                    // Display how long it'll take to prepare and cook
                    HStack(spacing: 16) {
                        Label("\(recipe.readyInMinutes ?? 0) min", systemImage: "clock")
                        Label("\(recipe.servings ?? 0) servings", systemImage: "person.2")
                    }
                    .font(.subheadline)
                    
                    // Show the summary
                    if let summary = recipe.summary {
                        Divider()
                        Text("Summary")
                            .font(.headline)
                        Text(summary.htmlStripped())
                    }
                    
                    Divider()
                    
                    // Display tags based on if the recipe conforms to a diet or not. They'll be stored horizontally and spill over vertically if there are a bunch of tags.
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
                    
                    // List the ingredients
                    if let ingredients = recipe.extendedIngredients, !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)
                            ForEach(ingredients, id: \.self) { ingredient in
                                Text("• \(ingredient.original ?? "")")
                            }
                        }
                    }
                    
                    // Show the instructions
                    if let instructions = recipe.analyzedInstructions, !instructions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.headline)
                            RecipeInstructionsView(instructions: instructions)
                        }
                    }


                    
                    // Display the nutrition for the recipe
                    if let nutrients = recipe.nutrition?.nutrients, !nutrients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutrition")
                                .font(.headline)
                            // Table-like layout
                            VStack(spacing: 4) {
                                ForEach(nutrients, id: \.self) { nutrient in
                                    HStack {
                                        Text(nutrient.name ?? "")
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("\(nutrient.amount ?? 0, specifier: "%.1f") \(nutrient.unit ?? "")")
                                            .font(.body)
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
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            feedViewModel.recipe = nil
            Task {
                // Check if the recipe has been downloaded already:
                isDownloaded = downloadViewModel.loadRecipe(id: ID) != nil
                
                // Load the recipe details:
                await feedViewModel.fetchRecipeDetails(ID: ID)
            }
        }
    }
    // Create a function for downloading the recipe by using the downloadviewModel's function:
    private func downloadRecipe(_ recipe: Recipe) {
        do {
            try downloadViewModel.saveRecipe(recipe)
            isDownloaded = true
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
}

// The Tag View for Diet/Attribute Labels
struct TagView: View {
    let label: String
    var body: some View {
        Text(label)
            .font(.caption)
            .padding(6)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

// Further break down this view by adding another view for the instructions. Since instructions use a nested Foreach() inside a ForEach(), to prevent the error "The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions", we'll break it down.
struct RecipeInstructionsView: View {
    let instructions: [ExtendedInstructions]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(instructions.indices, id: \.self) { sectionIndex in
                let section = instructions[sectionIndex]
                
                ForEach(section.steps.indices, id: \.self) { stepIndex in
                    let step = section.steps[stepIndex]
                    
                    HStack(alignment: .top, spacing: 12) {
                        // Step number in circle
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 30, height: 30)
                            Text("\(step.number ?? 0)")
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                        // Step text
                        Text(step.step ?? "")
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}



// HTML stripping extension
extension String {
    func htmlStripped() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributedString.string
        }
        return self
    }
}
