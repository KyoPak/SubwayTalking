//
//  SceneDelegate.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/5/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // MARK: Fix
//        let mainIntent = DefaultMainIntent(addMarkerUseCase: DefaultAddMarkerUseCase(markerDataRepository: DefaultMarkerDataRepository()))
//        window?.rootViewController = MainViewController(intent: mainIntent)
        let startTempViewController = StartViewController()
        window?.rootViewController = startTempViewController
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
