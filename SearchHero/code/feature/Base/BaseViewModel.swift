//
//  BaseViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 1/7/24.
//

import Foundation

public enum ProcessStateTypes {
    case display
    case emptyDisplay
}

@Observable
class BaseViewModel {
    
    public var processState: ProcessStateTypes
    public var isLoading: Bool = false
    public var isAlertbox: Bool = false
    public var alertTitle:String = "Alerta"
    public var alertMessage:String = "Habido un error en el Sistema"
    public var alertButton:String = "ok"
    
    
    init() {
        self.processState = .display
    }
    
    public func displayLoading(_ isLoading:Bool = false) {
        DispatchQueue.main.async  {
            self.isLoading = isLoading
        }
    }
    
    public func displayProcessState(_ state:ProcessStateTypes) {
        DispatchQueue.main.async  {
            self.processState = state
        }
    }
    
    public func displayAlertMessage(title:String = "" ,mesg:String = "" ,textButton:String = "") {
        displayLoading()
        DispatchQueue.main.async  {
            self.isAlertbox = true
            if title != ""  {
                self.alertTitle = title
            }
            if mesg != ""  {
                self.alertMessage = mesg
            }
            
            if textButton != "" {
                self.alertButton = textButton
            }
        }
    }
    
}
