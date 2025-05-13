//
//  DrawerLayoutView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//

import SwiftUI

struct DrawerLayoutView: View {
    @State private var isDrawerOpen = false
    @State private var selectedGoals: [String] = ["Fat Loss"]
    @State private var isGoalPickerExpanded = false

    let allGoals = ["Fat Loss", "Weight Gain", "Muscle Building"]

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
                                    selectedGoals = [goal] // เปลี่ยนเป้าหมายใหม่
                                    isGoalPickerExpanded = false
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
                    }
                    .padding()

                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    DrawerLayoutView()
}
