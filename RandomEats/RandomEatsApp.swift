//
//  RandomEatsApp.swift
//  RandomEats
//
//  Created by Django on 12/15/24.
//

import SwiftUI

@main
struct RandomEatsApp: App {
    let persistenceController = PersistenceController.shared


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            

        }
    }
}
