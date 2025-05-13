//
//  WorkoutView.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI



struct WorkoutView: View {
    @Environment(\.dismiss) var dismiss  // ✅ อยู่ตรงนี้ถูกแล้ว
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                Spacer()
                Text("Workout")
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

            Text("Please select\nyour level.")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)

            // Background Card Container
            VStack(spacing: 16) {
                WorkoutLevelButton(title: "BEGINNER", color: Color(hex: "#7A9E5F"))
                WorkoutLevelButton(title: "INTERMEDIATE", color: Color(hex: "#A9845C"))
                WorkoutLevelButton(title: "ADVANCED", color: Color(hex: "#8E4D4A"))
            }

            .padding()
            .background(Color(hex: "#3E2A63"))
            .cornerRadius(20)

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true) // ✅ ซ่อน back ด้านซ้าย
    }
}

struct WorkoutLevelButton: View {
    var title: String
    var color: Color

    var body: some View {
        Button(action: {
            print("Tapped \(title)")
        }) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color)
                .cornerRadius(16)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
