//
//  MyURLProtocol.swift
//  TMMC_App_v1
//  v 1.01
//  Developed as a Taproot+ Project
//
//  Developed by william heublein in April 2016.
//  Coded in 2016 by Will Heublein for the Marine Mammal Center.
//  see willheublein.com
//
//  App Code is covered by the MIT License
//  Copyright (c) 2016 William Heublein
//
//  Images are copyrighted by The Marine Mammal Center, (c) 2016 all rights reserved
//
//



import UIKit

var requestCount = 0
var URLState = "none"
var LastState = "none"

class MyURLProtocol: NSURLProtocol {
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
         print("Request #\(requestCount): URL = \(request.URL!.absoluteString)")
        requestCount += 1
        if (request.URL!.absoluteString) == "http://www.marinemammalcenter.org/Get-Involved/take-action/email-signup-ipad.html" {
            //Webview has made a request to the mmc site's sign up
            LastState = URLState
            URLState = "Sign up page"
        }
        
        if (request.URL!.absoluteString) == "http://tmmc.marinemammalcenter.org/site/PageServer?pagename=enews_thank_you_ipad" {
            //Webview has made a request to the mmc site's thank you page
            LastState = URLState
            URLState = "Thank you page"
        }
        if ((LastState == "Thank you page") && (URLState == "Sign up page")){
          //web page has gone back from thank you to main - clear web view
            
        }
        return false
    } 
}