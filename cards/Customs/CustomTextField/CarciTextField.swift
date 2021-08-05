//
//  CardciTextField.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import SwiftUI

public struct CarciTextField: View {
    var title: String
    @Binding var text: String
    var isFocused: Binding<Bool>?
    @State var height: CGFloat = 0
    var returnKeyType: ReturnKeyType
    var onCommit: (() -> Void)?
    var onTab: (() -> Void)?
    var onBackTab: (() -> Void)?
    
    public init<S: StringProtocol>(
        _ title: S,
        text: Binding<String>,
        isFocused: Binding<Bool>? = nil,
        returnKeyType: ReturnKeyType = .default,
        onTab: (() -> Void)? = nil,
        onBackTab: (() -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self.title = String(title)
        _text = text
        self.isFocused = isFocused
        self.returnKeyType = returnKeyType
        self.onCommit = onCommit
        self.onTab = onTab
        self.onBackTab = onBackTab
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Text(title)
                .foregroundColor(.secondary)
                .opacity(text.isEmpty ? 0.5 : 0)
                .animation(nil)
            
            
            CarciTextFieldRep(
                text: $text,
                isFocused: isFocused,
                height: $height,
                returnKeyType: returnKeyType,
                onCommit: onCommit
            )
            .frame(height: height)
            
        }
    }
}

public extension CarciTextField {
    enum ReturnKeyType: String, CaseIterable {
        case done
        case next
        case `default`
        case `continue`
        case go
        case search
        case send
        
        #if os(iOS)
        var uiReturnKey: UIReturnKeyType {
            switch self {
            case .done:
                return .done
            case .next:
                return .next
            case .default:
                return .default
            case .continue:
                return .continue
            case .go:
                return .go
            case .search:
                return .search
            case .send:
                return .send
            }
        }
        #endif
    }
}
