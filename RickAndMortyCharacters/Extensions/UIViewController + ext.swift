//
//  UIViewController + ext.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

extension UIViewController {
    func addHidingKeyboardGesture() {
        let tap = UIGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupCustomBackButton() {
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.Colors.mainText, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(pressedBackButton))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc
    private func pressedBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
