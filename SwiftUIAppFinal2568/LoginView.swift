import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var isLoggedIn = false
    @EnvironmentObject  var  userAuth: UserAuth
    @State private var isNavigationBarHidden = true
    @State var loginButtonDisabled = true
    
    func handleLogin() {
        let request = LoginUserRequest(email: email, password: password)
        AuthService.shared.signIn(with: request) { error in
            if error != nil {
                self.passwordError = "Wrong username or password. Please try again."
                return
            }
            
            if AuthService.shared.checkAuth() {
                isLoggedIn = true
                self.userAuth.login()
            } else {
                self.passwordError = "Unable to login. Please try again."
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image("FlexGenius")
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email, prompt: Text("Email").foregroundColor(.gray))
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onChange(of: email, {
                            emailError = invalidEmail(email)
                            passwordError = invalidPassword(password)
                            loginButtonDisabled = emailError != nil || passwordError != nil
                        })
                    
                    if let emailError = emailError {
                        Text(emailError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    SecureField("Password", text: $password, prompt: Text("Password").foregroundColor(.gray))
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onChange(of: password, {
                            emailError = invalidEmail(email)
                            passwordError = invalidPassword(password)
                            loginButtonDisabled = emailError != nil || passwordError != nil
                        })

                    if let passwordError = passwordError {
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: handleLogin) {
                        HStack{
                            Spacer()
                            Text("Login")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(self.loginButtonDisabled ? Color(hex: "#7353BA").opacity(0.3) : Color(hex: "#7353BA"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(loginButtonDisabled)
                    
                    NavigationLink(destination: DrawerLayoutView().navigationBarBackButtonHidden(true), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    .hidden()
                    
                    Text("Don't have an account?")
                        .font(.footnote)
                        .foregroundColor(.white)
                    NavigationLink(destination: RegisterView()){
                        VStack() {
                                HStack{
                                    Spacer()
                                    Text("Register")
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                            .frame(maxWidth: 0.35 * UIScreen.main.bounds.width)
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
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
        } // ปิด NavigationStack
    } // ปิด body
}


struct SignInButton: View {
    var title: String
    
    var body: some View {
        Button(action: {}) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

func invalidEmail(_ value: String) -> String? {
    let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
    if value=="" {
        return "Email Address Required"
    }
    if !predicate.evaluate(with: value) {
        return "Invalid Email Address"
    }
    return nil
}

    func invalidPassword(_ value: String) -> String? {
        if value=="" {
            return "Password Required"
        }
        if value.count < 8 {
            return "Password must be at least 8 characters"
        }
        if containsDigit(value) {
            return "Password must contain at least 1 digit"
        }
        if containsLowerCase(value) {
            return "Password must contain at least 1 lowercase"
        }
        if containsUpperCase(value) {
            return "Password must contain at least 1 uppercase"
        }
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsLowerCase(_ value: String) -> Bool {
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsUpperCase(_ value: String) -> Bool {
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
