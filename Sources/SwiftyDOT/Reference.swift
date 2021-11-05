//
//  File.swift
//  
//
//  Created by Connor Barnes on 11/5/21.
//

import Foundation

@propertyWrapper
struct Reference<T> {
	private final class Box {
		var value: T
		
		init(_ value: T) {
			self.value = value
		}
	}
	
	private var box: Box
	
	var wrappedValue: T {
		get {
			box.value
		}
		nonmutating set {
			box.value = newValue
		}
	}
	
	init(wrappedValue: T) {
		box = Box(wrappedValue)
	}
}

extension Reference: Equatable where T: Equatable {
	static func == (lhs: Reference<T>, rhs: Reference<T>) -> Bool {
		lhs.box.value == rhs.box.value
	}
}

extension Reference: Hashable where T: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(box.value)
	}
}
