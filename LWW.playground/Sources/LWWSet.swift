import Foundation

/*
 LWW (Last-Write-Wins) Element Set in Swift
 References:
 1. https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type#LWW-Element-Set_(Last-Write-Wins-Element-Set)
 2. https://github.com/pfrazee/crdt_notes#lww-element-set
*/
struct LWWSet<E: Hashable> {
    private var addSet = [E : Date]()
    private var removeSet = [E : Date]()
    
    /// Add an element to addSet.
    ///
    /// - Parameter data: an element to be added to addSet.
    /// - Parameter timestamp: a timestamp (default: current timestamp).
    mutating func add(_ data: E, timestamp: Date = Date()) {
        // Check if the element exists in this set.
        // Return if the existing element's timestamp is newer than current timestamp
        if let existTime = lookup(data), existTime >= timestamp {
            return
        }
        // Add to addSet or update
        addSet[data] = timestamp
    }
    
    /// Add an element to removeSet.
    ///
    /// - Parameter data: an element to be added to removeSet.
    /// - Parameter timestamp: a timestamp (default: current timestamp).
    mutating func remove(_ data: E, timestamp: Date = Date()) {
        // Check if this is removable - exists in this set
        guard lookup(data) != nil else { return }
        // Add to removeSet
        removeSet[data] = timestamp
    }
    
    /// Check if an element exists and is not removed recently.
    ///
    /// - Parameter data: an element to look up.
    /// - Return: a timestamp of exisiting element or nil if removed or never added.
    func lookup(_ data: E) -> Date? {
        if let add_t = addSet[data] {
            if let remove_t = removeSet[data] {
                if remove_t > add_t {
                    return nil
                }
                return add_t
            }
            return add_t
        }
        return nil
    }
    
    /// Compare if current set is a subset of comparee set
    /// (current set ∈ comparee set).
    ///
    /// - Parameter comapree: a LWW set of same type.
    /// - Return: current set is a subset or not.
    func compare(with comparee: LWWSet<E>) -> Bool {
        if addSet.allSatisfy({ comparee.addSet[$0.key] != nil }) {
            if removeSet.allSatisfy({ comparee.removeSet[$0.key] != nil }) {
               return true
            }
        }
        return false
    }
    
    /// Merge with mergee by keeping elements with newer (higher) timestamp
    ///
    /// - Parameter mergee: a LWW set of same type.
    mutating func merge(with mergee: LWWSet<E>) {
        addSet.merge(mergee.addSet) { (t1, t2) in max(t1, t2) }
        removeSet.merge(mergee.removeSet) { (t1, t2) in max(t1, t2) }
    }
    
    // For Debugging Purpose
    func getAddSet() -> [E : Date] {
        return addSet
    }
    func getRemoveSet() -> [E : Date] {
        return removeSet
    }
    func getExisting() -> [E : Date] {
        return addSet.filter { lookup($0.key) != nil }
    }
    func printAddSet() {
        print("AddSet: ", addSet)
    }
    func printRemoveSet() {
        print("RemoveSet: ", removeSet)
    }
    func printExisting() {
        print("Existing: ", addSet.filter { lookup($0.key) != nil })
    }
}
