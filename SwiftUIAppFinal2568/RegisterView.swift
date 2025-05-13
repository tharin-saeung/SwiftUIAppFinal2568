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
    
    @State private var showError = false
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var verifyPasswordError: String?
    @State private var firstNameError: String?
    @State private var lastNameError: String?
    
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
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    if let emailError = emailError {
                        Text(emailError).foregroundColor(.red).font(.caption)
                    }

                    CustomSecureField(label: "Password", text: $password)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    if let passwordError = passwordError {
                        Text(passwordError).foregroundColor(.red).font(.caption)
                    }

                    CustomSecureField(label: "Verify Password", text: $verifyPassword)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    if let verifyPasswordError = verifyPasswordError {
                        Text(verifyPasswordError).foregroundColor(.red).font(.caption)
                    }

                    CustomRoundedField(label: "First Name", text: $firstName)
                        .keyboardType(.alphabet)
                        .autocorrectionDisabled()
                    if let firstNameError = firstNameError {
                        Text(firstNameError).foregroundColor(.red).font(.caption)
                    }

                    CustomRoundedField(label: "Last Name", text: $lastName)
                        .keyboardType(.alphabet)
                        .autocorrectionDisabled()
                    if let lastNameError = lastNameError {
                        Text(lastNameError).foregroundColor(.red).font(.caption)
                    }
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
        .onAppear() {
            self.userAuth.toggleRegistering()
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
                    self.lastNameError = error.localizedDescription
                    self.showError = true
                }
                return
            }

            if wasRegistered {
                self.login() // login after register
                self.isRegistered = true
                self.userAuth.toggleRegistering()
            } else {
                DispatchQueue.main.async {
                    self.lastNameError = "Registration failed. Please try again."
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
                    self.lastNameError = "Login failed: \(error.localizedDescription)"
                    self.showError = true
                    return
                }

                if AuthService.shared.checkAuth() {
                    self.userAuth.login()
                } else {
                    self.lastNameError = "Unable to login. Please try again."
                    self.showError = true
                }
            }
        }
    }


    private func validateForm() -> Bool {
        // Reset all errors
        emailError = nil
        passwordError = nil
        verifyPasswordError = nil
        firstNameError = nil
        lastNameError = nil
        showError = false

        var isValid = true

        if let error = invalidEmail(email) {
            emailError = error
            isValid = false
        }

        if let error = invalidPassword(password) {
            passwordError = error
            isValid = false
        }

        if verifyPassword.isEmpty {
            verifyPasswordError = "Please verify your password."
            isValid = false
        } else if password != verifyPassword {
            verifyPasswordError = "Passwords do not match."
            isValid = false
        }

        if let error = invalidFirstName(firstName) {
            firstNameError = error
            isValid = false
        }

        if let error = invalidLastName(lastName) {
            lastNameError = error
            isValid = false
        }

        return isValid
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

private func invalidFirstName(_ value: String) -> String? {
    if value.isEmpty {
        return "First name is required."
    }
    if !containsLowerCase(value) {
        return "First name must contain at least 1 lowercase"
    }
    if !containsUpperCase(value) {
        return "First name must contain at least 1 uppercase"
    }
    if value.count < 3 {
        return "First name must contain at least 3 characters"
    }
    return nil
}

private func invalidLastName(_ value: String) -> String? {
    if value.isEmpty {
        return "Last name is required."
    }
    if !containsUpperCase(value) {
        return "Last name must contain at least 1 uppercase"
    }
    return nil
}
