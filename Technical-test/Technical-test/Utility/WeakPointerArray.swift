//
//  WeakPointerArray.swift
//  Technical-test
//
//  Created by Артем Гавриленко on 12.02.2023.
//

import Foundation

class WeakPointerArray<ObjectType> {

    var count: Int {
        weakStorage.count
    }

    fileprivate let weakStorage = NSHashTable<AnyObject>.weakObjects()

    func add(_ object: ObjectType) {
        weakStorage.add(object as AnyObject)
    }

    func remove(_ object: ObjectType) {
        weakStorage.remove(object as AnyObject)
    }

    func removeAllObjects() {
        weakStorage.removeAllObjects()
    }

    func contains(_ object: ObjectType) -> Bool {
        weakStorage.contains(object as AnyObject)
    }
}

extension WeakPointerArray: Sequence {
    func makeIterator() -> AnyIterator<ObjectType> {

        let enumerator = weakStorage.objectEnumerator()

        return AnyIterator {
            return enumerator.nextObject() as! ObjectType?
        }
    }
}
