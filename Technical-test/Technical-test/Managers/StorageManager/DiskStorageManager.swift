//
//  DiskStorageManager.swift
//  Technical-test
//
//  Created by Артем Гавриленко on 12.02.2023.
//

import Foundation

final class DiskStorageManager: StorageManager {
    
    private let key = "quotesArray.json"
    
    private let fileManager: FileManager
    private(set) var quotes: [Quote] = []
    private var previousQuoteCount: Int = 0
    private var observers = WeakPointerArray<StorageManagerObserver>()
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        refreshStorage()
    }
    
    func refreshStorage() {
        guard let data = try? read(fileNamed: key),
              let quotes = decodeQuotes(data) else { return }
        self.quotes = quotes
        self.previousQuoteCount = quotes.count
    }
    
    func addQuote(_ quote: Quote) throws {
        let oldQuotes = quotes
        var updatedQuote = quote
        updatedQuote.isFavourite = true
        quotes.append(updatedQuote)
        
        do {
            try updateQuotes(quotes)
        } catch let error as DiskStorageManager.Error {
            quotes = oldQuotes
            throw error
        }
    }
    
    func removeQuote(_ quote: Quote) throws {
        guard let index = quotes.firstIndex(where: { $0.name == quote.name }) else {
            return
        }
        
        let oldQuotes = quotes
        quotes.remove(at: index)
        do {
            try updateQuotes(quotes, removed: quote, at: IndexPath(row: index, section: 0))
        } catch let error as DiskStorageManager.Error {
            quotes = oldQuotes
            throw error
        }
    }
    
    func contains(quote: Quote) -> Bool {
        for item in quotes where item == quote {
            return true
        }
        return false
    }
}

// MARK: - Private

private extension DiskStorageManager {
    
    func updateQuotes(_ quotes: [Quote], removed quote: Quote? = nil, at indexPath: IndexPath? = nil) throws {
        guard let data = encodeQuotes(quotes) else {
            throw Error.writingFailed
        }
        
        do {
            try save(fileNamed: key, data: data)
            previousQuoteCount > quotes.count ? notifyAboutRemoving(of: quote, at: indexPath) : notifyAboutAdding()
            previousQuoteCount = quotes.count
        } catch let error as DiskStorageManager.Error {
            throw error
        }
    }
    
    func decodeQuotes(_ data: Data) -> [Quote]? {
        guard let quotes = try? JSONDecoder().decode([Quote].self, from: data) else {
            return nil
        }
        return quotes
    }
    
    func encodeQuotes(_ quotes: [Quote]) -> Data? {
        guard let data = try? JSONEncoder().encode(quotes) else {
            return nil
        }
        return data
    }
    
    func save(fileNamed: String, data: Data) throws {
        guard let url = url(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            throw Error.writingFailed
        }
    }
    
    func read(fileNamed: String) throws -> Data {
        guard let url = url(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        guard fileManager.fileExists(atPath: url.path) else {
            throw Error.fileNotExists
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw Error.readingFailed
        }
    }
    
    func url(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    func notifyAboutAdding() {
        observers.forEach { $0.storageManagerDidUpdate(with: quotes) }
    }

    func notifyAboutRemoving(of quote: Quote?, at indexPath: IndexPath?) {
        observers.forEach { $0.storageManagerDidRemoveQuote(quote, at: indexPath) }
    }
}

// MARK: - StorageManager Subscriber

extension DiskStorageManager: StorageManagerSubscriber {
    
    func subscribeForUpdates(observer: StorageManagerObserver) {
        observers.add(observer)
    }
    
    func unsubscribeFromUpdates(observer: StorageManagerObserver) {
        observers.remove(observer)
    }
}

// MARK: - Errors

extension DiskStorageManager {
    
    enum Error: String, Swift.Error {
        case fileNotExists = "file doesn't exist"
        case invalidDirectory = "invalid directory"
        case writingFailed = "writing failed"
        case readingFailed = "reading failed"
    }
}
