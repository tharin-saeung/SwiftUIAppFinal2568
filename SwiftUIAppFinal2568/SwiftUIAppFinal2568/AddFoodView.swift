//
//  AddFoodView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//

import SwiftUI

struct AddFoodView: View {
    let mealType: String
    var onSave: (FoodItem) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var foodText = ""
    @State private var caloriesText = ""
    @State private var showingFoodRecognition = false
    
    // ปรับปรุงรายการอาหารให้ตรงกับโมเดล ML ของคุณ
    let foodCalories: [String: Int] = [
        "apple": 95,
        "banana": 105,
        "burger": 350,
        "chicken breast": 165,
        "pasta": 200,
        "pizza": 285,
        "rice bowl": 300,
        "salad": 120
    ]
    
    var calculatedCalories: Int {
        if let calories = Int(caloriesText) {
            return calories
        }
        return foodCalories[foodText.lowercased()] ?? 0
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Add food for \(mealType)")
                    .font(.headline)
                    .foregroundColor(.white)

                TextField("Enter food name", text: $foodText)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)

                TextField("Calories", text: $caloriesText)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .keyboardType(.numberPad)

                if !foodText.isEmpty {
                    Text("Estimated Calories: \(calculatedCalories) kcal")
                        .foregroundColor(.white.opacity(0.7))
                }

                Button("Save") {
                    let calories = calculatedCalories
                    print("✅ Saved: \(foodText) - \(calories) kcal")
                    
                    // สร้าง FoodItem ใหม่
                    let item = FoodItem(
                        id: UUID().uuidString,
                        name: foodText,
                        calories: calories,
                        mealType: mealType
                    )
                    
                    // ส่งข้อมูลกลับไปยัง FoodView
                    onSave(item)
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#7353BA"))
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(foodText.isEmpty)
                
                // Add divider and camera button
                Divider()
                    .background(Color.white.opacity(0.3))
                    .padding(.vertical)
                
                // แก้ไขปุ่มนี้ให้ส่งข้อมูลกลับไปยัง FoodView เพื่อเปิดกล้อง
                Button(action: {
                    // ส่งข้อมูลกลับไปยัง FoodView ว่าต้องการเปิดกล้อง
                    NotificationCenter.default.post(
                        name: Notification.Name("OpenFoodRecognition"),
                        object: nil,
                        userInfo: ["mealType": mealType]
                    )
                    dismiss() // ปิดหน้า AddFoodView
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Recognize Food from Photo")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#5D3E8E"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
            .navigationTitle("Add Food")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.white))
        }
    }
}
