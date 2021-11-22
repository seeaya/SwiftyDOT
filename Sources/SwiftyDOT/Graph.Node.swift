//
//  File.swift
//  
//
//  Created by Connor Barnes on 11/4/21.
//

import Foundation

extension Graph {
	public final class Node {
		public var value: NodeValue
		public let id = UUID()
		public internal(set) var graph: Graph!
		public var attributes: NodeAttributes! {
			get {
				guard let graph = graph else { return nil }
				if graph.nodeAttributes.keys.contains(self) {
					return graph.nodeAttributes[self]
				} else {
					graph.nodeAttributes[self] = NodeAttributes()
					return graph.nodeAttributes[self]
				}
			}
			set {
				guard let graph = graph else { return }
				graph.nodeAttributes[self] = newValue
			}
		}
		
		var dotID: String {
			"_" + id.uuidString.filter { $0.isLetter || $0.isNumber }
		}
		
		public internal(set) var undirectedEdges: Set<PartialEdge> = []
		public internal(set) var incomingEdges: Set<PartialEdge> = []
		public internal(set) var outgoingEdges: Set<PartialEdge> = []
		
		public init(value: NodeValue, in graph: Graph) {
			self.value = value
			self.graph = graph
			graph.nodes.insert(self)
		}
	}
}

// MARK: Hashable
extension Graph.Node: Hashable {
	public static func ==(lhs: Graph<NodeValue, EdgeValue>.Node, rhs: Graph<NodeValue, EdgeValue>.Node) -> Bool {
		lhs.id == rhs.id
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

// MARK: Node Insertion
extension Graph.Node {
	@discardableResult
	public func insertUndirectedEdge(between node: Graph.Node, value: EdgeValue) -> Graph.UndirectedEdge {
		return graph.insertUndirectedEdge(between: self, and: node, value: value)
	}
}
