//
//  FormTextView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 2/7/24.
//

import SwiftUI
import Combine

struct FormTextView: View {
    @Binding var inputText: String
    var placeHolder: String = "placeHolder"
    var keyboardType:UIKeyboardType = .default
    @Binding var disabled:Bool
    @Binding var isError:Bool
    var limiteChart: Int = 0
    @State private var isHover:Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            if isHover || inputText != "" {
                Text(placeHolder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .padding(.leading,10)
                    .frame(height: 15)
            }else {
                Spacer().frame(height: 15)
            }
            TextField(text: $inputText) {
                Text(placeHolder)
                    .foregroundStyle(isHover ? Color.clear: Color.white)
                    .font(.system(size: 17))
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
                .frame(height: 30)
                .disabled(disabled)
                .textFieldStyle(FormTextStyle(isError: isError,isDisabled: disabled))
                .autocorrectionDisabled()
                //.textInputAutocapitalization(.characters)
                .disableAutocorrection(true)
                .keyboardType(keyboardType)
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    if newValue {
                        withAnimation {
                            self.isHover = true
                        }
                    } else {
                        if  inputText == "" {
                            withAnimation {
                                self.isHover = false
                            }
                        }else {
                            withAnimation {
                                self.isHover = true
                            }
                        }
                    }
                }
                .onReceive(Just(inputText)) { inputValue in
                    if limiteChart > 0 {
                        if inputValue.count > limiteChart {
                            self.inputText.removeLast()
                        }
                    }
                    
                    if keyboardType == .decimalPad || keyboardType == .numberPad {
                        let filtered = inputValue.filter { Set(" 0123456789").contains($0) }
                        if filtered != inputValue {
                            self.inputText = filtered
                        }
                    }
                }
            
            
        }.frame(height: 50)
    }
}


struct FormTextNoEditView: View {
    @Binding var inputText: String
    var placeHolder: String = "placeHolder"
    var keyboardType:UIKeyboardType = .default
    var disabled:Bool = true
    @Binding var isDisabled:Bool
    @Binding var isError:Bool
    @State private var isHover:Bool = false
    
    var body: some View {
        VStack {
            if isHover || inputText != "" {
                Text(placeHolder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .padding(.leading,10)
                    .frame(height: 15)
            }else {
                Spacer().frame(height: 15)
            }
            TextField(text: $inputText) {
                Text(placeHolder)
                    .foregroundStyle(isHover || inputText != "" ? Color.clear: Color.white)
                    .font(.system(size: 17))
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)

            }
                .frame(height: 30)
                .disabled(disabled)
                .textFieldStyle(FormTextStyle(isError: isError,isDisabled: isDisabled))
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .onTapGesture {
                        withAnimation {
                            self.isHover = true
                        }
                }.onChange(of: inputText)  { oldValue, newValue in
                    if newValue == "" {
                        withAnimation {
                            self.isHover = false
                        }
                    }
                }
            
            
        }.frame(height: 50)
    }
}


struct FormTextStyle:TextFieldStyle {
    var isError:Bool = false
    var isDisabled:Bool = false
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.all, 6)
                .foregroundStyle(.white)
                .background(isDisabled ?  RoundedRectangle(cornerRadius: 2).fill(.white.opacity(0.2)) : RoundedRectangle(cornerRadius: 2).fill(.clear))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isError ? Color.red : Color.white, lineWidth:1)
                    )
        }
    
    
}



