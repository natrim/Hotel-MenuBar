//
//  AppDelegate.swift
//  Statut
//
//  Created by 卢涛南 on 15/12/30.
//  Copyright © 2015年 randy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let popover = NSPopover()
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    var eventMonitor: EventMonitor?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        popover.contentViewController = PopupViewController(nibName: "PopupViewController", bundle: nil)
        
        initialPopupSize()
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }
    
    func initialPopupSize(){
        popover.contentSize.width = Settings.popupWidth
        popover.contentSize.height = Settings.popupHeight
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(_ sender: AnyObject?){
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(_ sender: AnyObject?){
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func togglePopover(_ sender: AnyObject?) {
        if (popover.isShown) {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}

