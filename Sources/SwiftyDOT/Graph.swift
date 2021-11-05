//
//  File.swift
//  
//
//  Created by Connor Barnes on 11/4/21.
//

import Foundation

public final class Graph<NodeValue: Hashable, EdgeValue: Hashable> {
	public internal(set) var nodes: Set<Node> = []
	public internal(set) var directedEdges: Set<DirectedEdge> = []
	public internal(set) var undirectedEdges: Set<UndirectedEdge> = []
	
	public var nodeAttributes: [Node : NodeAttributes] = [:]
	public var directedEdgeAttributes: [DirectedEdge : EdgeAttributes] = [:]
	public var undirectedEdgeAttributes: [UndirectedEdge : EdgeAttributes] = [:]
	
	public init() {
		
	}
}

// MARK: Insertion
extension Graph {
	@discardableResult
	public func insertNode(value: NodeValue) -> Node {
		return Node(value: value, in: self)
	}
	
	@discardableResult
	public func insertUndirectedEdge(
		between first: Node,
		and second: Node,
		value: EdgeValue
	) -> UndirectedEdge {
		guard first.graph === self && second.graph === self else {
			fatalError("Trying to add edge between nodes not in this graph")
		}
		let edge = UndirectedEdge(first: first, second: second, value: value)
		undirectedEdges.insert(edge)
		first.undirectedEdges.insert(PartialEdge(other: second, value: value))
		second.undirectedEdges.insert(PartialEdge(other: first, value: value))
		undirectedEdgeAttributes[edge] = EdgeAttributes()
		return edge
	}
	
	@discardableResult
	public func insertUndirectedEdge(_ edge: UndirectedEdge) -> UndirectedEdge {
		return insertUndirectedEdge(between: edge.first, and: edge.second, value: edge.value)
	}
	
	@discardableResult
	public func insertDirectedEdge(
		from source: Node,
		to destination: Node,
		value: EdgeValue
	) -> DirectedEdge {
		guard source.graph === self && destination.graph === self else {
			fatalError("Trying to add edge between nodes not in this graph")
		}
		let edge = DirectedEdge(source: source, destination: destination, value: value)
		directedEdges.insert(edge)
		source.outgoingEdges.insert(PartialEdge(other: destination, value: value))
		destination.incomingEdges.insert(PartialEdge(other: source, value: value))
		directedEdgeAttributes[edge] = EdgeAttributes()
		return edge
	}
	
	@discardableResult
	public func insertDirectedEdge(_ edge: DirectedEdge) -> DirectedEdge {
		return insertDirectedEdge(from: edge.source, to: edge.destination, value: edge.value)
	}
}

// MARK: Removal
extension Graph {
	public func removeNode(_ node: Node) {
		guard node.graph === self else { return }
		node.graph = nil
		for edge in node.undirectedEdges {
			removeUndirectedEdge(UndirectedEdge(first: node, second: edge.other, value: edge.value))
		}
		
		for edge in node.outgoingEdges {
			removeDirectedEdge(DirectedEdge(source: node, destination: edge.other, value: edge.value))
		}
		
		for edge in node.incomingEdges {
			removeDirectedEdge(DirectedEdge(source: edge.other, destination: node, value: edge.value))
		}
	}
	
	public func removeUndirectedEdge(_ edge: UndirectedEdge) {
		guard edge.first.graph === self && edge.second.graph === self else { return }
		undirectedEdges.remove(edge)
		edge.first.undirectedEdges.remove(PartialEdge(other: edge.second, value: edge.value))
		edge.second.undirectedEdges.remove(PartialEdge(other: edge.first, value: edge.value))
	}
	
	public func removeUndirectedEdge(between first: Node, and second: Node, value: EdgeValue) {
		removeUndirectedEdge(UndirectedEdge(first: first, second: second, value: value))
	}
	
	public func removeUndirectedEdges(between first: Node, and second: Node) {
		first.undirectedEdges
			.filter { $0.other == second }
			.map { UndirectedEdge(first: first, second: $0.other, value: $0.value) }
			.forEach { removeUndirectedEdge($0) }
	}
	
	public func removeDirectedEdge(_ edge: DirectedEdge) {
		guard edge.source.graph === self && edge.destination.graph === self else { return }
		directedEdges.remove(edge)
		edge.source.outgoingEdges.remove(PartialEdge(other: edge.destination, value: edge.value))
		edge.destination.incomingEdges.remove(PartialEdge(other: edge.source, value: edge.value))
	}
	
	public func removeDirectedEdge(from source: Node, to destination: Node, value: EdgeValue) {
		removeDirectedEdge(DirectedEdge(source: source, destination: destination, value: value))
	}
	
	public func removeDirectedEdges(from source: Node, to destination: Node) {
		source.outgoingEdges
			.filter { $0.other == destination }
			.map { DirectedEdge(source: source, destination: $0.other, value: $0.value) }
			.forEach { removeDirectedEdge($0) }
	}
	
	public func removeDirectedEdges(between first: Node, and second: Node) {
		removeDirectedEdges(from: first, to: second)
		removeDirectedEdges(from: second, to: first)
	}
	
	public func removeAllEdges(between first: Node, and second: Node) {
		removeUndirectedEdges(between: first, and: second)
		removeDirectedEdges(between: first, and: second)
	}
}

// MARK: DOT
extension Graph {
	public func toDOT(
		labelForNodeValue: (NodeValue) -> String,
		labelForEdgeValue: (EdgeValue) -> String
	) -> String {
		var dot = "digraph D {\n"
		
		func attributeString(forAttribute attribute: String, value: Any?) -> String {
			if let value = value {
				return " \(attribute)=\"\(value)\""
			} else {
				return ""
			}
		}
		
		for node in nodes {
			let label = node.attributes.label ?? labelForNodeValue(node.value)
			
			let color = attributeString(forAttribute: "color",
																	value: node.attributes.color?.rawValue)
			let fontColor = attributeString(forAttribute: "fontColor",
																			value: node.attributes.fontColor?.rawValue)
			let peripheries = attributeString(forAttribute: "peripheries",
																				value: node.attributes.peripheries)
			let style = attributeString(forAttribute: "style",
																	value: node.attributes.style?.rawValue)
			
			let attributes = [color, fontColor, peripheries, style].joined(separator: "")
			
			dot += "    \(node.dotID) [label=\"\(label)\"\(attributes)]\n"
		}
		
		for edge in directedEdges {
			let label = directedEdgeAttributes[edge]?.label ?? labelForEdgeValue(edge.value)
			
			let color = attributeString(forAttribute: "color",
																	value: directedEdgeAttributes[edge]?.color?.rawValue)
			let fontColor = attributeString(forAttribute: "fontColor",
																			value: directedEdgeAttributes[edge]?.fontColor?.rawValue)
			let style = attributeString(forAttribute: "style",
																	value: directedEdgeAttributes[edge]?.style?.rawValue)
			
			let attributes = [color, fontColor, style].joined(separator: "")
			
			dot += "    \(edge.source.dotID) -> \(edge.destination.dotID) [label=\"\(label)\"\(attributes)]\n"
		}
		
		for edge in undirectedEdges {
			let label = undirectedEdgeAttributes[edge]?.label ?? labelForEdgeValue(edge.value)
			
			let color = attributeString(forAttribute: "color", value: undirectedEdgeAttributes[edge]?.color?.rawValue)
			let fontColor = attributeString(forAttribute: "fontColor", value: undirectedEdgeAttributes[edge]?.fontColor?.rawValue)
			let style = attributeString(forAttribute: "style", value: undirectedEdgeAttributes[edge]?.style?.rawValue)
			let edgeDirection = attributeString(forAttribute: "dir", value: EdgeDirection.none)
			
			let attributes = [color, fontColor, style, edgeDirection].joined(separator: "")
			
			dot += "    \(edge.first.dotID) -> \(edge.second.dotID) [label=\"\(label)\"\(attributes)]\n"
		}
		
		dot += "}"
		return dot
	}
}
