//
//  SearchResponse.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//

// This model will be used for getting a response from Spoonacular when we're using the complexSearch URL. ComplexSearch has only some attributes, and not as many as searching using the /recipes/{id}information URL. Thus, we'll use this model to show the most importants parts of a recipe (title, image, etc), and expand upon it when the user clicks the feed row.
// 
struct SearchResponse: Codable {
    let results: [SearchRecipe]
    let offset: Int?
    let number: Int?
    let totalResults: Int?
}

struct SearchRecipe: Codable, Identifiable, Hashable {
    let id: Int
    let title: String?
    let image: String?
    let imageType: String?

    // Can only get this when the URL has addRecipeNutrition=true
    let nutrition: SearchNutrition?
}

struct SearchNutrition: Codable, Hashable {
    let nutrients: [SearchNutrient]?
}

struct SearchNutrient: Codable, Hashable {
    let name: String?
    let amount: Double?
    let unit: String?
}

