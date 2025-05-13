//
//  MainView.swift
//  SwiftUIAppFinal2568
//
//  Created by Tharin Saeung on 14/5/2568 BE.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userAuth: UserAuth
    var body: some View {
        if !userAuth.isLoggedin {
            LoginView()
        } else {
            ContentView()
        }
    }
}
