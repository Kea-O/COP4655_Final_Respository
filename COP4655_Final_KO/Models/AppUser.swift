//
//  AppUser.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import Foundation
import FirebaseFirestore
import SwiftUI

// Have a user class that's an observableObject. It can be accessed by the other views, and contains the user's info:
class CurrentUser: ObservableObject {
    @DocumentID var id: String?
    @Published var username: String = ""
    @Published var isLoggedIn: Bool = false
}

// A variable to store the current user:
struct AppUser: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
}
