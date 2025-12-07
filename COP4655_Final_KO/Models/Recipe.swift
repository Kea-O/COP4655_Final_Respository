//
//  Recipe.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/7/25.
//

// This model will be for when we get a lot of data about it via the URL search with the recipe ID.
struct Recipe: Codable, Identifiable, Hashable {
    let id: Int?
    let title: String?
    let image: String?
    
    let servings: Int?
    let readyInMinutes: Int?
    let sourceName: String?
    let sourceUrl: String?
    let summary: String?
    
    let cheap: Bool?
    let pricePerServing: Double?
    let dairyFree: Bool?
    let glutenFree: Bool?
    let ketogenic: Bool?
    let lowFodmap: Bool?
    let sustainable: Bool?
    let vegan: Bool?
    let veryHealthy: Bool?
    let veryPopular: Bool?
    let whole30: Bool?
    
    let analyzedInstructions: [ExtendedInstructions]?
    let extendedIngredients: [Ingredient]?
    
    let nutrition: NutritionDetail?
}

struct ExtendedInstructions: Codable, Hashable {
    let steps: [InstructionStep]
}

struct InstructionStep: Codable, Hashable {
    let number: Int?
    let step: String?
}

struct Ingredient: Codable, Hashable {
    let original: String?
}

struct NutritionDetail: Codable, Hashable {
    let nutrients: [Nutrient]?
}

struct Nutrient: Codable, Hashable {
    let name: String?
    let amount: Double?
    let unit: String?
}
