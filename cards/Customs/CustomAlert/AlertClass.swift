//
//  AlertClass.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import SwiftUI

enum AlertAction {
    case cancel
    case ok
}

struct AlertView: View {
     
     @Binding var shown: Bool
     @Binding var closureA: AlertAction?
     var isSuccess: Bool
     var message: String
     
     var body: some View {
         VStack {
             
             Image(isSuccess ? "check":"remove").resizable().frame(width: 50, height: 50).padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
             Spacer()
             Text(message).foregroundColor(Color.white)
             Spacer()
             Divider()
             HStack {
                 Button("Close") {
                     closureA = .cancel
                     shown.toggle()
                 }.frame(width: UIScreen.main.bounds.width/2-30, height: 40)
                 .foregroundColor(.white)
                 
                 Button("Ok") {
                     closureA = .ok
                     shown.toggle()
                 }.frame(width: UIScreen.main.bounds.width/2-30, height: 40)
                 .foregroundColor(.white)
                 
             }
             
         }.frame(width: UIScreen.main.bounds.width-50, height: 200)
         
         .background(Color.black.opacity(0.5))
         .cornerRadius(12)
         .clipped()
         
     }
 }
