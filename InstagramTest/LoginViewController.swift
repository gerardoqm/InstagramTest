//
//  LoginViewController.swift
//  InstagramTest
//
//  Created by Gerardo on 1/7/19.
//  Copyright © 2019 Gerardo Quintanar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: WKWebView! 

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func signInRequest() {
        let url = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_CONSTANTS.AUTHURL, INSTAGRAM_CONSTANTS.CLIENTID, INSTAGRAM_CONSTANTS.REDIRECTURL, INSTAGRAM_CONSTANTS.SCOPE])
        let request = URLRequest.init(url: URL.init(string: url)!)
        webView.loadRequest(request)
        
    }
    func checkRequestForCallBackURL(request: URLRequest) -> Bool {
        let urlString = (request.url?.absoluteString)! as String
        if urlString.hasPrefix(INSTAGRAM_CONSTANTS.REDIRECTURL) {
            let range : Range <String.Index> = urlString.range(of: "#access_token")!
            getAuthTokenn(authToken: urlString.substring(from: range.upperBound))
            return false
        }
        return true
    }
    func getAuthTokenn(authToken: String) {
        let url = String(format: "https://api.instagram.com/v1/users/self/?access_token=%@")
        let request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data
            {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                let strFullName = (json?.value(forKey: "data") as AnyObject).value(forKey: "full_name") as? String
                let alert = UIAlertController(title: "FULL_NAME", message: strFullName, preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK action"), style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert ,animated: true){ _ in }
            }
            
        }.resume()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool        <#function body#>
    }
}
