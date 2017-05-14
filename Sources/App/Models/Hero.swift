import Vapor
import Fluent
import Foundation

final class Hero: Model {
    var id: Node?
    var content: String
    
    init(content: String) {
        self.id = UUID().uuidString.makeNode()
        self.content = content
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        content = try node.extract("content")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "content": content
        ])
    }
}

extension Hero {
    /**
        This will automatically fetch from database, using example here to load
        automatically for example. Remove on real models.
    */
    public convenience init?(from string: String) throws {
        self.init(content: string)
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
