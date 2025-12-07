//
//  LoginView.swift
//  COP4655_Final_KO
//
//  Created by Keagan O'Leary on 12/8/25.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var currentUser: CurrentUser
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 32) {
            
            // App Title
            Text("Spice of Life")
                .font(.system(size: 34, weight: .bold))
                .padding(.top, 40)
            
            // Input Card
            VStack(spacing: 20) {
                // Email
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                }
                
                // Password
                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    SecureField("", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(.horizontal, 32)
            
            // Login Button
            Button {
                Task { await login() }
            } label: {
                HStack {
                    if currentUser.isLoggedIn {
                        ProgressView()
                    } else {
                        Text("Login")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .disabled(currentUser.isLoggedIn || email.isEmpty || password.isEmpty)
            .animation(.easeInOut, value: currentUser.isLoggedIn)
            
            // Sign Up
            Button {
                showSignUp = true
            } label: {
                Text("Create a new account")
                    .font(.callout)
                    .foregroundStyle(.blue)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
                .environmentObject(authViewModel)
                .environmentObject(currentUser)
        }
        .alert("Login Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func login() async {
        do {
            try await authViewModel.signIn(
                email: email.trimmingCharacters(in: .whitespaces),
                password: password
            )

            guard let uid = authViewModel.firebaseUser?.uid else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing UID"])
            }

            currentUser.id = uid

            // IMPORTANT: Don't use try?
            let username = try await authViewModel.fetchUserById(userId: uid) ?? ""
            currentUser.username = username

            currentUser.isLoggedIn = true

        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
            currentUser.isLoggedIn = false
        }
    }
}

// A sign up view that pops up as a sheet in LoginView:
struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var currentUser: CurrentUser
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSigningUp = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                
                // Title
                VStack(spacing: 4) {
                    Text("Create Account")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 20)
                    
                    Text("Join Textbook Trader")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // Input fields
                VStack(spacing: 20) {
                    
                    // Username
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Username")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        SecureField("", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Confirm Password")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        SecureField("", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .padding(.horizontal, 32)
                
                // Sign Up Button
                Button {
                    Task { await signUp() }
                } label: {
                    HStack {
                        if isSigningUp {
                            ProgressView()
                        } else {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .disabled(isSigningUp || !isFormValid)
                .animation(.easeInOut, value: isSigningUp)
                
                Spacer()
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isSigningUp)
                }
            }
            .alert("Sign Up Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // VALIDATION
    private var isFormValid: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }
    
    // SIGN UP FUNCTION
    private func signUp() async {
        print("SignUp tapped") 
        guard isFormValid else {
            errorMessage = "Please fill out all fields correctly. Password must be at least 6 characters."
            showErrorAlert = true
            return
        }
        
        isSigningUp = true
        defer { isSigningUp = false }
        
        do {
            try await authViewModel.signUp(
                email: email.trimmingCharacters(in: .whitespaces),
                password: password,
                username: username.trimmingCharacters(in: .whitespaces)
            )
            if let uid = authViewModel.firebaseUser?.uid {
                    currentUser.id = uid
            }
            currentUser.username = username.trimmingCharacters(in: .whitespaces)
            currentUser.isLoggedIn = true
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}

