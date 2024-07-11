//
//  SlotMachineSwiftUIApp.swift
//  SlotMachineSwiftUI
//
//  Created by Khavishini on 09/07/2024.
//

import SwiftUI

@main
struct SlotMachineSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(
                    NotificationCenter.default.publisher(for: UIScene.willConnectNotification)
                ) { _ in
                    #if targetEnvironment(macCatalyst)
                    UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .forEach { windowScene in
                            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 600, height: 800)
                            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 600, height: 800)
                        }
                    #endif
                }
        }
    }
}
