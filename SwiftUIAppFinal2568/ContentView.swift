//
//  ContentView.swift
//  AppFinal2568
//
//  Created by Tharin Saeung on 30/4/2568 BE.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuth
    var body: some View {
        if userAuth.isRegistering {
            RegisterView()
        } else {
            DrawerLayoutView()
        }
    }
}
