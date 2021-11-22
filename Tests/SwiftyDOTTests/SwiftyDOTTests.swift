import XCTest
@testable import SwiftyDOT

final class SwiftyDOTTests: XCTestCase {
	func testExample() throws {
		let g = Graph<String, String?>()
		let a = g.insertNode(value: "a")
		let b = g.insertNode(value: "b")
		let c = g.insertNode(value: "c")
		let d = g.insertNode(value: "d")
		let e = g.insertNode(value: "e")
		
		g.nodes.forEach { g.insertDirectedEdge(from: $0, to: e, value: nil) }
		
		e.incomingEdges.forEach {
			$0.attributes.color = .green
		}
		
		g.insertDirectedEdge(from: a, to: b, value: nil)
		g.insertDirectedEdge(from: a, to: c, value: nil)
		g.insertDirectedEdge(from: c, to: d, value: nil)
		let cb = g.insertUndirectedEdge(between: c, and: b, value: "edge")
		
		a.attributes.peripheries = 2
		b.attributes.style = .filled
		b.attributes.color = .blue
		d.attributes.shape = .diamond
		cb.attributes.color = .red
		
		let bd = Graph.DirectedEdge(source: b, destination: d, value: "A")
		bd.attributes.style = .dashed
		
		g.insertDirectedEdge(bd)
		
		let dot = g.toDOT { nodeValue in
			nodeValue
		} labelForEdgeValue: { edgeValue in
			edgeValue ?? ""
		}

		print(dot)
		
	}
	
	func testTree() {
		let g = Graph<String, String?>()
		let root = g.insertNode(value: "Root")
		
		func addChildren(node: Graph<String, String?>.Node, levels: Int, number: Int) {
			guard levels > 0 else { return }
			for index in 0..<number {
				let child = g.insertNode(value: "\(index + 1)")
				g.insertDirectedEdge(from: node, to: child, value: nil)
				addChildren(node: child, levels: levels - 1, number: number)
			}
		}
		
		addChildren(node: root, levels: 4, number: 4)
		
		let dot = g.toDOT { nodeValue in
			nodeValue
		} labelForEdgeValue: { edgeValue in
			edgeValue ?? ""
		}
		
		print(dot)
	}
}
