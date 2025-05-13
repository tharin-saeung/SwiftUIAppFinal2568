//
//  FoodView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI

struct FoodView: View {
    @Environment(\.dismiss) var dismiss  // ✅
    @State private var showingAddFood = false
    @State private var selectedMealType = ""

    @State private var meals: [String: [FoodItem]] = [
        "Breakfast": [],
        "Lunch": [],
        "Dinner": [],
        "Snacks": []
    ]

    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"]

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                Spacer()
                Text("Food")
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

            // Meal blocks (Grid of meal cards)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(mealTypes, id: \.self) { meal in
                    VStack(alignment: .leading, spacing: 8) {
                        // Title
                        Text(meal)
                            .font(.headline)
                            .foregroundColor(.white)

                        // Food items
                        ForEach(meals[meal] ?? []) { item in
                            Text("• \(item.name) - \(item.calories) kcal")
                                .font(.caption)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        // Add button
                        Button(action: {
                            selectedMealType = meal
                            showingAddFood = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add")
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#5D3E8E"))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
                    .background(Color(hex: "#3E2A63"))
                    .cornerRadius(12)
                }
            }

            // Other cards (Placeholder)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#3E2A63"))
                .frame(height: 60)
                .overlay(Text("Meals table").foregroundColor(.white))

            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#3E2A63"))
                .frame(height: 80)
                .overlay(Text("Meals preparation").foregroundColor(.white))

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true) // ✅
        .sheet(isPresented: $showingAddFood) {
            AddFoodView(
                mealType: selectedMealType,
                onSave: { newItem in
                    meals[selectedMealType, default: []].append(newItem)
                }
            )
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FoodView()
        }
    }
}

