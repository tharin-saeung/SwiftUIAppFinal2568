//
//  NavigationBarConfig.swift
//  SwiftUIAppFinal2568
//
//  Created by Tharin Saeung on 13/5/2568 BE.
//

import SwiftUI
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.prefersLargeTitles = false  // use inline titles on very view
        // navigationBar.isHidden = true  // hide the nav bar completely on every view
    }
}
