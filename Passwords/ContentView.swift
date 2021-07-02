//
//  ContentView.swift
//  Passwords
//
//  Created by Braeden Norman on 2021-06-23.
//

import SwiftUI
import Swifter



struct ContentView: View {
    @State var passwordInfo = PasswordInfo()
    @StateObject  var passwordList = PasswordList()
    @State var ipAddress = getWiFiAddress()
    @State var show = false
    
    var body: some View {
            NavigationView {
                    List {
                        ForEach(passwordList.list, id: \.self) { passwordInfo in
                            NavigationLink ("ID: \(passwordInfo.identifier)",
                                            destination: PasswordRow(item: passwordInfo, list: passwordList)
                                
                      )
                    }
                }.navigationTitle("Password List")
            }
            
            //
            VStack(){
               TextField("Username", text: $passwordInfo.username)
                    .frame(width: 200, height: 20, alignment: .center)
                TextField("Password", text: $passwordInfo.password)
                    .frame(width: 200, height: 20, alignment: .center)
                TextField("Description", text: $passwordInfo.description)
                    .frame(width: 200, height: 20, alignment: .center)
                TextField("Identifier", text: $passwordInfo.identifier)
                    .frame(width: 200, height: 20, alignment: .center)
                Button(action: { buttonEnterCallback()})
                { Text("Enter") }
            }

            Text(ipAddress!)
        
        
    }
    
    func buttonEnterCallback() {
        passwordList.addCopyOfPasswordInfo(passwordInfo: passwordInfo)
        passwordInfo.password = ""
        passwordInfo.username = ""
        passwordInfo.description = ""
        passwordInfo.identifier = ""
    }
}


func serverInit(htmlString: String) -> HttpServer{
    let server = HttpServer()
    server["dumbass"] = scopes {
        html {
            body {
            h1 { inner = "Amir is a fucking dumbass" }
          }
        }
      }
    server[""] = { request in
        return HttpResponse.ok(.text(htmlString))
    }
    return server
}





