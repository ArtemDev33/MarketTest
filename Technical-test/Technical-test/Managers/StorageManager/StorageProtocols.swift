//
//  StorageProtocols.swift
//  Technical-test
//
//  Created by Артем Гавриленко on 12.02.2023.
//

import Foundation

protocol StorageManager {
    var quotes: [Quote] { get }
    
    func refreshStorage()
    func addQuote(_ quote: Quote) throws
    func removeQuote(_ quote: Quote) throws
}

protocol StorageManagerSubscriber {
    func subscribeForUpdates(observer: StorageManagerObserver)
    func unsubscribeFromUpdates(observer: StorageManagerObserver)
}

protocol StorageManagerObserver: AnyObject {
    func storageManagerDidUpdate(with newQuotes: [Quote])
    func storageManagerDidRemoveQuote(_ quote: Quote?, at indexPath: IndexPath?)
}

typealias StorageService = StorageManager & StorageManagerSubscriber
