//
//  DrawerLayoutView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DrawerLayoutView: View {
    @State private var isDrawerOpen = false
    @State private var selectedGoals: [String] = ["Fat Loss"]
    @State private var isGoalPickerExpanded = false

    let allGoals = ["Fat Loss", "Weight Gain", "Muscle Building"]
    @State public var disableSettings = false

    var body: some View {
        ZStack {
            // Main content
            MainTabView()
                .disabled(isDrawerOpen)
                .blur(radius: isDrawerOpen ? 3 : 0)

            // Drawer menu
            if isDrawerOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isDrawerOpen = false
                            isGoalPickerExpanded = false
                        }
                    }

                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        // 🎯 GOAL Section
                        Button {
                            withAnimation {
                                isGoalPickerExpanded.toggle()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("🎯 Your Goal")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Image(systemName: isGoalPickerExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        }

                        if isGoalPickerExpanded {
                            ForEach(allGoals, id: \.self) { goal in
                                Button(action: {
                                    if selectedGoals.contains(goal) {
                                        selectedGoals.removeAll { $0 == goal }
                                    } else {
                                        selectedGoals.append(goal)
                                    }
                                    updateGoalsInFirebase()
                                }) {
                                    HStack {
                                        Text(goal)
                                            .foregroundColor(.white)
                                        if selectedGoals.contains(goal) {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        } else {
                            // แสดงเป้าหมายปัจจุบันแบบปกติ
                            ForEach(selectedGoals, id: \.self) { goal in
                                Text("• \(goal)")
                                    .foregroundColor(.white)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                    .frame(width: 240)
                    .background(Color(hex: "#3E2A63"))
                    .transition(.move(edge: .leading))

                    Spacer()
                }
            }

            // Hamburger Button
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            isDrawerOpen.toggle()
                            isGoalPickerExpanded = false
                        }
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .disabled(disableSettings)
                            .opacity(disableSettings ? 0 : 1)
                    }
                    .padding()

                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            fetchGoalsFromFirebase()
        }
    }

    private func fetchGoalsFromFirebase() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching goals: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                if let goals = document.data()?["goals"] as? [String] {
                    selectedGoals = goals
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    private func updateGoalsInFirebase() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        userRef.setData(["goals": selectedGoals], merge: true) { error in
            if let error = error {
                print("Error updating goals: \(error.localizedDescription)")
            } else {
                print("Goals successfully updated.")
            }
        }
    }
}

#Preview {
    DrawerLayoutView()
}
