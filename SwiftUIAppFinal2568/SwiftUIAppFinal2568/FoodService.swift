//
//  FoodService.swift
//  SwiftUIAppFinal2568
//
//  Created by Nontakann nn on 13/5/2568 BE.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FoodService {
    static let shared = FoodService()
    private let db = Firestore.firestore()
    
    func addFoodItem(_ foodItem: FoodItem, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "FoodService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        do {
            var foodItemCopy = foodItem
            if foodItemCopy.id == nil {
                foodItemCopy.id = UUID().uuidString
            }
            
            try db.collection("users").document(userId).collection("foodItems").document(foodItemCopy.id).setData(from: foodItemCopy)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func getFoodItems(forDate date: Date, completion: @escaping ([FoodItem]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "FoodService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        db.collection("users").document(userId).collection("foodItems")
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let foodItems = snapshot?.documents.compactMap { document -> FoodItem? in
                    try? document.data(as: FoodItem.self)
                }
                
                completion(foodItems, nil)
            }
    }
}
