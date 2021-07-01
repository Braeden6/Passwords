//
//  getHTMLString.swift
//  Passwords
//
//  Created by Braeden Norman on 2021-06-30.
//

import Foundation


func getHTMLString(password: String) -> String {
    var string = ""
    string += """
            <style>
                input {
                    width: 10px;
                    height: 10px;
                }
                </style>
             <script>
                 function startup() {
                     document.getElementById('btn').addEventListener('click', function() {
                         var copyText = document.getElementById("myInput");
                         copyText.select();
                         copyText.setSelectionRange(0, 99999)
                         document.execCommand("copy");
                 });

            }
             </script>
             <html>
                 <body onload='startup()'>
                     <input type="text" value="

"""
    
   string += password
    
    string += """

            " id="myInput" size="1">
                     <button id='btn' type='button'> Click Here</button>
                 </body>
             </html>

"""

    return string
}
