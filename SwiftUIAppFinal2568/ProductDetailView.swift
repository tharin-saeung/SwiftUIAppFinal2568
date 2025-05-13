//
//  ProductDetailView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 13/5/2568 BE.
//

import SwiftUI

struct ProductDetailView: View {
    let productName: String
    let imageName: String

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // รูปภาพสินค้า
                Image(imageName)
                    .resizable()
                    
                    .frame(height: 240)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 6)
                    .padding(.top, 32)

                // ชื่อสินค้า
                Text(productName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                // รายละเอียดสินค้า
                Text("รายละเอียดสินค้า \(productName) จะมาใส่ทีหลัง...")
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer(minLength: 40)
            }
            .padding(.horizontal)
        }
        .background(
            LinearGradient(colors: [Color(hex: "#2F195F"), Color(hex: "#1E1336")],
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        // 🛒 ปุ่ม Add to Cart
                        Button(action: {
                            print("✅ Added \(productName) to cart")
                        }) {
                            Text("Add to Cart")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#b89ce6"))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProductDetailView(productName: "Whey Protein", imageName: "whey")
}
