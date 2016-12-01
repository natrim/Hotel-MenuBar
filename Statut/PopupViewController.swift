//
//  PopupViewController.swift
//  Statut
//
//  Created by 卢涛南 on 15/12/30.
//  Copyright © 2015年 randy. All rights reserved.
//

import Cocoa
import WebKit

class PopupViewController: NSViewController, WebFrameLoadDelegate {

    @IBOutlet weak var mainWebView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWebView()
        mainWebView.frameLoadDelegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    func loadWebView() {
        // Do view setup here.
        mainWebView.mainFrame.stopLoading()
        mainWebView.mainFrame.load(URLRequest(url: URL(string: Settings.url )!))
    }
    
    func webView(_ sender: WebView!, didStartProvisionalLoadFor frame: WebFrame!) {
        if (sender.mainFrameURL != Settings.url) {
            NSWorkspace.shared().open(URL(string: sender.mainFrameURL)!)
            sender.stopLoading(sender)
        }
    }
    
    @IBAction func openAdminUrl(_ sender: Any) {
        NSWorkspace.shared().open(URL(string: Settings.url)!)
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.closePopover(self)
    }

    
    @IBAction func killApp(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }

    @IBAction func stopHotel(_ sender: Any) {
        let path = "/usr/bin/env"
        let arguments = ["/usr/local/bin/node", "/usr/local/bin/hotel", "stop"]
        
        let task = Process.launchedProcess(launchPath: path, arguments: arguments)
        task.waitUntilExit()
    }
    
    @IBAction func startHotel(_ sender: Any) {
        let path = "/usr/bin/env"
        let arguments = ["/usr/local/bin/node", "/usr/local/bin/hotel", "start"]
        
        let task = Process.launchedProcess(launchPath: path, arguments: arguments)
        task.waitUntilExit()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.loadWebView()
        })
    }
    
}
