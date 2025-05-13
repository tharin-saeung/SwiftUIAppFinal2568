//
//  Register.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var verifyPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isRegistered = false
    @State private var isLoggedIn = false
    @EnvironmentObject  var  userAuth: UserAuth
    @State private var isNavigationBarHidden = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                Group {
                    CustomRoundedField(label: "Email", text: $email)
                    CustomSecureField(label: "Password", text: $password)
                    CustomSecureField(label: "Verify Password", text: $verifyPassword)
                    CustomRoundedField(label: "First Name", text: $firstName)
                    CustomRoundedField(label: "Last Name", text: $lastName)
                }

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                    Spacer()
                    Button("Register") {
                        register()
                    }
                    .buttonStyle(FilledButtonStyle())
                    .navigationDestination(isPresented: $isRegistered) {
                        GoalSelectionView()
                    }
                    Spacer()
            }
            .padding()
            .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
            .navigationBarHidden(self.isNavigationBarHidden)
            .navigationBarTitle("")
            .onAppear {
                self.isNavigationBarHidden = true
            }
        }
    }

    private func register() {
        guard validateForm() else { return }

        let request = RegisterUserRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )

        AuthService.shared.registerUser(with: request) { wasRegistered, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
                return
            }

            if wasRegistered {
                self.login() // login after register
                self.isRegistered = true
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Registration failed. Please try again."
                    self.showError = true
                }
            }
        }
    }

    private func login() {
        let request = LoginUserRequest(email: email, password: password)
        
        AuthService.shared.signIn(with: request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    self.showError = true
                    return
                }

                if AuthService.shared.checkAuth() {
                    self.userAuth.login()
                } else {
                    self.errorMessage = "Unable to login. Please try again."
                    self.showError = true
                }
            }
        }
    }


    private func validateForm() -> Bool {
        if email.isEmpty || password.isEmpty || verifyPassword.isEmpty || firstName.isEmpty || lastName.isEmpty {
            errorMessage = "All fields are required."
            showError = true
            return false
        }
        if password != verifyPassword {
            errorMessage = "Passwords do not match."
            showError = true
            return false
        }
        return true
    }
}

struct CustomRoundedField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.white)
                .font(.subheadline)

            TextField("", text: $text)
                .padding(.horizontal)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }
}

struct CustomSecureField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.white)
                .font(.subheadline)

            SecureField("", text: $text)
                .padding(.horizontal)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(14)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
