import SwiftUI

// MARK: - WorkoutStyleSelectionView
struct WorkoutStyleSelectionView: View {
    @Environment(\.dismiss) var dismiss
    var level: String

    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)

                Spacer()

                Text("Workout Style")
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

            // Instruction
            Text("Please select your workout style.")
                .foregroundColor(.white)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            // Workout style options
            HStack(spacing: 20) {
                NavigationLink(destination: WorkoutProgramSelectionView(level: level, style: "Bodyweight")) {
                    WorkoutStyleCard(imageName: "Bodyweight", title: "Bodyweight")
                }

                NavigationLink(destination: WorkoutProgramSelectionView(level: level, style: "Weight training")) {
                    WorkoutStyleCard(imageName: "Weight training", title: "Weight training")
                }
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - WorkoutStyleCard
struct WorkoutStyleCard: View {
    var imageName: String
    var title: String

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(16)

            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), .clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(width: 150, height: 150)
            .cornerRadius(16)

            Text(title)
                .foregroundColor(.white)
                .font(.subheadline)
                .bold()
                .padding(.bottom, 10)
                .shadow(radius: 3)
        }
        .frame(width: 150, height: 150)
    }
}


//// MARK: - Dummy Next View
//struct WorkoutDetailView: View {
//    var muscleGroup: String
//
//    var body: some View {
//        VStack {
//            Text("You selected \(muscleGroup)")
//                .foregroundColor(.white)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
//    }
//}


// MARK: - WorkoutProgramSelectionView
import SwiftUI

struct WorkoutProgramSelectionView: View {
    @Environment(\.dismiss) var dismiss
    var level: String
    var style: String

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)

                Spacer()

                Text(style)
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

            Text("Please choose your program.")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.bottom, 10)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(workoutPrograms, id: \.title) { item in
                    NavigationLink(destination: WorkoutDetailView(muscleGroup: item.title)) {
                        WorkoutProgramCard(imageName: item.image, title: item.title)
                    }
                }
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }

    var workoutPrograms: [(image: String, title: String)] {
        [
            ("Upper body", "Upper body"),
            ("Lower body", "Lower body"),
            ("Chest", "Chest"),
            ("Back", "Back"),
            ("Legs", "Legs"),
            ("Abs", "Abs")
        ]
    }
}

// MARK: - WorkoutProgramCard
struct WorkoutProgramCard: View {
    var imageName: String
    var title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .cornerRadius(10)

            Text(title)
                .foregroundColor(.white)
                .font(.footnote)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview
struct WorkoutProgramSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutProgramSelectionView(level: "BEGINNER", style: "Bodyweight")
    }
}



// MARK: - Preview
struct WorkoutStyleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutStyleSelectionView(level: "BEGINNER")
        }
    }
}
