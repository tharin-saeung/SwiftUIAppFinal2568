//
//  DiaryView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//

import SwiftUI

struct DiaryView: View {
    // ตัวอย่างค่าทดลอง (สามารถผูกกับจริงภายหลัง)
    @State private var goal = 2000
    @State private var food = 0
    @State private var exercise = 0

    var remaining: Int {
        goal - food + exercise
    }

    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)

                Spacer()

                Text("Diary")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

            }
            .padding(.horizontal)

            // Calories Summary
            VStack(alignment: .center, spacing: 8) {
                Text("Calories remaining")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    VStack {
                        Text("\(goal)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(.white)
                    }

                    Text("-").foregroundColor(.white)

                    VStack {
                        Text("\(food)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Text("Food")
                            .font(.caption)
                            .foregroundColor(.white)
                    }

                    Text("+").foregroundColor(.white)

                    VStack {
                        Text("\(exercise)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Text("Exercise")
                            .font(.caption)
                            .foregroundColor(.white)
                    }

                    Text("=").foregroundColor(.white)

                    VStack {
                        Text("\(remaining)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Text("Remaining")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(Color(hex: "#3E2A63"))
            .cornerRadius(16)

            // Grid: Meals + Water + Exercise
            LazyVGrid(columns: gridItems, spacing: 16) {
                ForEach(["Breakfast", "Lunch", "Dinner", "Snacks", "Water", "Exercise"], id: \.self) { title in
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)

                        if title == "Exercise" {
                            VStack {
                                Text("+")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("or")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                                Label("Sync", systemImage: "arrow.clockwise")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        } else {
                            Text("+")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .background(Color(hex: "#3E2A63"))
                    .cornerRadius(12)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    DiaryView()
}
