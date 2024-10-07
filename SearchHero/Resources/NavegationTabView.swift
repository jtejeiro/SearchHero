//
//  NavegationTabView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 26/6/24.
//

import SwiftUI

struct NavegationTabView: View {
    var body: some View {
        TabView{
           
            CharactersListView()
                .tabItem {
                    Label("Home", systemImage: "house.circle.fill")
                        .foregroundStyle(Color.marvelRed)
                }
                .toolbarBackground(.mavelGray, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            
            
            FavoriteCharactersView()
                .tabItem {
                    Label("Favorite", systemImage: "star.circle.fill")
                }
                .toolbarBackground(.mavelGray, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
           
            ReadCharactersView()
                .tabItem {
                    Label("Read", systemImage: "bookmark.circle.fill")
                } 
                .toolbarBackground(.mavelGray, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            

            CreaterUserCharactesView()
                .tabItem {
                    Label("Creater", systemImage: "person.crop.circle.fill.badge.plus")
                }
                .toolbarBackground(.mavelGray, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
           
        }.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavegationTabView()
}
