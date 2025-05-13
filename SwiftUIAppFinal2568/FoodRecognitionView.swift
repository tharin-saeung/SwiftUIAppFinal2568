//
//  FoodRecognitionView.swift
//  SwiftUIAppFinal2568
//
//  Created by Nontakann nn on 13/5/2568 BE.
//

import SwiftUI
import AVFoundation

struct FoodRecognitionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = FoodRecognitionViewModel()
    @State private var showingCamera = false
    @State private var showingImagePicker = false
    @State private var selectedMealType = "Breakfast"
    @State private var showDebugInfo = false
    
    // เพิ่ม callback function เพื่อส่งข้อมูลกลับไปยัง FoodView
    var onFoodAdded: ((FoodItem) -> Void)?
    
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
                
                Text("Food Recognition")
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
            
            // Debug toggle
            Toggle("Show Debug Info", isOn: $showDebugInfo)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // Main content
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.capturedImage == nil {
                        // Camera/Upload buttons
                        VStack(spacing: 16) {
                            Button(action: {
                                showingCamera = true
                            }) {
                                HStack {
                                    Image(systemName: "camera.fill")
                                        .font(.title2)
                                    Text("Take Photo")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#5D3E8E"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "photo.fill")
                                        .font(.title2)
                                    Text("Upload Photo")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#5D3E8E"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Text("Take a photo of your food to get nutritional information")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.top)
                        }
                        .padding()
                        .background(Color(hex: "#3E2A63"))
                        .cornerRadius(16)
                        
                    } else {
                        // Image preview and analysis
                        VStack(spacing: 16) {
                            ZStack(alignment: .topTrailing) {
                                if let uiImage = viewModel.capturedImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    viewModel.capturedImage = nil
                                    viewModel.nutritionData = nil
                                    viewModel.isAnalyzing = false
                                    viewModel.recognitionResults = []
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .padding(8)
                                }
                            }
                            
                            if viewModel.isAnalyzing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                                    .padding()
                                
                                Text("Analyzing your food...")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            } else if let nutritionData = viewModel.nutritionData {
                                // Nutrition results
                                Text(nutritionData.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                // แสดงผลลัพธ์ทั้งหมด
                                if showDebugInfo && !viewModel.recognitionResults.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Recognition Results:")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        ForEach(viewModel.recognitionResults) { result in
                                            HStack {
                                                Text(result.name.capitalized)
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Text(result.formattedConfidence)
                                                    .foregroundColor(.white.opacity(0.7))
                                            }
                                            .padding(.vertical, 4)
                                        }
                                    }
                                    .padding()
                                    .background(Color(hex: "#2F195F"))
                                    .cornerRadius(10)
                                }
                                
                                // Nutrition grid
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    NutrientCard(label: "Calories", value: "\(nutritionData.calories) kcal")
                                    NutrientCard(label: "Protein", value: "\(String(format: "%.1f", nutritionData.protein))g")
                                    NutrientCard(label: "Carbs", value: "\(String(format: "%.1f", nutritionData.carbs))g")
                                    NutrientCard(label: "Fat", value: "\(String(format: "%.1f", nutritionData.fat))g")
                                    NutrientCard(label: "Fiber", value: "\(String(format: "%.1f", nutritionData.fiber))g")
                                    NutrientCard(label: "Sugar", value: "\(String(format: "%.1f", nutritionData.sugar))g")
                                }
                                
                                // Add to meal
                                VStack(spacing: 12) {
                                    Text("Add to meal")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Picker("Meal", selection: $selectedMealType) {
                                        ForEach(mealTypes, id: \.self) { meal in
                                            Text(meal).tag(meal)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.horizontal)
                                    
                                    Button(action: {
                                        // สร้าง FoodItem จากข้อมูลที่วิเคราะห์ได้
                                        let foodItem = FoodItem(
                                            id: UUID().uuidString,
                                            name: nutritionData.name,
                                            calories: nutritionData.calories,
                                            mealType: selectedMealType,
                                            protein: nutritionData.protein,
                                            carbs: nutritionData.carbs,
                                            fat: nutritionData.fat,
                                            fiber: nutritionData.fiber,
                                            sugar: nutritionData.sugar
                                        )
                                        
                                        // เรียกใช้ callback เพื่อส่งข้อมูลกลับไปยัง FoodView
                                        onFoodAdded?(foodItem)
                                        
                                        // บันทึกลงฐานข้อมูล (ถ้ามี)
                                        viewModel.addToMeal(mealType: selectedMealType)
                                        
                                        // แสดงการแจ้งเตือนว่าเพิ่มสำเร็จแล้ว
                                        let feedbackGenerator = UINotificationFeedbackGenerator()
                                        feedbackGenerator.notificationOccurred(.success)
                                        
                                        // รีเซ็ตข้อมูล
                                        viewModel.capturedImage = nil
                                        viewModel.nutritionData = nil
                                        viewModel.recognitionResults = []
                                        
                                        // ปิดหน้าต่าง
                                        dismiss()
                                    }) {
                                        Text("Add to \(selectedMealType)")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(hex: "#7353BA"))
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(.top, 8)
                            } else {
                                Button(action: {
                                    viewModel.analyzeImage()
                                }) {
                                    Text("Analyze Food")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(hex: "#7353BA"))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding()
                        .background(Color(hex: "#3E2A63"))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingCamera) {
            CameraView(image: $viewModel.capturedImage)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.capturedImage)
        }
    }
}

struct NutrientCard: View {
    var label: String
    var value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(hex: "#2F195F"))
        .cornerRadius(10)
    }
}
