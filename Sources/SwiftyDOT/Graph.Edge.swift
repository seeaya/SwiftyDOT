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
		
		@Reference var _attributes = EdgeAttributes()
		weak var _graph: Graph?
		
		public init(source: Node, destination: Node, value: EdgeValue) {
			guard source.graph === destination.graph && source.graph != nil else {
				fatalError("Trying to create edge between two nodes not in the same graph")
			}
			_graph = source.graph
			self.source = source
			self.destination = destination
			self.value = value
		}
		
		public static func ==(lhs: DirectedEdge, rhs: DirectedEdge) -> Bool {
			lhs.source == rhs.source && lhs.destination == rhs.destination && lhs.value == rhs.value
		}
		
		public func hash(into hasher: inout Hasher) {
			hasher.combine(source)
			hasher.combine(destination)
			hasher.combine(value)
		}
		
		public var attributes: EdgeAttributes {
			get {
				return _graph?.directedEdgeAttributes[self] ?? _attributes
			}
			nonmutating set {
				_graph?.directedEdgeAttributes[self] = newValue
				_attributes = newValue
			}
		}
	}
	
	public struct UndirectedEdge: Hashable {
		public let first: Node
		public let second: Node
		public internal(set) var value: EdgeValue
		
		@Reference var _attributes = EdgeAttributes()
		weak var _graph: Graph?
		
		public init(first: Node, second: Node, value: EdgeValue) {
			guard first.graph === second.graph && first.graph != nil else {
				fatalError("Trying to create edge between two nodes not in the same graph")
			}
			_graph = first.graph
			self.first = first
			self.second = second
			self.value = value
		}
		
		public var attributes: EdgeAttributes {
			get {
				return _graph?.undirectedEdgeAttributes[self] ?? _attributes
			}
			nonmutating set {
				_graph?.undirectedEdgeAttributes[self] = newValue
				_attributes = newValue
			}
		}
		
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
		
		@Reference var _attributes = EdgeAttributes()
		var _primary: Node
		var _incoming: Bool?
		weak var _graph: Graph?
		
		init(primary: Node, other: Node, value: EdgeValue, incoming: Bool?) {
			guard primary.graph === other.graph && primary.graph != nil else {
				fatalError("Trying to create edge between two nodes not in the same graph")
			}
			_graph = primary.graph
			_primary = primary
			_incoming = incoming
			self.other = other
			self.value = value
		}
		
		public static func ==(lhs: Self, rhs: Self) -> Bool {
			if let lhsIncoming = lhs._incoming, let rhsIncoming = rhs._incoming {
				let lhsEdge: DirectedEdge = {
					if lhsIncoming {
						return DirectedEdge(source: lhs._primary, destination: lhs.other, value: lhs.value)
					} else {
						return DirectedEdge(source: lhs.other, destination: lhs._primary, value: lhs.value)
					}
				}()
				
				let rhsEdge: DirectedEdge = {
					if rhsIncoming {
						return DirectedEdge(source: rhs._primary, destination: rhs.other, value: rhs.value)
					} else {
						return DirectedEdge(source: rhs.other, destination: rhs._primary, value: rhs.value)
					}
				}()
				
				return lhsEdge == rhsEdge
			} else {
				if lhs._incoming != nil || rhs._incoming != nil { return false }
				let lhsEdge = UndirectedEdge(first: lhs._primary, second: lhs.other, value: lhs.value)
				let rhsEdge = UndirectedEdge(first: rhs._primary, second: rhs.other, value: rhs.value)
				return lhsEdge == rhsEdge
			}
		}
		
		public func hash(into hasher: inout Hasher) {
			switch _incoming {
			case .none:
				hasher.combine(UndirectedEdge(first: _primary, second: other, value: value))
			case .some(true):
				hasher.combine(DirectedEdge(source: _primary, destination: other, value: value))
			case .some(false):
				hasher.combine(DirectedEdge(source: other, destination: _primary, value: value))
			}
		}
		
		public var attributes: EdgeAttributes {
			get {
				switch _incoming {
				case .none:
					let edge = UndirectedEdge(first: _primary, second: other, value: value)
					return _graph?.undirectedEdgeAttributes[edge] ?? _attributes
				case .some(true):
					let edge = DirectedEdge(source: _primary, destination: other, value: value)
					return _graph?.directedEdgeAttributes[edge] ?? _attributes
				case .some(false):
					let edge = DirectedEdge(source: other, destination: _primary, value: value)
					return _graph?.directedEdgeAttributes[edge] ?? _attributes
				}
			}
			nonmutating set {
				switch _incoming {
				case .none:
					let edge = UndirectedEdge(first: _primary, second: other, value: value)
					_graph?.undirectedEdgeAttributes[edge] = newValue
				case .some(true):
					let edge = DirectedEdge(source: _primary, destination: other, value: value)
					_graph?.directedEdgeAttributes[edge] = newValue
				case .some(false):
					let edge = DirectedEdge(source: other, destination: _primary, value: value)
					_graph?.directedEdgeAttributes[edge] = newValue
				}
				_attributes = newValue
			}
		}
	}
}

