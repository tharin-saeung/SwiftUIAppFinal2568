//
//  Register.swift
//  SwiftUIAppFinal2568
//
//  Created by Poowit Somsak on 12/5/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @State private var name = ""
    @State private var surname = ""
    @State private var nickname = ""
    @State private var dob = ""
    @State private var gender = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var address = ""
    @State private var goToNext = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Enter your personal information")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Group {
                        CustomRoundedField(label: "Name", text: $name)
                        CustomRoundedField(label: "Surname", text: $surname)

                        HStack(spacing: 12) {
                            CustomRoundedField(label: "Nickname", text: $nickname)
                            CustomRoundedField(label: "Date of birth", text: $dob)
                        }

                        CustomRoundedField(label: "Gender", text: $gender)

                        HStack(spacing: 12) {
                            CustomRoundedField(label: "Weight", text: $weight)
                            CustomRoundedField(label: "Height", text: $height)
                        }

                        CustomRoundedField(label: "Address", text: $address)
                    }

                    NavigationLink(destination: GoalSelectionView(), isActive: $goToNext) {
                        EmptyView()
                    }

                    Button("Continue") {
                        goToNext = true
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(14)
                }
                .padding()
            }
            .background(Color(hex: "#2F195F").edgesIgnoringSafeArea(.all))
        }
    }
}

struct CustomRoundedField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.white)
                .font(.subheadline)

            TextField("", text: $text)
                .padding(.horizontal)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
