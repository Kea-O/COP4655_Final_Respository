//
//  FeedViewModel.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/7/25.
//
import SwiftUI

// We'll create a ViewModel to handle functions concerning API calls
@MainActor
class FeedViewModel: ObservableObject {
    @Published var searchRecipes: [SearchRecipe] = []
    @Published var recipe: Recipe?
    
    // Create a way to disguise the API key so it isn't straight-up in the front end. Still won't stop a dedicated person, but it's good enough for a student project.
    private var APIKEY: String {
            guard
                let path = Bundle.main.path(forResource: "config", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path),
                let key = dict["SPOONACULAR_API_KEY"] as? String
            else {
                print("❌ Missing API key")
                return ""
            }
            return key
        }
    
    // A function to send the API call to Spoonacular. It'll take in a query, inclusions, and exclusions
    func fetchRecipes(query: String,
                      include: [String] = [],
                      exclude: [String] = []) async {
        // create the base URL string containing only the query and APIKEY
        var urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&addRecipeNutrition=true&apiKey=\(APIKEY)&number=5"
        
        // Check if include or excluse is empty. If they have something, add them to the base urlString.
        if !include.isEmpty {
            urlString += "&includeIngredients=\(include.joined(separator: ","))"
        }
        if !exclude.isEmpty {
            urlString += "&excludeIngredients=\(exclude.joined(separator: ","))"
        }
        
        // Check if the URL is valid:
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode json data into a SearchResponse model
            let searchData = try JSONDecoder().decode(SearchResponse.self, from: data)
            
            // Save the data into our recipes variable.
            self.searchRecipes = searchData.results
            
            // Print the recipe name of each recipe in the array
            for recipe in searchRecipes {
                print(recipe.title ?? "Can't get title")
            }
        } catch {
            print("Error fetching recipes:", error.localizedDescription)
        }
    }
    
    func fetchRecipeDetails(ID: Int) async {
        let url = "https://api.spoonacular.com/recipes/\(ID)/information?includeNutrition=true&apiKey=\(APIKEY)"
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        do {
            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode json data into a Recipe model
            let response = try JSONDecoder().decode(Recipe.self, from: data)
            
            // Save the data into our recipe variable.
            self.recipe = response
            
            // Print our recipe that we got:
            print(self.recipe?.title ?? "Can't get title")
        } catch {
            print("Error fetching recipes:", error.localizedDescription)
        }
    }
}
