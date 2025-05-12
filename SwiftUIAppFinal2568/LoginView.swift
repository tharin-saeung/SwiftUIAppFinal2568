import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    
    // จุดเชื่อม backend
        func handleLogin() {
            // ต่อ API หรือ Firebase Auth ที่นี่
            print("Logging in with \(username) / \(password)")
        }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("FLEX GENIUS")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            VStack(spacing: 16) {
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                Button("Login") {
                    // Login logic here
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#7353BA"))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Text("Don't have an account? Create!")
                .font(.footnote)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
    }
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
