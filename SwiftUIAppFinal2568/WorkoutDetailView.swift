//
//  WorkoutDetailView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 14/5/2568 BE.
//

import SwiftUI

struct WorkoutDetailView: View {
    var muscleGroup: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var exerciseState: ExerciseState
    @State private var goToTracking = false

    // ดึง exercise ตามกล้ามเนื้อที่เลือก
    var exercises: [WorkoutItem] {
        switch muscleGroup {
        case "Upper body":
            return [
                .init(name: "Pushup", reps: "12–15\n(4 sets)", rest: "1–2 min."),
                .init(name: "Decline pushup", reps: "12–15\n(4 sets)", rest: "1–2 min."),
                .init(name: "Pike pushup", reps: "12–15\n(4 sets)", rest: "1–2 min."),
                .init(name: "Superman", reps: "12–15\n(4 sets)", rest: "1–2 min."),
                .init(name: "Tricep Dips", reps: "12–15\n(4 sets)", rest: "1–2 min.")
            ]
        case "Abs":
            return [
                .init(name: "Crunch", reps: "15–20\n(3 sets)", rest: "1 min."),
                .init(name: "Plank", reps: "60 sec\n(3 sets)", rest: "1 min."),
                .init(name: "Leg Raises", reps: "15 reps\n(3 sets)", rest: "1 min.")
            ]
        case "Chest":
            return [
                .init(name: "Bench Press", reps: "10–12\n(4 sets)", rest: "2 min."),
                .init(name: "Chest Fly", reps: "12–15\n(3 sets)", rest: "1–2 min.")
            ]
        default:
            return [
                .init(name: "Sample Move", reps: "10–12\n(3 sets)", rest: "1–2 min.")
            ]
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                Spacer()
                Text(muscleGroup)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)

            // Table header
            HStack {
                Text("Exercise")
                Spacer()
                Text("Reps & set")
                Spacer()
                Text("Rest per set")
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(Color(hex: "#3E2A63"))
            .cornerRadius(12)

            Divider().background(.white)

            // Exercise rows
            ForEach(exercises, id: \.name) { item in
                HStack {
                    Text(item.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(item.reps)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(item.rest)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .foregroundColor(.white)
                .cornerRadius(12)
            }

            Spacer()

            // CTA button
            Button(action: {
                print("✅ Use this table tapped for \(muscleGroup)")
                exerciseState.selectedExercises = exercises
                goToTracking = true
            }) {
                Text("Use this table")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#7353BA"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            NavigationLink(destination: TrackingView(exercises: exerciseState.selectedExercises),
                           isActive: $goToTracking) {
                EmptyView()
            }
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Model
struct WorkoutItem: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    let name: String
    let reps: String
    let rest: String
    var status: ExerciseStatus? = nil
    var hasStarted: Bool = false
}

class ExerciseState: ObservableObject {
    @Published var selectedExercises: [WorkoutItem] = []
}

// MARK: - Preview
#Preview {
    WorkoutDetailView(muscleGroup: "Upper body").environmentObject(ExerciseState())
}
