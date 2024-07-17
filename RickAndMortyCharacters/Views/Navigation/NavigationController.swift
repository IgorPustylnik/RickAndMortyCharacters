//
//  NavigationController.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = .Colors.background
        
        // Custom title font
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Colors.mainText, .font: UIFont.IBMPlexSans.bold(size: 24)]
    }

}
