import SwiftUI

struct WorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedLevel: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.white)
                    Spacer()
                    Text("Workout")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)

                Text("Please select\nyour level.")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                // Level buttons
                VStack(spacing: 16) {
                    ForEach(["BEGINNER", "INTERMEDIATE", "ADVANCED"], id: \.self) { level in
                        NavigationLink(
                            destination: WorkoutStyleSelectionView(level: level),
                            tag: level,
                            selection: $selectedLevel
                        ) {
                            Text(level)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(buttonColor(for: level))
                                .cornerRadius(16)
                        }
                    }
                }
                .padding()
                .background(Color(hex: "#3E2A63"))
                .cornerRadius(20)

                Spacer()
            }
            .padding()
            .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
        }
    }

    func buttonColor(for level: String) -> Color {
        switch level {
        case "BEGINNER": return Color(hex: "#7A9E5F")
        case "INTERMEDIATE": return Color(hex: "#A9845C")
        case "ADVANCED": return Color(hex: "#8E4D4A")
        default: return .gray
        }
    }
}

// MARK: - Preview
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
