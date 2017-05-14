import Vapor
import Fluent
import Foundation

final class Hero: Model {
    static let entity = "heroes"

    var id: Node?
    var name: String
    
    init(name: String) {
        self.id = UUID().uuidString.makeNode()
        self.name = name
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
        ])
    }
}

extension Hero: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("heroes") { users in
            users.id()
            users.string("name")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("heroes")
    }
}
