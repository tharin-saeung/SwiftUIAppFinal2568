//
//  FoodView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI

struct FoodView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingAddFood = false
    @State private var showingFoodRecognition = false
    @State private var selectedMealType = ""

    // เพิ่ม State เพื่อเก็บข้อมูลอาหาร
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
                
                // Add camera button for food recognition
                Button(action: {
                    showingFoodRecognition = true
                }) {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .frame(width: 24, height: 20)
                        .foregroundColor(.white)
                        .padding(.trailing, 8)
                }
                
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
                            HStack {
                                Text("• \(item.name)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(item.calories) kcal")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
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

            // Total calories
            HStack {
                Text("Total Calories:")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(totalCalories) kcal")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color(hex: "#3E2A63"))
            .cornerRadius(12)

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingAddFood) {
            AddFoodView(
                mealType: selectedMealType,
                onSave: { newItem in
                    addFoodItem(newItem)
                }
            )
        }
        // แก้ไขส่วนนี้เพื่อส่ง callback ไปยัง FoodRecognitionView
        .sheet(isPresented: $showingFoodRecognition) {
            FoodRecognitionView(onFoodAdded: { newItem in
                addFoodItem(newItem)
            })
        }
        // เพิ่มการรับ notification เมื่อต้องการเปิดกล้อง
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("OpenFoodRecognition"))) { notification in
            if let mealType = notification.userInfo?["mealType"] as? String {
                selectedMealType = mealType
            }
            // เปิดกล้องหลังจากปิด AddFoodView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingFoodRecognition = true
            }
        }
    }
    
    // คำนวณแคลอรี่ทั้งหมด
    private var totalCalories: Int {
        var total = 0
        for (_, items) in meals {
            total += items.reduce(0) { $0 + $1.calories }
        }
        return total
    }
    
    // เพิ่มฟังก์ชันสำหรับเพิ่มอาหาร
    private func addFoodItem(_ item: FoodItem) {
        // ตรวจสอบว่ามี mealType หรือไม่
        if !item.mealType.isEmpty {
            // เพิ่มอาหารลงในมื้อที่ระบุ
            meals[item.mealType, default: []].append(item)
            
            // แสดงการแจ้งเตือนว่าเพิ่มสำเร็จแล้ว
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
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


