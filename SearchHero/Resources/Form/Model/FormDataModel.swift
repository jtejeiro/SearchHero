//
//  FormDataModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 2/7/24.
//

import Foundation
import SwiftUI


internal enum FormDataTypes {
    //  1
    case heroName
    case originalName
    case typePower
    case species
    case cityDefeder
}

internal enum TypeTextfield {
    case Text
    case number
    case email
}

@Observable
final class FormDataModel:ObservableObject {
    var id:FormDataTypes!
    var titleBox:String!
    var isRequire:Bool!
    var listFormString: [ListFormString] = []
    public var errorMsg:String = "Form_Error_Generic"
    public var inputText:String = ""
    public var iSErrorBox:Bool = false
    var isDisabled:Bool = false
    var typeTextfield:TypeTextfield = .Text
    var limitChart:Int = 0
    
    init(id: FormDataTypes!, titleBox: String!, isRequire: Bool!,listFormString:[ListFormString] = [],errorMsg:String = "Form_Error_Generic", inputText:String = "" ,isDisabled:Bool = false, typeTextfield:TypeTextfield = .Text,limitChart:Int = 0) {
        self.id = id
        self.titleBox = titleBox
        self.isRequire = isRequire
        self.listFormString = listFormString
        self.errorMsg = errorMsg
        self.inputText = inputText
        self.isDisabled = isDisabled
        self.typeTextfield = typeTextfield
        self.limitChart = limitChart
    }
    
    func getPlaceholder() -> String {
        if isRequire {
          return titleBox + " *"
        }
        return titleBox
    }
    
    func getValide() ->  Bool {
        if isRequire {
            if inputText.isEmpty {
                DispatchQueue.main.async {
                    self.iSErrorBox = true
                }
                
                return false
            }
        }
        
        if !inputText.isEmpty {
            if !getValideType() {
                DispatchQueue.main.async {
                    self.iSErrorBox = true
                }
                return false
            }
        }
        
        DispatchQueue.main.async {
            self.iSErrorBox = false
        }
        return true
    }
    
    func getValideType() -> Bool {
        
        return true
    }
    
    func loadInputData(text:String?) {
        self.isDisabled = false
        self.inputText = text ?? ""
    }
    
    func resetInputData() {
        self.inputText = ""
        self.iSErrorBox = false
    }
   
}

struct ListFormString:Identifiable {
    let id: Int
    let name:String
    var icono:String = ""
}
