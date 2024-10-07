//
//  HeroBackgroundView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 14/6/24.
//

import SwiftUI

struct HeroBackgroundView: View {
    var gradient = Gradient(colors: [Color.mavelGray,Color.blue,Color.purple,Color.blue,Color.black])
    
    var body: some View {
       
        ZStack {
            LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.vertical)
                .overlay {
                    Image(.space)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.5)
                        .edgesIgnoringSafeArea(.vertical)
                }
        }

        
    }
}

#Preview {
    HeroBackgroundView()
}
