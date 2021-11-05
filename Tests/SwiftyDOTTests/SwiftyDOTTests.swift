import XCTest
@testable import SwiftyDOT

final class SwiftyDOTTests: XCTestCase {
	func testExample() throws {
		let g = Graph<String, String?>()
		let a = g.insertNode(value: "a")
		let b = g.insertNode(value: "b")
		let c = g.insertNode(value: "c")
		let d = g.insertNode(value: "d")
		
		g.insertDirectedEdge(from: a, to: b, value: nil)
		g.insertDirectedEdge(from: a, to: c, value: nil)
		g.insertDirectedEdge(from: c, to: d, value: nil)
		let cb = g.insertUndirectedEdge(between: c, and: b, value: "edge")
		
		a.attributes.peripheries = 2
		b.attributes.style = .filled
		
		b.attributes.color = .blue
		
		g.undirectedEdgeAttributes[cb]?.color = .red
		
		let dot = g.toDOT { nodeValue in
			nodeValue
		} labelForEdgeValue: { edgeValue in
			edgeValue ?? ""
		}

		print(dot)
		
	}
}
