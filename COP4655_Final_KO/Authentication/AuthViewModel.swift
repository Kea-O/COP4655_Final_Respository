//
//  AuthViewModel.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//

import Foundation
// Import Firebase Auth
import FirebaseAuth
// Import Firebase Firestore
import FirebaseFirestore

@Observable
@MainActor
class AuthViewModel: ObservableObject{
    // Connect to the Firebase Firestore database:
    private let db = Firestore.firestore()
    
    // A property to store the logged in user. User is an object provided by FirebaseAuth framework
    var firebaseUser: FirebaseAuth.User?
    
    // App user data model
    var appUser: AppUser?
    
    // Error message for authentication
    var errorMessage: String?
    
    // Fetch AppUser by ID (for getting usernames in reviews)
    func fetchUserById(userId: String) async throws -> String? {
        let doc = try await db.collection("users").document(userId).getDocument()
        guard doc.exists else { return nil }
        let data = doc.data() ?? [:]
        guard let username = data["name"] as? String else {
            return nil
        }
        return username
    }

    // Documentation for the function used; this is a Firebase-given function for signing up/creating a user  https://firebase.google.com/docs/auth/ios/start#sign_up_new_users
    func signUp(email: String, password: String, username: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Update on main thread since `user` is an observable property
            self.firebaseUser = authResult.user
            
            // Create a dictionary with this data and then save it to Firebase Firestore so we can fetch their username later:
            let newUser = AppUser(
                id: authResult.user.uid,
                name: username,
                email: email
            )
            
            // Send the newUser to be stored in Firestore databases. They'll also be in the authentication, but this way we can assign usernames to them too. Use .document().setData() so that we can use the uid we have from the authResult.
            try db.collection("users").document(authResult.user.uid).setData(from: newUser)
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }

    // Documentation for the function used; this is a Firebase-given function for logging in a user and authenticating that they exist https://firebase.google.com/docs/auth/ios/start#sign_in_existing_users
    func signIn(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            self.firebaseUser = authResult.user
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            firebaseUser = nil
            appUser = nil
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            print("Error signing out: \(error)")
        }
    }
}
