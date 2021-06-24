//
//  PasswordsApp.swift
//  Passwords
//
//  Created by Braeden Norman on 2021-06-23.
//

import SwiftUI

@main
struct PasswordsApp: App {
    var body: some Scene {
        WindowGroup {
            
            ContentView(passwords: [] as! [Password])
        }
    }
}


func getPasswords() {
    let defaults = UserDefaults.standard
    var passwords = defaults.object(forKey: "password")
    print(passwords)
    if passwords == nil {
        passwords = []
    }
    // return passwords as! [Password]
}
