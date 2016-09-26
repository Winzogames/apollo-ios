import Apollo

public class HeroDetailsFragmentQuery: GraphQLQuery {
  let episode: Episode?
  
  public init(episode: Episode? = nil) {
    self.episode = episode
  }
  
  public static let operationDefinition =
    "query HeroDetailsFragmentQuery($episode: Episode) {" +
    "  hero(episode: $episode) {" +
    "    ...HeroDetails" +
    "  }" +
    "}"
  
  public static let queryDocument = operationDefinition.appending(HeroDetailsFragment.fragmentDefinition)
  
  public var variables: GraphQLMap? {
    return ["episode": episode]
  }
  
  public struct Data: GraphQLMapConvertible {
    public let hero: HeroDetails
    
    public init(map: GraphQLMap) throws {
      hero = try map.value(forKey: "hero", possibleTypes: ["Human": Hero_Human.self, "Droid": Hero_Droid.self])
    }
    
    public struct Hero_Human: HeroDetails_Human, GraphQLMapConvertible {
      public let name: String
      public let appearsIn: [Episode]?
      public let homePlanet: String?
      
      public init(map: GraphQLMap) throws {
        name = try map.value(forKey: "name")
        appearsIn = try map.optionalList(forKey: "appearsIn")
        homePlanet = try map.optionalValue(forKey: "homePlanet")
      }
    }
    
    public struct Hero_Droid: HeroDetails_Droid, GraphQLMapConvertible {
      public let name: String
      public let appearsIn: [Episode]?
      public let primaryFunction: String?
      
      public init(map: GraphQLMap) throws {
        name = try map.value(forKey: "name")
        appearsIn = try map.optionalList(forKey: "appearsIn")
        primaryFunction = try map.optionalValue(forKey: "primaryFunction")
      }
    }
  }
}
