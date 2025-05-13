//
//  TrackingView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//

import SwiftUI
import FirebaseFirestore
//import FirebaseFirestoreSwift

// MARK: - Data Model
struct ExerciseItem: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var reps: String
    var rest: String
    var status: ExerciseStatus? = nil
    var hasStarted: Bool = false
}

enum ExerciseStatus: String, Codable {
    case done, inProgress, waiting
}

struct TrackingView: View {
    @State private var exercises: [ExerciseItem] = [
        ExerciseItem(name: "Pushup", reps: "12–15\n(4 sets)", rest: "1–2 min."),
        ExerciseItem(name: "Decline pushup", reps: "12–15\n(4 sets)", rest: "1–2 min."),
        ExerciseItem(name: "Pike pushup", reps: "12–15\n(4 sets)", rest: "1–2 min."),
        ExerciseItem(name: "Superman", reps: "12–15\n(4 sets)", rest: "1–2 min."),
        ExerciseItem(name: "Tricep Dips", reps: "12–15\n(4 sets)", rest: "1–2 min.")
    ]

    private var db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 16) {
            headerView

            HStack {
                Text("Workout duration")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("1:07 hours")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)

            HStack {
                Text("Exercise")
                Spacer()
                Text("Reps & set")
                Spacer()
                Text("Rest per set")
            }
            .foregroundColor(.white)
            .font(.caption)
            .padding(.horizontal)

            Divider().background(Color.white)

            ForEach(exercises.indices, id: \.self) { index in
                let exercise = exercises[index]
                Button {
                    startAndToggleStatus(at: index)
                } label: {
                    HStack {
                        Text(exercise.name)
                            .font(.body)
                            .foregroundColor(.white)

                        Spacer()

                        Text(exercise.reps)
                            .font(.caption)
                            .foregroundColor(.white)

                        Spacer()

                        Text(exercise.rest)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(backgroundColor(for: exercise.status))
                    .cornerRadius(10)
                    .overlay(
                        statusOverlay(for: exercise.status, started: exercise.hasStarted)
                    )
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
    }

    // MARK: - Header
    var headerView: some View {
        HStack {
            Image(systemName: "")//person.circle.fill
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(.white)

            Spacer()

            Text("Tracking")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()
        }
        .padding(.horizontal)
    }

    // MARK: - Logic
    func startAndToggleStatus(at index: Int) {
        exercises[index].hasStarted = true

        switch exercises[index].status {
        case nil:
            exercises[index].status = .waiting
        case .waiting:
            exercises[index].status = .inProgress
        case .inProgress:
            exercises[index].status = .done
        case .done:
            exercises[index].status = nil
            exercises[index].hasStarted = false
        }

        saveToFirebase(exercises[index])
    }

    // MARK: - UI Helpers
    @ViewBuilder
    func statusOverlay(for status: ExerciseStatus?, started: Bool) -> some View {
        if started, let status = status {
            switch status {
            case .done:
                Text("Done! ✅")
                    .foregroundColor(.green)
                    .fontWeight(.bold)
                    .offset(y: -40)
            case .inProgress:
                Text("In progress 🔄")
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .offset(y: -40)
            case .waiting:
                Text("Waiting ⏱")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .offset(y: -40)
            }
        }
    }

    func backgroundColor(for status: ExerciseStatus?) -> Color {
        switch status {
        case .done: return Color(hex: "#2C734A")
        case .inProgress: return Color(hex: "#8D732F")
        case .waiting: return Color(hex: "#3E2A63")
        default: return Color(hex: "#1E1336")
        }
    }

    // MARK: - Firebase Save
    func saveToFirebase(_ item: ExerciseItem) {
        do {
            _ = try db.collection("exerciseTracking").document(item.id ?? UUID().uuidString).setData(from: item)
        } catch {
            print("🔥 Failed to save: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TrackingView()
}
