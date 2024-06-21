//
//  NavegationBarView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import SwiftUI


let navBarAppearence = UINavigationBarAppearance()
 
struct NavegationBarView<Content: View> : View {
    var headerImg:Image {
        .init(.logo)
    }
    @Binding public var hiddenBackButton: Bool
    var content: () -> Content
    @Environment(\.dismiss) private var dismiss
    
    init( hiddenBackButton: Binding<Bool> ,
        @ViewBuilder _ content: @escaping () -> Content) {
            navBarAppearence.configureWithOpaqueBackground()
            navBarAppearence.backgroundColor = .marvelRed
            navBarAppearence.shadowColor = .clear
            
        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        self._hiddenBackButton = hiddenBackButton
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
                content()
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                if !hiddenBackButton {
                    Button(action: {
                        print("button pressed")
                        dismiss()
                    }) {
                        HStack(alignment: .center,spacing: 2) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                Button(action: {
                    print("button pressed")
                }) {
                    headerImg
                        .resizable()
                        .frame(width: 110, height: 50, alignment: .center)
                        .scaledToFill()
                }
            }
            
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
    }
    
}

struct MyNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(root: content).navigationBarBackButtonHidden(true)
        } else {
            NavigationView(content: content)
                .navigationViewStyle(.stack).navigationBarTitle("", displayMode:.inline).navigationBarHidden(true)
        }
    }
}


struct LoadingProgressView: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack(alignment:.center ) {
            Color.clear
                .ignoresSafeArea(.all)
                .opacity(0.1)

        ZStack(alignment: .center) {
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(2.0, anchor: .center)
                    .foregroundStyle(.white)
                    .colorMultiply(.white)
                    .padding(.all,10)
                Spacer()
                Text("Cargando...")
                    .foregroundStyle(.white)
                    .colorMultiply(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.all,10)
                Spacer()
            }
            .frame(width: 150, height: 120, alignment: .center)
            // Optional: make it bigger
        }
        .padding(.all,10)
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 2)
            .onAppear {
                startAnimating()
            }
        }.background(BackgroundGrayView())
    }
    
    func startAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.linear(duration: 1.5).repeatForever()) {
                isLoading = true
            }
        }
    }
    
}

struct BackgroundGrayView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: .none)
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


