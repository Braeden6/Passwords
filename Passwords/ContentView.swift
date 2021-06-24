//
//  ContentView.swift
//  Passwords
//
//  Created by Braeden Norman on 2021-06-23.
//

import SwiftUI

struct Password {
    var identifier: String
    var username: String
    var password: String
    var description: String
    init(username: String, password: String, description: String, identifier: String) {
        self.username = username
        self.password = password
        self.description = description
        self.identifier = identifier
    }
}

struct ContentView: View {
    @State var passwords: [Password]
    @State var username: String = ""
    @State var password: String = ""
    @State var description: String = ""
    @State var identifier: String = ""
    var body: some View {
        TextField("Username", text: $username)
            .frame(width: 200, height: 20, alignment: .center)
        TextField("Password", text: $password)
            .frame(width: 200, height: 20, alignment: .center)
        TextField("Description", text: $description)
            .frame(width: 200, height: 20, alignment: .center)
        TextField("Identifier", text: $identifier)
            .frame(width: 200, height: 20, alignment: .center)
        
        
        Button(action: {
            let newPass: Password = Password( username: username, password: password, description: description ,identifier: identifier)
            passwords.append(newPass)
            print(passwords)
        }) {
            Text("Enter")
        }
        Button(action :{
            let defaults = UserDefaults.standard
            defaults.set([["test":"something", "test2":"somthingElse"], ["test":"something", "test2":"somthingElse"]], forKey: "passwords")
        }) {
            Text("Save Passowrd")
        }
        .frame(width: 200, height: 20, alignment: .center)
        Button(action :{
            let defaults = UserDefaults.standard
            var passwords = defaults.object(forKey: "passwords")
            print(passwords)
            
        }) {
            Text("Load Passowrd")
        }
        .frame(width: 200, height: 20, alignment: .center)
    }
}
