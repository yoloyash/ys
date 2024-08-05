//
//  BackgroundView.swift
//  demo
//
//  Created by Yash Khurana on 8/4/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Color(red: 250/255, green: 240/255, blue: 240/255, opacity: 1.0)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
