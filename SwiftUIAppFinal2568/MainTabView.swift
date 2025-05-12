//
//  MainTabView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

// DashboardWithTabBar.swift
// โค้ด SwiftUI แบบครบทั้ง Dashboard + Tab Bar + NavigationLink

import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView2()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }

            Text("Diary Page")
                .tabItem {
                    Image(systemName: "book")
                    Text("Diary")
                }

            Text("Tracking Page")
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Tracking")
                }
        }
        .accentColor(.white)
    }
}

// MARK: - DashboardView
struct DashboardView2: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Header: Greeting + Avatar
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

                    // Calories Summary Card
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
                                Text("\u{1F37D} Food = 0 kcal")
                                    .foregroundColor(.white)
                                Text("\u{1F3C3} Workout = 0 kcal")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Section Cards
                    VStack(spacing: 12) {
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

// MARK: - DashboardCard
struct DashboardCard: View {
    var imageName: String
    var title: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 110)
                .cornerRadius(12)
                .clipped()

            Rectangle()
                .foregroundColor(.black.opacity(0.3))
                .cornerRadius(12)

            Text(title)
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.bold)
        }
    }
}



// MARK: - Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
