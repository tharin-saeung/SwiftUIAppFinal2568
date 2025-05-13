//
//  DashboardView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack { // << เพิ่ม NavigationStack
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Header: Profile + Greeting
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)

                        Text("Hello, Name!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()
                    }

                    // Calories Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#3B1D5F"))
                            .frame(height: 120)

                        HStack {
                            VStack {
                                Text("2000")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Remaining")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Calories")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("🍽 Food = 0 kcal")
                                    .foregroundColor(.white)
                                Text("🏃 Workout = 0 kcal")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Section Cards
                    VStack(spacing: 12) {
                        // ✅ เชื่อมไป WorkoutView
                        NavigationLink(destination: WorkoutView()) {
                            DashboardCard(imageName: "workout", title: "Workout")
                        }

                        NavigationLink(destination: FoodView()) {
                            DashboardCard(imageName: "food", title: "Food")
                        }

                        NavigationLink(destination: ShopView()) {
                            DashboardCard(imageName: "shop", title: "Shop")
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        }
    }
}
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
