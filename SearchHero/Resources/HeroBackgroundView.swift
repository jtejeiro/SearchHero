//
//  HeroBackgroundView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 14/6/24.
//

import SwiftUI

struct HeroBackgroundView: View {
    var body: some View {
       
        ZStack {
            Color.mavelGray
                .edgesIgnoringSafeArea(.vertical)
                .overlay {
                    Image(.space)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.2)
                        .edgesIgnoringSafeArea(.vertical)
                }
        }

        
    }
}

#Preview {
    HeroBackgroundView()
}
