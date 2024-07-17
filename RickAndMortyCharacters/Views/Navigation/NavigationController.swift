//
//  NavigationController.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

class NavigationController: UINavigationController {
    
    private lazy var backButton: UIBarButtonItem = {
        $0.image = UIImage(systemName: "chevron.left")?.withTintColor(.Colors.mainText, renderingMode: .alwaysOriginal)
        $0.target = self
        $0.action = #selector(pressedBackButton)
        return $0
    }(UIBarButtonItem())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = .Colors.background
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Colors.mainText, .font: UIFont.IBMPlexSans.bold(size: 24)]
        navigationItem.leftBarButtonItem = backButton

    }
    
    @objc
    private func pressedBackButton() {
        popViewController(animated: true)
    }

}
