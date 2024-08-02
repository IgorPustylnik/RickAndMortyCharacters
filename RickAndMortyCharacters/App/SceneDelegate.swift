//
//  SceneDelegate.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var networkMonitor = NetworkMonitor.shared
    var rootController: UIViewController?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        networkMonitor.startMonitoring()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showOfflineDeviceUI(notification:)),
                                               name: NSNotification.Name.connectivityStatus,
                                               object: nil)

        rootController = NavigationController(rootViewController: MainVC())
        if !networkMonitor.isConnected {
            rootController = NetworkErrorVC()
        }

        window.rootViewController = rootController
        self.window = window
        self.window?.makeKeyAndVisible()
    }

    @objc func showOfflineDeviceUI(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            DispatchQueue.main.async { [self] in
                self.rootController = NavigationController(rootViewController: MainVC())
                self.window?.rootViewController = rootController
            }
        } else {
            DispatchQueue.main.async { [self] in
                self.rootController = NetworkErrorVC()
                self.window?.rootViewController = rootController
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
