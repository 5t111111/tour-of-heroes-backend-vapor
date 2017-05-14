import Vapor
import HTTP

final class HeroController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Hero.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var hero = try request.post()
        try hero.save()
        return hero
    }

    func show(request: Request, hero: Hero) throws -> ResponseRepresentable {
        return hero
    }

    func delete(request: Request, hero: Hero) throws -> ResponseRepresentable {
        try hero.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try Hero.query().delete()
        return JSON([])
    }

    func update(request: Request, hero: Hero) throws -> ResponseRepresentable {
        let new = try request.post()
        var hero = hero
        hero.content = new.content
        try hero.save()
        return hero
    }

    func replace(request: Request, hero: Hero) throws -> ResponseRepresentable {
        try hero.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<Hero> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func post() throws -> Hero {
        guard let json = json else { throw Abort.badRequest }
        return try Hero(node: json)
    }
}
