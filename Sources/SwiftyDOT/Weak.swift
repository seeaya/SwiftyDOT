//
//  File.swift
//  
//
//  Created by Connor Barnes on 11/4/21.
//

import Foundation

final class Weak<T: AnyObject> {
	weak var value: T?
}

extension Weak: Equatable where T: Equatable {
	static func ==(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
		return lhs.value == rhs.value
	}
}

extension Weak: Hashable where T: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}
}
