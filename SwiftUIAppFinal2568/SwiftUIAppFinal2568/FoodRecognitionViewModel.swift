//
//  FoodRecognitionViewModel.swift
//  SwiftUIAppFinal2568
//
//  Created by Nontakann nn on 13/5/2568 BE.
//

import SwiftUI
import Vision
import CoreML

class FoodRecognitionViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var isAnalyzing: Bool = false
    @Published var nutritionData: NutritionData?
    @Published var recognitionResults: [RecognitionResult] = []
    
    // ปรับปรุงฐานข้อมูลอาหารให้ตรงกับโมเดล ML ของคุณ
    private let foodDatabase: [String: NutritionData] = [
        "apple": NutritionData(name: "Apple", calories: 95, protein: 0.5, carbs: 25, fat: 0.3, fiber: 4.4, sugar: 19),
        "banana": NutritionData(name: "Banana", calories: 105, protein: 1.3, carbs: 27, fat: 0.4, fiber: 3.1, sugar: 14),
        "burger": NutritionData(name: "Burger", calories: 350, protein: 15, carbs: 40, fat: 17, fiber: 1, sugar: 5),
        "chicken breast": NutritionData(name: "Chicken Breast", calories: 165, protein: 31, carbs: 0, fat: 3.6, fiber: 0, sugar: 0),
        "pasta": NutritionData(name: "Pasta", calories: 200, protein: 7, carbs: 42, fat: 1.2, fiber: 2, sugar: 2),
        "pizza": NutritionData(name: "Pizza", calories: 285, protein: 12, carbs: 36, fat: 10, fiber: 2, sugar: 3.8),
        "rice bowl": NutritionData(name: "Rice Bowl", calories: 300, protein: 6, carbs: 60, fat: 3, fiber: 1.5, sugar: 0.5),
        "salad": NutritionData(name: "Salad", calories: 120, protein: 3, carbs: 12, fat: 7, fiber: 5, sugar: 3)
    ]
    
    // ฟังก์ชันวิเคราะห์ภาพด้วย Core ML
    func analyzeImage() {
        guard let image = capturedImage else { return }
        
        isAnalyzing = true
        recognitionResults = []
        
        // แปลงรูปภาพเป็น CIImage
        guard let ciImage = CIImage(image: image) else {
            isAnalyzing = false
            return
        }
        
        // โหลดโมเดลที่คุณสร้างเอง
        guard let foodModel = try? VNCoreMLModel(for: Food101().model) else {
            print("ไม่สามารถโหลดโมเดลได้")
            isAnalyzing = false
            return
        }
        
        // สร้าง Vision Request
        let request = VNCoreMLRequest(model: foodModel) { [weak self] request, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("เกิดข้อผิดพลาดในการวิเคราะห์: \(error.localizedDescription)")
                    self.isAnalyzing = false
                    return
                }
                
                // ประมวลผลจากโมเดล
                if let results = request.results as? [VNClassificationObservation] {
                    // เก็บผลลัพธ์ทั้งหมด (สูงสุด 8 อันดับ เนื่องจากมีอาหาร 8 ประเภท)
                    let topResults = results.prefix(8)
                    
                    // แปลงผลลัพธ์เป็น RecognitionResult
                    self.recognitionResults = topResults.map { result in
                        RecognitionResult(
                            name: result.identifier,
                            confidence: Double(result.confidence)
                        )
                    }
                    
                    // ใช้ผลลัพธ์อันดับแรก
                    if let topResult = topResults.first {
                        print("ผลลัพธ์: \(topResult.identifier) ความมั่นใจ: \(topResult.confidence)")
                        
                        // ค้นหาข้อมูลโภชนาการจากฐานข้อมูล
                        let foodKey = topResult.identifier.lowercased()
                        if let foodData = self.findFoodData(for: foodKey, confidence: topResult.confidence) {
                            self.nutritionData = foodData
                        } else {
                            // ไม่พบข้อมูลในฐานข้อมูล ให้ใช้ผลลัพธ์จากโมเดลโดยตรง
                            self.nutritionData = NutritionData(
                                name: topResult.identifier.capitalized,
                                calories: 0,
                                protein: 0,
                                carbs: 0,
                                fat: 0,
                                fiber: 0,
                                sugar: 0
                            )
                        }
                    }
                }
                
                self.isAnalyzing = false
            }
        }
        
        // กำหนดค่า request
        request.imageCropAndScaleOption = .centerCrop
        
        // สร้าง handler และประมวลผล
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        
        do {
            try handler.perform([request])
        } catch {
            print("เกิดข้อผิดพลาดในการวิเคราะห์: \(error.localizedDescription)")
            isAnalyzing = false
        }
    }
    
    // ค้นหาอาหารที่ใกล้เคียงที่สุด
    private func findFoodData(for key: String, confidence: Float) -> NutritionData? {
        // ถ้ามีค่าตรงกับคีย์ในฐานข้อมูล
        if let exactMatch = foodDatabase[key] {
            return exactMatch
        }
        
        // ค้นหาคีย์ที่มีคำนี้อยู่
        for (dbKey, foodData) in foodDatabase {
            if key.contains(dbKey) || dbKey.contains(key) {
                // สร้างก็อปปี้และปรับชื่อตามผลลัพธ์จากโมเดล
                var adjustedFoodData = foodData
                if confidence < 0.7 {
                    // ถ้าความมั่นใจต่ำ ให้แสดงว่าอาจไม่แม่นยำ
                    adjustedFoodData.name = "Possible \(foodData.name)"
                }
                return adjustedFoodData
            }
        }
        
        return nil
    }
    
    func addToMeal(mealType: String) {
        guard let nutritionData = nutritionData else { return }
        
        // สร้าง FoodItem จากข้อมูลที่วิเคราะห์ได้
        let foodItem = FoodItem(
            id: UUID().uuidString,
            name: nutritionData.name,
            calories: nutritionData.calories,
            mealType: mealType,
            protein: nutritionData.protein,
            carbs: nutritionData.carbs,
            fat: nutritionData.fat,
            fiber: nutritionData.fiber,
            sugar: nutritionData.sugar
        )
        
        // บันทึกลงฐานข้อมูล
        FoodService.shared.addFoodItem(foodItem) { error in
            if let error = error {
                print("Error saving food item: \(error.localizedDescription)")
            } else {
                print("Added \(nutritionData.name) to \(mealType)")
            }
        }
    }
}

struct NutritionData {
    var name: String
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double
    var sugar: Double
}

struct RecognitionResult: Identifiable {
    let id = UUID()
    let name: String
    let confidence: Double
    
    var formattedConfidence: String {
        return "\(Int(confidence * 100))%"
    }
}

