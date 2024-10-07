//
//  FormPopupView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 4/7/24.
//

import Foundation
import SwiftUI

struct FormPopupView<Content: View>: View  {
    let titleBox:String
    @Binding var isClose:Bool
    @ViewBuilder var content: () -> Content
    
    
    var body: some View {
        ZStack(alignment:.center ) {
            Color.mavelGray
                .ignoresSafeArea(.all)
                .opacity(0.5).onTapGesture {
                    isClose.toggle()
                }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Spacer()
                    Text(titleBox)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .padding()
                    Spacer()
                }
                .background(.marvelRed)
                ZStack {
                    content()
                }
                .padding(.vertical,5)
            }
            .frame(minWidth: 0,maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(6)
            .padding(.horizontal,10)
        }.background(BackgroundGrayView())
    }
}

struct FormPopupList:View {
    @Binding var isClose:Bool
    @Binding var index:Int
    let titleBox:String
    let list:[ListFormString]
    
    var body: some View {
        FormPopupView(titleBox: titleBox, isClose: $isClose) {
            ScrollView {
                LazyVStack {
                    ForEach(0..<list.count , id: \.self) { index in
                        HStack {
                            Text(list[index].name)
                                .font(.system(size: 15))
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.all, 10)
                                .frame(minWidth: 0,maxWidth: .infinity,alignment: .leading)
                        }
                        .frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: 40,alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                self.index = index
                                isClose.toggle()
                            }
                        }
                        .id(index)
                        .hoverEffect()
                        
                        Color.mavelGray
                            .frame(height:1)
                            .opacity(0.6)
                            .padding(.horizontal,10)
                    }
                }
            }
            .frame(height: getIdealHeight())
        }
    }
    
    
    func getIdealHeight() -> CGFloat {
       let height = ((40 * CGFloat(list.count + 1)) + 20)
        debugPrint("getIdealHeight")
        debugPrint(height)
        if height < 400 {
            return height
        }
        
        return 400
    }
            
}


struct FormPopupGrid:View {
    @Binding var isClose:Bool
    @Binding var index:Int
    let titleBox:String
    let list:[ListFormString]
    
    let columns = [
            GridItem(.adaptive(minimum: 90))
        ]
    
    var body: some View {
        FormPopupView(titleBox: titleBox, isClose: $isClose) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<list.count , id: \.self) { index in
                        FormPopupCell(model: list[index])
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    self.index = index
                                    isClose.toggle()
                                }
                            }
                            .id(index)
                            .hoverEffect()
                    }
                }
            }
            .frame(height: getIdealHeight())
        }
    }
    
    
    func getIdealHeight() -> CGFloat {
       let height = ((40 * CGFloat(list.count + 1)) + 20)
        debugPrint("getIdealHeight")
        debugPrint(height)
        if height < 400 {
            return height
        }
        
        return 400
    }
    
    struct FormPopupCell: View {
        let model: ListFormString
        
        var body: some View {
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .opacity(0.4)
                    .overlay {
                        Text(model.icono)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .frame(width: 60, height: 60, alignment: .center)
                    }
                    .padding(.all,10)
            
                
                Text(model.name)
                    .font(.caption)
                    .foregroundStyle(.black)
                    .frame(width: 80 ,height: 50,alignment: .center)
            }
            .background {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(.black.opacity(0.2))
            }
            
        }
    }

}


enum FormDateTimeTypes {
    case BeforeNow
    case afterNow
    case all
}

struct FormPopupDate:View {
    @Binding var isClose:Bool
    @Binding var date:Date
    let titleBox:String
    var timetype:FormDateTimeTypes = .all
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()

    
    var body: some View {
        FormPopupView(titleBox: titleBox, isClose: $isClose) {
            VStack {
                switch timetype {
                   // listCalendarStyles : WheelDatePickerStyle GraphicalDatePickerStyle()
                case .BeforeNow:
                    DatePicker(titleBox, selection: $date,in: Date.now...,displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 400)
                case .afterNow:
                    let currentDate = Date()
                    let eighteenYearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: currentDate)!
                    DatePicker(titleBox, selection: $date,in: ...eighteenYearsAgo,displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 400)
                case .all:
                    DatePicker(titleBox, selection: $date,displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 400)
                }
               
                Button {
                    isClose.toggle()
                } label: {
                    Text("Alert_box_button_ok")
                        .font(.system(size: 17,weight: .heavy))
                        .foregroundStyle(.marvelRed)
                        .hoverEffect(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
                        .padding()
                }

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
