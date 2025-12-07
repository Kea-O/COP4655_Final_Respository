//
//  DownloadViewModel.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import Foundation

// Now we'll create a ViewModel to allow us to download and save the Recipe locally, so that users can access recipes even while offline.
class DownloadViewModel: ObservableObject {
    // We'll create a variable for the path to our local document folder:
    private var recipesDirectory: URL {
        // We'll need to use FileManager and create/access a document and folder directory. We'll name it "SavedRecipes"
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = docs.appendingPathComponent("SavedRecipes")
        
        // If the folder/file doesn't exist, we'll create it:
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    // Now we need a function to save the Recipes the user wants:
    func saveRecipe(_ recipe: Recipe) throws {
        guard let id = recipe.id else { return }
        
        // Create a path to a new file in the Recipe directory. The file's name will be the recipe's ID.
        let fileURL = recipesDirectory.appendingPathComponent("\(id).json")
        
        // Save the recipe to this new file via JSON.
        let data = try JSONEncoder().encode(recipe)
        try data.write(to: fileURL, options: .atomic)
    }

    // Create a function to load one specific recipe from local storage via it's ID.
    func loadRecipe(id: Int) -> Recipe? {
        let fileURL = recipesDirectory.appendingPathComponent("\(id).json")
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(Recipe.self, from: data)
    }

    // Make another function to load all locally-stored recipes.
    func loadAllRecipes() -> [Recipe] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: recipesDirectory, includingPropertiesForKeys: nil) else { return [] }
        
        // compactMap them from JSON data into Recipe model types.
        return files.compactMap { url in
            guard let data = try? Data(contentsOf: url) else { return nil }
            return try? JSONDecoder().decode(Recipe.self, from: data)
        }
    }

    // Create a function to delete recipes from local storage via their ID.
    func deleteRecipe(id: Int) {
        let fileURL = recipesDirectory.appendingPathComponent("\(id).json")
        try? FileManager.default.removeItem(at: fileURL)
    }
}
