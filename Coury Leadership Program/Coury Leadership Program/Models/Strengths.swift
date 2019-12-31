//
//  Strengths.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 6/11/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Strength: Named, CollectionableCellData {
    public var CorrespondingView: CollectionableCell.Type = StrengthCell.self
    
    let name: String
    let domain: Domain
    let description: String
    let url: String

    // CaseIterable conformance allows us to get the total number of domains (to determine number of sections in CollectionView
    public enum Domain: Int, CaseIterable {
        case executing = 0, influencing, relationship_building, strategic_thinking

        public func color() -> UIColor {
            switch self {
//            case .executing: return UIColor(red: 62/255.0, green: 11/255.0, blue: 66/255.0, alpha: 1.0)
//            case .influencing: return UIColor(red: 229/255.0, green: 124/255.0, blue: 35/255.0, alpha: 1.0)
//            case .relationship_building: return UIColor(red: 15/255.0, green: 54/255.0, blue: 95/255.0, alpha: 1.0)
//            case .strategic_thinking: return UIColor(red: 108/255.0, green: 2/255.0, blue: 33/255.0, alpha: 1.0)
            case .executing: return .systemPurple
            case .influencing: return .systemOrange
            case .relationship_building: return .systemBlue
            case .strategic_thinking: return .systemRed
            }
        }

        public func name() -> String {
            switch self {
            case .executing: return "Executing"
            case .influencing: return "Influencing"
            case .relationship_building: return "Relationship Building"
            case .strategic_thinking: return "Strategic Thinking"
            }
        }
    }
}

let STRENGTH_LIST: [Strength] = [
    Strength(name: "Achiever", domain: .executing, description: "People exceptionally talented in the Achiever theme work hard and possess a great deal of stamina. They take immense satisfaction in being busy and productive.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/622/achiever"),
    Strength(name: "Arranger", domain: .executing, description: "People exceptionally talented in the Arranger theme can organize, but they also have a flexibility that complements this ability. They like to determine how all of the pieces and resources can be arranged for maximum productivity.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/634/arranger"),
    Strength(name: "Belief", domain: .executing, description: "People exceptionally talented in the Belief theme have certain core values that are unchanging. Out of these values emerges a defined purpose for their lives.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/637/belief"),
    Strength(name: "Consistency", domain: .executing, description: "People exceptionally talented in the Consistency theme are keenly aware of the need to treat people the same. They try to treat everyone with equality by setting up clear rules and adhering to them.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/652/consistency"),
    Strength(name: "Deliberative", domain: .executing, description: "People exceptionally talented in the Deliberative theme are best described by the serious care they take in making decisions or choices. They anticipate obstacles.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/658/deliberative"),
    Strength(name: "Discipline", domain: .executing, description: "People exceptionally talented in the Discipline theme enjoy routine and structure. Their world is best described by the order they create.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/664/discipline"),
    Strength(name: "Focus", domain: .executing, description: "People exceptionally talented in the Focus theme can take a direction, follow through, and make the corrections necessary to stay on track. They prioritize, then act.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/670/focus"),
    Strength(name: "Responsibility", domain: .executing, description: "People exceptionally talented in the Responsibility theme take psychological ownership of what they say they will do. They are committed to stable values such as honesty and loyalty.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/706/responsibility"),
    Strength(name: "Restorative", domain: .executing, description: "People exceptionally talented in the Restorative theme are adept at dealing with problems. They are good at figuring out what is wrong and resolving it.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/709/restorative"),
    
    Strength(name: "Adaptability", domain: .relationship_building, description: "People exceptionally talented in the Adaptability theme prefer to go with the flow. They tend to be “now” people who take things as they come and discover the future one day at a time.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/628/adaptability"),
    Strength(name: "Connectedness", domain: .relationship_building, description: "People exceptionally talented in the Connectedness theme have faith in the links among all things. They believe there are few coincidences and that almost every event has meaning.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/649/connectedness"),
    Strength(name: "Developer", domain: .relationship_building, description: "People exceptionally talented in the Developer theme recognize and cultivate the potential in others. They spot the signs of each small improvement and derive satisfaction from evidence of progress.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/661/developer"),
    Strength(name: "Empathy", domain: .relationship_building, description: "People exceptionally talented in the Empathy theme can sense other people’s feelings by imagining themselves in others’ lives or situations.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/667/empathy"),
    Strength(name: "Harmony", domain: .relationship_building, description: "People exceptionally talented in the Harmony theme look for consensus. They don’t enjoy conflict; rather, they seek areas of agreement.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/676/harmony"),
    Strength(name: "Includer", domain: .relationship_building, description: "People exceptionally talented in the Includer theme accept others. They show awareness of those who feel left out and make an effort to include them.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/682/includer"),
    Strength(name: "Individualization", domain: .relationship_building, description: "People exceptionally talented in the Individualization theme are intrigued with the unique qualities of each person. They have a gift for figuring out how different people can work together productively.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/685/individualization"),
    Strength(name: "Positivity", domain: .relationship_building, description: "People especially talented in the Positivity theme have contagious enthusiasm. They are upbeat and can get others excited about what they are going to do.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/700/positivity"),
    Strength(name: "Relator", domain: .relationship_building, description: "People exceptionally talented in the Relator theme enjoy close relationships with others. They find deep satisfaction in working hard with friends to achieve a goal.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/703/relator"),

    Strength(name: "Activator", domain: .influencing, description: "People exceptionally talented in the Activator theme can make things happen by turning thoughts into action. They are often impatient.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/625/activator"),
    Strength(name: "Command", domain: .influencing, description: "People exceptionally talented in the Command theme have presence. They can take control of a situation and make decisions.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/640/command"),
    Strength(name: "Communication", domain: .influencing, description: "People exceptionally talented in the Communication theme generally find it easy to put their thoughts into words. They are good conversationalists and presenters.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/643/communication"),
    Strength(name: "Competition", domain: .influencing, description: "People exceptionally talented in the Competition theme measure their progress against the performance of others. They strive to win first place and revel in contests.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/646/competition"),
    Strength(name: "Maximizer", domain: .influencing, description: "People exceptionally talented in the Maximizer theme focus on strengths as a way to stimulate personal and group excellence. They seek to transform something strong into something superb.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/697/maximizer"),
    Strength(name: "Self-Assurance", domain: .influencing, description: "People exceptionally talented in the Self-Assurance theme feel confident in their ability to manage their own lives. They possess an inner compass that gives them confidence that their decisions are right.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/712/self-assurance"),
    Strength(name: "Significance", domain: .influencing, description: "People exceptionally talented in the Significance theme want to be very important in others’ eyes. They are independent and want to be recognized.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/715/significance"),
    Strength(name: "Woo", domain: .influencing, description: "People exceptionally talented in the Woo theme love the challenge of meeting new people and winning them over. They derive satisfaction from breaking the ice and making a connection with someone.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/721/woo"),

    Strength(name: "Analytical", domain: .strategic_thinking, description: "People exceptionally talented in the Analytical theme search for reasons and causes. They have the ability to think about all the factors that might affect a situation.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/631/analytical"),
    Strength(name: "Context", domain: .strategic_thinking, description: "People exceptionally talented in the Context theme enjoy thinking about the past. They understand the present by researching its history.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/655/context"),
    Strength(name: "Futuristic", domain: .strategic_thinking, description: "People exceptionally talented in the Futuristic theme are inspired by the future and what could be. They energize others with their visions of the future.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/673/futuristic"),
    Strength(name: "Ideation", domain: .strategic_thinking, description: "People exceptionally talented in the Ideation theme are fascinated by ideas. They are able to find connections between seemingly disparate phenomena.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/679/ideation"),
    Strength(name: "Input", domain: .strategic_thinking, description: "People exceptionally talented in the Input theme have a craving to know more. Often they like to collect and archive all kinds of information.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/688/input"),
    Strength(name: "Intellection", domain: .strategic_thinking, description: "People exceptionally talented in the Intellection theme are characterized by their intellectual activity. They are introspective and appreciate intellectual discussions.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/691/intellection"),
    Strength(name: "Learner", domain: .strategic_thinking, description: "People exceptionally talented in the Learner theme have a great desire to learn and want to continuously improve. The process of learning, rather than the outcome, excites them.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/694/learner"),
    Strength(name: "Strategic", domain: .strategic_thinking, description: "People exceptionally talented in the Strategic theme create alternative ways to proceed. Faced with any given scenario, they can quickly spot the relevant patterns and issues.", url: "https://www.gallupstrengthscenter.com/cms/en-us/gmj/718/strategic")
]
