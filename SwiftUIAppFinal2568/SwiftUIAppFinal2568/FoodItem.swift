//
//  FoodItem.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//
import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

struct FoodItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var calories: Int
    var mealType: String = ""
    var date: Date = Date()
    
    // Optional detailed nutrition info
    var protein: Double?
    var carbs: Double?
    var fat: Double?
    var fiber: Double?
    var sugar: Double?
}


