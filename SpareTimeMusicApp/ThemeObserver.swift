//
//  ThemeObserver.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/1/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

class ThemeObserver {
    
    // MARK: Structs
    private struct Static {
        static let instance = ThemeObserver()
        static let queue = dispatch_queue_create("com.xmsofresh.SpareTimeAppAlarm.ThemeManager.ThemeObserver", DISPATCH_QUEUE_SERIAL)
        static let themeObserverUpdateNotificationKey: String = "com.xmsofresh.SpareTimeAppAlarm.ThemeManager.UpdateTheme"
    }
    
    struct Observer {
        let observer: NSObjectProtocol
        let name: String
    }
    
    typealias HandlerClosure = ((NSNotification!) -> Void)
    
    // MARK: Properties
    var cache = [UInt: [Observer]]()
    
    // MARK: Publish method
    class func post(name: String = Static.themeObserverUpdateNotificationKey, sender: AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: sender)
    }
    // MARK: Subscribe method
    class func on(target: AnyObject, name: String = Static.themeObserverUpdateNotificationKey, sender: AnyObject?, queue: NSOperationQueue?, handler: HandlerClosure) -> NSObjectProtocol {
        let id = ObjectIdentifier(target).uintValue
        let observer = NSNotificationCenter.defaultCenter().addObserverForName(name, object: sender, queue: queue, usingBlock: handler)
        let namedObserver = Observer(observer: observer, name: name)
        
        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers + [namedObserver]
            } else {
                Static.instance.cache[id] = [namedObserver]
            }
        }
        
        return observer
    }
    
    class func onMainThread(target: AnyObject, name: String = Static.themeObserverUpdateNotificationKey, handler: HandlerClosure) -> NSObjectProtocol {
        return ThemeObserver.on(target, name: name, sender: nil, queue: NSOperationQueue.mainQueue(), handler: handler)
    }
    
    class func onMainThread(target: AnyObject, name: String = Static.themeObserverUpdateNotificationKey, sender: AnyObject?, handler: HandlerClosure) -> NSObjectProtocol {
        return ThemeObserver.on(target, name: name, sender: sender, queue: NSOperationQueue.mainQueue(), handler: handler)
    }
    
    class func onBackgroundThread(target: AnyObject, name: String = Static.themeObserverUpdateNotificationKey, handler: HandlerClosure) -> NSObjectProtocol {
        return ThemeObserver.on(target, name: name, sender: nil, queue: NSOperationQueue(), handler: handler)
    }
    
    class func onBackgroundThread(target: AnyObject, name: String = Static.themeObserverUpdateNotificationKey, sender: AnyObject?, handler: HandlerClosure) -> NSObjectProtocol {
        return ThemeObserver.on(target, name: name, sender: sender, queue: NSOperationQueue(), handler: handler)
    }
    // MARK: Unsubscribe method
    class func unregister(target: AnyObject) {
        let id = ObjectIdentifier(target).uintValue
        let center = NSNotificationCenter.defaultCenter()
        
        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache.removeValueForKey(id) {
                for namedObserver in namedObservers {
                    center.removeObserver(namedObserver.observer)
                }
            }
        }
    }
}
