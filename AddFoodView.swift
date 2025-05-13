//
//  AddFoodView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//

import SwiftUI

struct AddFoodView: View {
    let mealType: String
    var onSave: (FoodItem) -> Void  // ✅ สำคัญที่สุด

    @Environment(\.dismiss) var dismiss

    @State private var foodText = ""
    
    // แคลอรี Lookup
    let foodCalories: [String: Int] = [
        "boiled egg": 70,
        "rice": 200,
        "banana": 90,
        "apple": 95,
        "grilled chicken": 165,
        "bread": 120,
        "milk": 130,
        "yogurt": 110,
        "salmon": 206
    ]
    
    // คำนวณแคลจากคำที่พิมพ์
    var calculatedCalories: Int {
        foodCalories[foodText.lowercased()] ?? 0
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Add food for \(mealType)")
                    .font(.headline)

                // ช่องกรอกชื่ออาหาร
                TextField("Enter food name", text: $foodText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // แสดงแคลอรีที่ระบบคำนวณให้
                if !foodText.isEmpty {
                    Text("Estimated Calories: \(calculatedCalories) kcal")
                        .foregroundColor(.gray)
                }

                // ปุ่ม Save
                Button("Save") {
                    print("✅ Saved: \(foodText) - \(calculatedCalories) kcal")
                    let item = FoodItem(name: foodText, calories: calculatedCalories)
                    onSave(item)
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
            .navigationTitle("Add Food")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}
