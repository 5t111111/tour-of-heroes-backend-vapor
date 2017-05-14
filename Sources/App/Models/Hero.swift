import Vapor
import Fluent
import Foundation

final class Hero: Model {
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

extension Hero {
    /**
        This will automatically fetch from database, using example here to load
        automatically for example. Remove on real models.
    */
    public convenience init?(from string: String) throws {
        self.init(name: string)
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
