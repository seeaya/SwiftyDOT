//
//  File.swift
//  
//
//  Created by Connor Barnes on 11/5/21.
//

import Foundation

public struct NodeAttributes: Hashable {
	public var color: DOTColor?
	public var fontColor: DOTColor?
	public var label: String?
	public var peripheries: Int?
	public var style: NodeStyle?
}

public struct EdgeAttributes: Hashable {
	public var color: DOTColor?
	public var fontColor: DOTColor?
	public var label: String?
	public var style: EdgeStyle?
}

public enum EdgeStyle: String, Hashable {
	case dashed
	case dotted
	case solid
	case invis
	case bold
	case tapered
}

public enum NodeStyle: String, Hashable {
	case dashed
	case dotted
	case solid
	case invis
	case bold
	case filled
	case striped
	case wedged
	case diagonals
	case rounded
}

public enum EdgeDirection: String, Hashable {
	case forward
	case back
	case both
	case none
}

public enum NodeShape: String, Hashable {
	case box
	case polygon
	case ellipse
	case oval
	case circle
	case point
	case egg
	case triangle
	case plaintext
	case plain
	case diamond
	case trapezium
	case parallelogram
	case house
	case pentagon
	case hexagon
	case septagon
	case octagon
	case doublecircle
	case doubleoctagon
	case tripleoctagon
	case invtriangle
	case invtrapezium
	case invhouse
	case Mdiamond
	case Msquare
	case Mcircle
	case rect
	case rectangle
	case square
	case star
	case none
	case underline
	case cylinder
	case note
	case tab
	case folder
	case box3d
	case component
	case promoter
	case cds
	case terminator
	case utr
	case primersite
	case restrictionsite
	case fivepoverhang
	case threepoverhang
	case noverhang
	case assembly
	case signature
	case insulator
	case ribosite
	case rnastab
	case proteasesite
	case proteinstab
	case rpromoter
	case rarrow
	case larrow
	case lpromoter
}

public enum DOTColor: String, Hashable {
	case aliceblue
	case antiquewhite
	case aqua
	case aquamarine
	case azure
	case beige
	case bisque
	case black
	case blanchedalmond
	case blue
	case blueviolet
	case brown
	case burlywood
	case cadetblue
	case chartreuse
	case chocolate
	case coral
	case cornflowerblue
	case cornsilk
	case crimson
	case cyan
	case darkblue
	case darkcyan
	case darkgoldenrod
	case darkgray
	case darkgreen
	case darkgrey
	case darkkhaki
	case darkmagenta
	case darkolivegreen
	case darkorange
	case darkorchid
	case darkred
	case darksalmon
	case darkseagreen
	case darkslateblue
	case darkslategray
	case darkslategrey
	case darkturquoise
	case darkviolet
	case deeppink
	case deepskyblue
	case dimgray
	case dimgrey
	case dodgerblue
	case firebrick
	case floralwhite
	case forestgreen
	case fuchsia
	case gainsboro
	case ghostwhite
	case gold
	case goldenrod
	case gray
	case grey
	case green
	case greenyellow
	case honeydew
	case hotpink
	case indianred
	case indigo
	case ivory
	case khaki
	case lavender
	case lavenderblush
	case lawngreen
	case lemonchiffon
	case lightblue
	case lightcoral
	case lightcyan
	case lightgoldenrodyellow
	case lightgray
	case lightgreen
	case lightgrey
	case lightpink
	case lightsalmon
	case lightseagreen
	case lightskyblue
	case lightslategray
	case lightslategrey
	case lightsteelblue
	case lightyellow
	case lime
	case limegreen
	case linen
	case magenta
	case maroon
	case mediumaquamarine
	case mediumblue
	case mediumorchid
	case mediumpurple
	case mediumseagreen
	case mediumslateblue
	case mediumspringgreen
	case mediumturquoise
	case mediumvioletred
	case midnightblue
	case mintcream
	case mistyrose
	case moccasin
	case navajowhite
	case navy
	case oldlace
	case olive
	case olivedrab
	case orange
	case orangered
	case orchid
	case palegoldenrod
	case palegreen
	case paleturquoise
	case palevioletred
	case papayawhip
	case peachpuff
	case peru
	case pink
	case plum
	case powderblue
	case purple
	case red
	case rosybrown
	case royalblue
	case saddlebrown
	case salmon
	case sandybrown
	case seagreen
	case seashell
	case sienna
	case silver
	case skyblue
	case slateblue
	case slategray
	case slategrey
	case snow
	case springgreen
	case steelblue
	case tan
	case teal
	case thistle
	case tomato
	case turquoise
	case violet
	case wheat
	case white
	case whitesmoke
	case yellow
	case yellowgreen
}
