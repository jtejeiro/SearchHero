//
//  FormContentView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 2/7/24.
//

import SwiftUI

struct FormContentView<Content: View>: View {
    let titleBox:String
    @State var ishiddenBox:Bool = false
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack{
                        Text(titleBox)
                            .font(.title3)
                            .foregroundStyle(Color.white)
                            .frame(minWidth: 0,maxWidth: .infinity,maxHeight:20,alignment: .leading)
                        Button {
                            ishiddenBox.toggle()
                            
                        } label: {
                            Image(systemName: "arrowtriangle.up.circle")
                                .resizable()
                                .foregroundColor(.marvelRed)
                                .frame(width: 20, height: 20, alignment: .center)
                                .rotationEffect(.degrees(ishiddenBox ? 180 : 0))
                        }
                    }.padding(.all,10)
                    Color.white
                        .padding(.horizontal,10)
                        .frame(minWidth: 0,maxWidth: .infinity,maxHeight:1,alignment: .leading)
                        .padding(.bottom,10)
                }.frame(minWidth: 0,maxWidth: .infinity)
                
                VStack {
                    ScrollView {
                        content()
                            .padding(.all,1)
                    }
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight:ishiddenBox ? 0 :280)
                .padding(ishiddenBox ? 0 :20)
                
                Color.white
                    .padding(.horizontal,10)
                    .frame(minWidth: 0,maxWidth: .infinity,maxHeight:1,alignment: .leading)
                    .padding(.bottom,10)
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.gray.opacity(0.1))
            )
        }.padding(.horizontal,10)
            .padding(.vertical,10)
            .frame(minWidth: 0,maxWidth: .infinity)
    }
}

struct FormDataTextCamp:View {
    @EnvironmentObject var model: FormDataModel
    
    var body: some View {
        FormTextView(inputText: $model.inputText,placeHolder: model.getPlaceholder(),keyboardType: getTypekeyboard(), disabled: $model.isDisabled , isError: $model.iSErrorBox,limiteChart: model.limitChart)
            .onChange(of: model.inputText) { oldValue, newValue in
                debugPrint(model.inputText)
            }
    }
    
    func getTypekeyboard()-> UIKeyboardType {
        switch model.typeTextfield {
        case .Text:
            return .default
        case .number:
            return .numberPad
        case .email:
            return .emailAddress
        }
    }
}


#Preview {
    FormContentView(titleBox: "Hero") {
        Text("hero")
    }
}
