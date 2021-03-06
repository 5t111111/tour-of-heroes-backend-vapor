import Vapor
import VaporMySQL

let drop = Droplet()

drop.preparations.append(Hero.self)
try drop.addProvider(VaporMySQL.Provider.self)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.resource("heroes", HeroController())

drop.run()
