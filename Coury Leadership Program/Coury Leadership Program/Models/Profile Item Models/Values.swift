//
//  Strength.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public struct Value: ProfilableData {
    let name: String
    let image: UIImage
    let motto: String
    let description: String

    public func shortName() -> String {return self.name.components(separatedBy: " ").prefix(3).joined(separator: " ")}

    public func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ValueCell.generateCellFor(collectionView, at: indexPath) as! ValueCell
        cell.value = self
        cell.valueName.text = shortName()
        cell.image.image = image
        return cell
    }
}

let VALUE_LIST: [Value] = [
    Value(name: "Curiosity", image: #imageLiteral(resourceName: "curiosity"), motto: "Ask questions, lots of them", description: """
    If Curiosity is your strength, you are interested in learning more about anything and everything. You are always asking questions, and you find all subjects and topics fascinating. You like exploration and discovery.
    """),
    Value(name: "Spirituality", image: #imageLiteral(resourceName: "spirituality"), motto: "Look for what is sacred in this moment", description: """
    If Spirituality is your strength you have strong and coherent beliefs about the higher purpose and meaning of the universe. You know where you fit in the larger scheme. Your beliefs shape your actions and are a source of comfort to you.
    """),
    Value(name: "Honesty", image: #imageLiteral(resourceName: "honesty"), motto: "Tell people the truth, (almost) all the time", description: """
    If Honesty is your strength, you are a straightforward person, not only by speaking the truth but by living your life in a genuine and authentic way. You are down to earth and without pretense; you are a "real" person.
    """),
    Value(name: "Leadership", image: #imageLiteral(resourceName: "leadership"), motto: "Organize activities for others", description: """
    If Leadership is your strength, you excel at encouraging a group to get things done and preserving harmony within the group by making everyone feel included. You do a good job organizing activities and seeing that they happen.
    """),
    Value(name: "Fairness", image: #imageLiteral(resourceName: "fairness"), motto: "Treat people the way you want to be treated", description: """
    If Fairness is your strength, treating people fairly is one of your abiding principles. You do not let your personal feelings bias your decisions about other people. You give everyone a chance.
    """),
    Value(name: "Kindness", image: #imageLiteral(resourceName: "kindness"), motto: "Be helpful, err toward caring", description: """
    If Kindness is your strength you are kind and generous to others, and you are never too busy to do a favor. You enjoy doing good deeds for others, even if you do not know them well.
    """),
    Value(name: "Forgiveness", image: #imageLiteral(resourceName: "forgiveness"), motto: "Let it go", description: """
    If Forgiveness is your strength, you are good at forgiving those who have done you wrong. You always give people a second chance. You believe in mercy, and not revenge.
    """),
    Value(name: "Humility", image: #imageLiteral(resourceName: "humility"), motto: "Place attention on others", description: """
    If Humility is your strength, you do not seek the spotlight, preferring to let your accomplishments speak for themselves. You do not regard yourself as special, and others recognize and value your modesty.
    """),
    Value(name: "Gratitude", image: #imageLiteral(resourceName: "gratitude"), motto: "Tell people 'thank you,' often", description: """
    If Gratitude is your strength you are aware of the good things that happen to you, and you never take them for granted. Your friends and family members know that you are a grateful person because you always take the time to express thanks.
    """),
    Value(name: "Appreciation of Beauty and Excellence", image: #imageLiteral(resourceName: "appreciation-of-beauty"), motto: "Find beauty in nature, art, ideas, and people", description: """
    If Appreciation of Beauty and Excellence is your strength you notice and appreciate beauty, excellence, and/or skilled performance in all domains of life, from nature to art to mathematics to science to everyday experience.
    """),
    Value(name: "Judgement", image: #imageLiteral(resourceName: "judgment"), motto: "Examine the details", description: """
    If Judgment is your strength, thinking things through and examining them from all sides are important aspects of who you are. You do not jump to conclusions, and you rely only on solid evidence to make your decisions. You are able to change your mind.
    """),
    Value(name: "Creativity", image: #imageLiteral(resourceName: "creativity"), motto: "Do things in a different way", description: """
    If Creativity is your strength, thinking of new ways to do things is a crucial part of who you are. You are never content with doing something the conventional way if a better way is possible.
    """),
    Value(name: "Humor", image: #imageLiteral(resourceName: "humor"), motto: "Laugh a lot, with others", description: """
    If Humor is your strength you like to laugh and tease. Bringing smiles to other people is important to you. You try to see the light side of all situations.
    """),
    Value(name: "Prudence", image: #imageLiteral(resourceName: "prudence"), motto: "Think before you act", description: """
    If Prudence is your strength, you are a careful person, and your choices are consistently prudent ones. You do not say or do things that you might later regret.
    """),
    Value(name: "Bravery", image: #imageLiteral(resourceName: "bravery"), motto: "Face what you are afraid of", description: """
    If Bravery is your strength, you are a courageous person who does not shrink from threat, challenge, difficulty, or pain. You speak up for what is right even if there is opposition. You act on your convictions.
    """),
    Value(name: "Perspective", image: #imageLiteral(resourceName: "perspective"), motto: "Offer good advice", description: """
    If Perspective is your strength, you have a way of looking at the world that makes sense to others and to yourself. Although you may not think of yourself as wise, your friends hold this view of you. They value your perspective on matters and turn to you for advice.
    """),
    Value(name: "Social Intelligence", image: #imageLiteral(resourceName: "social-intelligence"), motto: "Be friendly", description: """
    If Social Intelligence is your strength, you are aware of the motives and feelings of other people. You know what to do to fit in to different social situations, and you know what to do to put others at ease.
    """),
    Value(name: "Zest", image: #imageLiteral(resourceName: "zest"), motto: "When in doubt, take action", description: """
    If Zest is your strength, you approach all experiences with excitement and energy. You never do anything halfway or halfheartedly. For you, life is an adventure.
    """),
    Value(name: "Perseverance", image: #imageLiteral(resourceName: "perseverance"), motto: "Don't give up", description: """
    If Perseverance is your strength, you work hard to finish what you start. No matter the project, you "get it out the door" in timely fashion. You do not get distracted when you work, and you take satisfaction in completing tasks.
    """),
    Value(name: "Love", image: #imageLiteral(resourceName: "love"), motto: "Be a warm and strong listener", description: """
    If Love is your strength you value close relations with others, in particular those in which sharing and caring are reciprocated. The people to whom you feel most close are the same people who feel most close to you.
    """),
    Value(name: "Self Regulation", image: #imageLiteral(resourceName: "self-regulation"), motto: "Manage your feelings", description: """
    If Self-Regulation is your strength, you self-consciously regulate what you feel and what you do. You are a disciplined person. You are in control of your appetites and your emotions, not vice versa.
    """),
    Value(name: "Love of Learning", image: #imageLiteral(resourceName: "love-of-learning"), motto: "Learn something from every situation", description: """
    If Love of Learning is your strength, you love learning new things, whether in a class or on your own. You have always loved school, reading, and museums-anywhere and everywhere there is an opportunity to learn.
    """),
    Value(name: "Hope", image: #imageLiteral(resourceName: "hope"), motto: "Be positive, especially when others are not", description: """
    If Hope is your strength you expect the best in the future, and you work to achieve it. You believe that the future is something that you can control.
    """),
    Value(name: "Teamwork", image: #imageLiteral(resourceName: "teamwork"), motto: "Work side-by-side with others", description: """
    If Teamwork is your strength, you excel as a member of a group. You are a loyal and dedicated teammate, you always do your share, and you work hard for the success of your group.
    """)
]

let CURIOSITY_LIBRARY = [
"What are you most curious about? Were you a curious child and adolescent?",
"How has your curiosity been affected growing up? If it has changed over time, why is that?",
"How does curiosity play out across the different domains of your life – family, socializing, work, school?",
"Try a new food or going to a new restaurant to explore different foods and places",
"Drive a different route home to explore a new area near where you live",
"Do an online search for community activities going on around you and take notice of what piques your curiosity most",
"Consider an activity you dislike. Pay attention to 3 novel features of this activity while you do it",
"Practice active curiosity and explore your current environment, paying attention to anything you may often ignore or take for granted",
"Try asking “why?” more often on your team or with your subordinates and supervisors to express more curiosity at work. Don’t take what you’re told at face value if it doesn’t make complete sense to you",
]

//TODO add all value libraries from via website


let CREATIVITY_LIBRARY = [
"What holds you back from trying to be creative?",
"How do real or anticipated reactions of other people affect your creative efforts?",
"How do you use creativity to help solve your own life problems or those of your family, friends, and colleagues?",
"Explore a creative solution to a life difficulty or challenge that’s expressed by a family member or a friend",
"At a work meeting, when a new topic comes up, brainstorm several ideas with the group to reflect on or discuss together",
"Write an article, essay, short story, or poem, make a drawing or painting, and share it with others",
"When facing a problem, define the issue clearly and then practice divergent thinking",
"Set time aside each day for creative thinking or creative activities",
"With one of your typical work tasks, think of a new and unique way to complete it"
]
