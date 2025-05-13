//
//  GoalSelectionView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI

struct Goal: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct GoalSelectionView: View {
    @State private var selectedGoals: Set<Goal> = []
    
    let goals: [Goal] = [
        Goal(title: "Fat Loss", imageName: "fatloss"),
        Goal(title: "Weight Gain", imageName: "weightgain"),
        Goal(title: "Just exercise For Health", imageName: "health")
    ]
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Choose Your Goals")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    ForEach(goals) { goal in
                        HStack {
                            ZStack {
                                Image(goal.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 120)
                                    .clipped()
                                    .cornerRadius(12)
                                
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.3))
                                    .cornerRadius(12)
                                
                                Text(goal.title)
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button(action: {
                                if selectedGoals.contains(goal) {
                                    selectedGoals.remove(goal)
                                } else {
                                    selectedGoals.insert(goal)
                                }
                            }) {
                                Image(systemName: selectedGoals.contains(goal) ? "checkmark.square.fill" : "square")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 10)
                        }
                        .frame(height: 120)
                        .padding(.horizontal)
                    }
                    
                    Button("Continue") {
                        print(selectedGoals.map { $0.title })
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.purple)
                    .cornerRadius(14)
                    .padding(.horizontal)
                    .padding(.top)
                }
                .padding(.bottom)
            }
            .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        }
}

struct GoalSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GoalSelectionView()
    }
}

