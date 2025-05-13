//
//  UserAuth.swift
//  SwiftUIAppFinal2568
//
//  Created by Tharin Saeung on 13/5/2568 BE.
//

import UIKit
import Combine

class UserAuth: ObservableObject {
    @Published var isLoggedin:Bool = false
    
    func login() {
        self.isLoggedin = true
    }
}
