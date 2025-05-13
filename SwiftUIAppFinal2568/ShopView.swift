//
//  ShopView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) var dismiss
    
    let items = [
        ("Whey protein", "whey"),
        ("Vitamins", "vitamin"),
        ("Pre-workout", "preworkout"),
        ("Amino acids", "amino"),
        ("Equipment & Stuff", "equipment"),
        ("Fitness gadget", "watch")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Shop")
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
            
            // Grid
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(items, id: \.0) { item in
                            NavigationLink(destination: ProductDetailView(productName: item.0, imageName: item.1)) {
                                VStack {
                                    Image(item.1)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 80)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)

                                    Text(item.0)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                .navigationBarBackButtonHidden(true)
                .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
            }

            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}
