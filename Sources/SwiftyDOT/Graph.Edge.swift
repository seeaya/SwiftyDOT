//
//  File.swift
//  
//
//  Created by Connor Barnes on 11/4/21.
//

import Foundation

extension Graph {
	public struct DirectedEdge: Hashable {
		public let source: Node
		public let destination: Node
		public internal(set) var value: EdgeValue
	}
	
	public struct UndirectedEdge: Hashable {
		public let first: Node
		public let second: Node
		public internal(set) var value: EdgeValue
		public var attributes = EdgeAttributes()
		
		public static func ==(lhs: Self, rhs: Self) -> Bool {
			lhs.value == rhs.value && ((lhs.first == rhs.first && lhs.first == rhs.first)
																 || lhs.first == rhs.second && lhs.second == rhs.first)
		}
		
		public func hash(into hasher: inout Hasher) {
			if first.id.hashValue < second.id.hashValue {
				hasher.combine(first)
				hasher.combine(second)
			} else {
				hasher.combine(second)
				hasher.combine(first)
			}
			
			hasher.combine(value)
		}
	}
	
	public struct PartialEdge: Hashable {
		public let other: Node
		public internal(set) var value: EdgeValue
	}
}

