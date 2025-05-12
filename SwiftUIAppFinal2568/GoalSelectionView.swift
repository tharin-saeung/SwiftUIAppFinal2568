//
//  GoalSelectionView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import Foundation
import SwiftUI

struct GoalSelectionView: View {
    @State private var selectedGoals: Set<String> = []
    let goals = ["Fat Loss", "Weight Gain", "Muscle Building"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Choose Your Goals")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                ForEach(goals, id: \.self) { goal in
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 100, height: 60)
                            .overlay(Text(goal.prefix(1)).font(.largeTitle).foregroundColor(.white))
                        
                        Text(goal)
                            .foregroundColor(.white)
                            .font(.headline)

                        Spacer()

                        Button(action: {
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        }) {
                            Image(systemName: selectedGoals.contains(goal) ? "checkmark.square.fill" : "square")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                }

                Button("Continue") {
                    // ยังไม่เชื่อม backend
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(.purple)
                .cornerRadius(10)
            }
            .padding()
        }
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
    }
}
