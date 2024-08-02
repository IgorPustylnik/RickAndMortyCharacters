//
//  UIViewController + ext.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

extension UIViewController {
    func setupCustomBackButton() {
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(
            .Colors.mainText,
            renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(
            image: backButtonImage,
            style: .plain,
            target: self,
            action: #selector(pressedBackButton))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc
    private func pressedBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailedInfoVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
