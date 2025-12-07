//
//  FeedSearchView.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import SwiftUI

// Create a model for the search parameters:
struct RecipeSearchParameters: Hashable {
    var query: String = ""
    var includeTags: Set<String> = []
    var excludeTags: Set<String> = []
}

// We'll create a view for users to input their search terms and select inclusions or exclusions based on pre-determined values.
struct FeedSearchView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var currentUser: CurrentUser
    @State private var params = RecipeSearchParameters()
    
    // Create the tags that the user can choose from:
    let allowedIncludeTags: [String] = [
        "vegan", "vegetarian", "ketogenic",
        "cheap", "veryPopular", "sustainable"
    ]

    let allowedExcludeTags: [String] = [
        "dairy", "gluten", "peanut", "seafood", "soy"
    ]
    
    // Create a variable to control whether the user can go to the FeedView yet.
    @State private var navigateToFeed = false
    
    var body: some View {
        Form {
            // Have a section for the text Query that'll be sent to the API
            Section("Search") {
                TextField("Search recipes…", text: $params.query)
                    .textInputAutocapitalization(.none)
            }
            
            // This section is for tags that the user wants INCLUDED with the search
            Section("Include") {
                ForEach(allowedIncludeTags, id: \.self) { tag in
                    Toggle(tag.capitalized, isOn: Binding(
                        get: { params.includeTags.contains(tag) },
                        set: { newValue in
                            if newValue { params.includeTags.insert(tag) }
                            else { params.includeTags.remove(tag) }
                        }
                    ))
                }
            }
            
            // This section is for tags that the user wants EXCLUDED with the search
            Section("Exclude") {
                ForEach(allowedExcludeTags, id: \.self) { tag in
                    Toggle(tag.capitalized, isOn: Binding(
                        get: { params.excludeTags.contains(tag) },
                        set: { newValue in
                            if newValue { params.excludeTags.insert(tag) }
                            else { params.excludeTags.remove(tag) }
                        }
                    ))
                }
            }
            
            // A button to search
            Section {
                Button {
                    navigateToFeed = true
                } label: {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(params.query.isEmpty)
            }
        }
        .navigationTitle("Search Recipes")
        .navigationDestination(isPresented: $navigateToFeed) {
            FeedView(searchParams: params)
                .environmentObject(feedViewModel)
        }
        // Logout button:
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    // Logic:
                    authViewModel.signOut()
                    currentUser.isLoggedIn = false
                    currentUser.id = nil
                    currentUser.username = ""
                } label: {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
