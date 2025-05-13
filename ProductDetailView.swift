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
        VStack(spacing: 16) {
            Image(imageName)
                .resizable()
//                .scaledToFit()
                .frame(height: 200)
                .padding()

            Text(productName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("รายละเอียดสินค้า \(productName) จะมาใส่ทีหลัง...")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview
{
    ProductDetailView(productName: "Test", imageName: "Test.png")
    
}
