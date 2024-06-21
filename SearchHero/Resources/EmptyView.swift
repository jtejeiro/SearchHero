//
//  EmptyView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 14/6/24.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Spacer()
            Image(.logo)
                .resizable()
                .frame(height: 150)
            Spacer()
        }
    }
}

#Preview {
    EmptyView()
}
