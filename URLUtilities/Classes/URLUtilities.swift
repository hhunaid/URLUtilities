//Copyright (c) 2016 Hunaid Hassan <hhunaid@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation

fileprivate func + <K,V> (left: Dictionary<K,V>, right: Dictionary<K,V>?) -> Dictionary<K,V> {
    guard let right = right else { return left }
    var dic = left
    right.forEach { key, value in
        dic.updateValue(value, forKey: key)
    }
    return dic
}
/**
    Returns a new URL with the string appended as path component
 
    - parameter left: URL to append the path component to
    - parameter pathComponent: path component to append
 
    - returns: URL with new path component
 */
public func + (left: URL, pathComponent: String) -> URL {
    return left.appendingPathComponent(pathComponent)
}

public func += (left: inout URL, pathComponent: String) {
    left = left.appendingPathComponent(pathComponent)
}

extension URL {
    /**
     Returns query params of the url as a `Dictionary`
    */
    public var queryDictionary: [String: String]? {
        if let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems {
            return queryItems.map({ (item) -> [String: String] in
                var dict = [String: String]()
                dict[item.name] = item.value
                return dict
            }).reduce([String: String](), + )
        }else {
            return nil
        }
    }
    /**
     Returns a new URL with query params replaced with a new dictionary
     
     - parameter queryDictionary: Dictionary to replace the values from
     
     - returns: URL with replaced query parameters
     
     - Important: This method deletes all previous query parameters that URL may have
     */
    public func replacing(queryDictionary: [String:String]) -> URL {
        let newDict = (self.queryDictionary ?? [:]) + queryDictionary
        return self.removingQueryParameters.appending(queryDictionary: newDict)
    }
    /**
     Returns a new URL with query params appended from a new dictionary
     
     - parameter queryDictionary: Dictionary to append the values from
     
     - returns: URL with appended query parameters
     */
    public func appending(queryDictionary: [String:String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        if components.queryItems == nil {
            components.queryItems = []
        }
        components.queryItems?.append(contentsOf: queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) }))
        return components.url!
    }
    /**
     Appends query parameters from a dictionary
     
     - parameter queryDictionary: Dictionary to append the values from
     */
    public mutating func append(queryDictionary: [String: String]) {
        self = appending(queryDictionary: queryDictionary)
    }
    /**
     Replaces query parameters from a dictionary
     - Important: This method deletes all previous query parameters that URL may have
     - parameter queryDictionary: Dictionary to replace the values from
     */
    public mutating func replace(queryDictionary: [String: String]) {
        self = replacing(queryDictionary: queryDictionary)
    }
    /**
     Returns a URL after removing all query parameters
     */
    public var removingQueryParameters: URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.queryItems = nil
        return components.url!
    }
    /**
     initialize new URL instance with a string and a query dictionary
     - parameter string: URL string
     - parameter queryDictionary: Dictionary to put the query parameters from
     */
    public init?(string: String, queryDictionary:[String:String]) {
        self.init(string:string)
        self.append(queryDictionary: queryDictionary)
    }
    /**
     Get or set a query parameter
     - parameter index: query key
     - returns: query value
     */
    public subscript(index: String) -> String? {
        get{
            return self.queryDictionary?[index]
        }set(newValue) {
            if let val = newValue {
                append(queryDictionary: [index:val])
            }else if var dict = queryDictionary {
                dict[index] = nil
                replace(queryDictionary: dict)
            }
        }
    }
}
