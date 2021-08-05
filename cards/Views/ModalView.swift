//
//  ModalView.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import SwiftUI

struct ModalView: View {
    @State private var isPresented = true
    @State private var isFocused = false
    @State private var text = ""
    let name = UserDefaults.standard.array(forKey: "name")
    
    var body: some View {
        GameView()
            .onAppear(perform: {
                if let unwrapped = name {
                    self.isPresented = false
                    self.text = unwrapped.first as! String
                }
            })
            .sheet(isPresented: $isPresented, content: {
                CarciTextField("Name", text: $text, isFocused: $isFocused, returnKeyType: .done) {
                    text = ""
                } onCommit: {
                    if (text != "") {
                        UserDefaults.standard.set([text], forKey: "name")
                        self.isPresented = false
                    }
                }
                .padding()
                .preferredColorScheme(.dark)
            })
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
    }
}
