//
//  CarciTextFieldRep.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import SwiftUI

#if os(iOS)
    struct CarciTextFieldRep: UIViewRepresentable {
        @Binding var text: String
        var isFocused: Binding<Bool>?
        @Binding var height: CGFloat
        var returnKeyType: CarciTextField.ReturnKeyType
        var onCommit: (() -> Void)?

        func makeUIView(context: Context) -> UITextView {
            let view = CustomUITextView(rep: self)
            view.font = UIFont.preferredFont(forTextStyle: .body)
            view.backgroundColor = .clear
            view.delegate = context.coordinator
            view.textContainerInset = .zero
            view.textContainer.lineFragmentPadding = 0
            view.keyboardDismissMode = .interactive
            view.returnKeyType = returnKeyType.uiReturnKey
            DispatchQueue.main.async {
                view.text = text
                height = view.textHeight()
            }
            return view
        }

        func updateUIView(_ view: UITextView, context: Context) {
            if view.returnKeyType != returnKeyType.uiReturnKey {
                view.returnKeyType = returnKeyType.uiReturnKey
                view.reloadInputViews()
                return
            }

            if view.text != text {
                view.text = text

                DispatchQueue.main.async {
                    height = view.textHeight()
                }
            }

            updateFocus(view, context: context)
        }

        private func updateFocus(_ view: UITextView, context: Context) {
            guard let isFocused = isFocused?.wrappedValue else { return }
            if isFocused,
               view.window != nil,
               !view.isFirstResponder,
               view.canBecomeFirstResponder,
               context.environment.isEnabled
            {
                view.becomeFirstResponder()
                view.selectedRange = NSRange(location: view.text.count, length: 0)
            } else if !isFocused, view.isFirstResponder {
                view.resignFirstResponder()
            }
        }

        // MARK: - Coordinator
        func makeCoordinator() -> Coordinator {
            Coordinator(rep: self)
        }

        class Coordinator: NSObject, UITextViewDelegate {
            let rep: CarciTextFieldRep

            internal init(rep: CarciTextFieldRep) {
                self.rep = rep
            }

            func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
                guard let onCommit = rep.onCommit, text == "\n" else { return true }
                onCommit()
                return false
            }

            func textViewDidChange(_ textView: UITextView) {
                rep.text = textView.text
                rep.height = textView.textHeight()
            }
        }
    }


    class CustomUITextView: UITextView {
        let rep: CarciTextFieldRep

        internal init(rep: CarciTextFieldRep) {
            self.rep = rep
            super.init(frame: .zero, textContainer: nil)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func becomeFirstResponder() -> Bool {
            rep.isFocused?.wrappedValue = true
            return super.becomeFirstResponder()
        }

        override func resignFirstResponder() -> Bool {
            rep.isFocused?.wrappedValue = false
            return super.resignFirstResponder()
        }
    }

    extension UITextView {
        func textHeight() -> CGFloat {
            sizeThatFits(bounds.size).height
        }
    }
#endif
