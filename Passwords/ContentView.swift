//
//  ContentView.swift
//  Passwords
//
//  Created by Braeden Norman on 2021-06-23.
//

import SwiftUI
import Swifter


struct PasswordInfo: Codable, Identifiable {
    var id = UUID()
    var identifier: String
    var username: String
    var password: String
    var description: String
    init() {
        self.username = ""
        self.password = ""
        self.description = ""
        self.identifier = ""
    }
}




class PasswordList: ObservableObject {
    @Published var list: [PasswordInfo] = getSavedPasswordList()
    
    func addCopyOfPasswordInfo(passwordInfo: PasswordInfo) {
        var newPassInfo = PasswordInfo()
        newPassInfo.username = passwordInfo.username
        newPassInfo.identifier = passwordInfo.identifier
        newPassInfo.description = passwordInfo.description
        newPassInfo.password = passwordInfo.password
        list.append(newPassInfo)
    }
}

struct ContentView: View {
    @State var passwordInfo = PasswordInfo()
    @StateObject  var passwordList = PasswordList()
    @State var server: HttpServer = serverStartup()
    var body: some View {
        List(passwordList.list) { passwordInfo in
            Text("Your password is: \(passwordInfo.password)")
        }
        let usernameTF: TextField = TextField("Username", text: $passwordInfo.username)
        usernameTF.frame(width: 200, height: 20, alignment: .center)
        let passwordTF: TextField = TextField("Password", text: $passwordInfo.password)
        passwordTF.frame(width: 200, height: 20, alignment: .center)
        let descriptionTF: TextField = TextField("Description", text: $passwordInfo.description)
        descriptionTF.frame(width: 200, height: 20, alignment: .center)
        let identifierTF: TextField = TextField("Identifier", text: $passwordInfo.identifier)
        identifierTF.frame(width: 200, height: 20, alignment: .center)
        
        Button(action: {
            buttonEnterCallback(passwordList: passwordList, passwordInfo: &passwordInfo)
            savePasswordList(list: passwordList.list)
        }) {
            Text("Enter")
        }
        
        Button(action :{
            savePasswordList(list: [])
            passwordList.list = []
        }) {
            Text("Reset List")
        }
        .frame(width: 200, height: 20, alignment: .center)
        
        
        Button(action: {
            print(UIDevice.current.getIP()) }) {
            Text("Get IP")
        }
        
        
        
    }
}

func buttonEnterCallback(passwordList: PasswordList, passwordInfo: inout PasswordInfo) {
    passwordList.addCopyOfPasswordInfo(passwordInfo: passwordInfo)
    passwordInfo.password = ""
    passwordInfo.username = ""
    passwordInfo.description = ""
    passwordInfo.identifier = ""
}

func savePasswordList(list: [PasswordInfo]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(list) {
        let defaults = UserDefaults.standard
        defaults.set(encoded, forKey: "passwordList")
    }
}

// On success gets a list of PasswordInfo otherwise returns []
func getSavedPasswordList() -> [PasswordInfo] {
    let defaults = UserDefaults.standard
    if let list = defaults.object(forKey: "passwordList") as? Data {
        let decoder = JSONDecoder()
        if let passwordList = try? decoder.decode([PasswordInfo].self, from: list) {
            return passwordList
        }
    }
    return []
}


func serverStartup() -> HttpServer{
    let server = HttpServer()
    server[""] = scopes {
        html {
          body {
            h1 { inner = "Your password will show up here" }
          }
        }
      }
    try! server.start()
    return server
}
