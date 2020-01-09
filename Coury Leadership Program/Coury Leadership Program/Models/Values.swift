//
//  Strength.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation
import Firebase

public struct Value: Named, CollectionableCellData {
    public var CorrespondingView: CollectionableCell.Type = ValueCell.self
    
    let name: String
    let image: UIImage
    let motto: String
    let description: String

    public var shortName: String {return name.components(separatedBy: " ").prefix(3).joined(separator: " ")}
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
    Value(name: "Judgment", image: #imageLiteral(resourceName: "judgment"), motto: "Examine the details", description: """
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

let VALUE_RECS: [String : [String]] = [
    "Appreciation of Beauty and Excellence" : [
        "Under what conditions (people, places, activities) are you most appreciative of beauty and excellence?",
        "How does appreciation of beauty or appreciation of excellence affect your work, relationships, use of leisure time, and community involvement?",
        "To what extent do you appreciate beauty versus appreciating excellence?",
        "Observe one tree branch, root, flower, or leaf and see the fullness of life in it",
        "Notice the good feelings in seeing someone give a donation to support a good cause",
        "See the excellence in a child learning to play baseball and slowly building his or her skill",
        "Keep a ‘beauty log.’ When you believe you are seeing something beautiful-whether it is from nature, is human-made (e.g.,artwork) or is the virtuous behavior of others-write it down. Describe the beauty in a few sentences",
        "Get regular exposure to green space in your environment, especially if you live or work in an urban setting",
        "Pause to appreciate your inner beauty. One way to do this is to see your character strengths and recall how you have used them to bring benefit to others"
    ],
    "Bravery" : [
        "How is your bravery expressed, for example, by taking physical risks, supporting unpopular positions, being emotionally vulnerable, or thinking unconventionally?",
        "How does bravery cause people to admire you?",
        "How does bravery exclude you from certain experiences or opportunities?",
        "Stand up for someone who is being bullied",
        "Take on more responsibiltiy with a project, or begin a new project that involves a difficult challenge for you",
        "Tap into your personal bravery by attending something you are afraid of",
        "Speak up at a community meeting or write about an unpopular idea on social media",
        "Think of brave role models in your community in order to be inspired and to resist peer pressure"
    ],
    "Creativity" : [
        "What holds you back from trying to be creative?",
        "How do real or anticipated reactions of other people affect your creative efforts?",
        "How do you use creativity to help solve your own life problems or those of your family, friends, and colleagues?",
        "Explore a creative solution to a life difficulty or challenge that’s expressed by a family member or a friend",
        "At a work meeting, when a new topic comes up, brainstorm several ideas with the group to reflect on or discuss together",
        "Write an article, essay, short story, or poem, make a drawing or painting, and share it with others",
        "When facing a problem, define the issue clearly and then practice divergent thinking",
        "Set time aside each day for creative thinking or creative activities",
        "With one of your typical work tasks, think of a new and unique way to complete it"
    ],
    "Curiosity" : [
        "What are you most curious about? Were you a curious child and adolescent?",
        "How has your curiosity been affected growing up? If it has changed over time, why is that?",
        "How does curiosity play out across the different domains of your life – family, socializing, work, school?",
        "Try a new food or going to a new restaurant to explore different foods and places",
        "Drive a different route home to explore a new area near where you live",
        "Do an online search for community activities going on around you and take notice of what piques your curiosity most",
        "Consider an activity you dislike. Pay attention to 3 novel features of this activity while you do it",
        "Practice active curiosity and explore your current environment, paying attention to anything you may often ignore or take for granted",
        "Try asking “why?” more often on your team or with your subordinates and supervisors to express more curiosity at work. Don’t take what you’re told at face value if it doesn’t make complete sense to you"
    ],
    "Fairness" : [
        "How is your strength of fairness expressed at work, at home, and in the community?",
        "In what situations have you received feedback that you have acted unfairly? How did you handle the situation?",
        "How do you reconcile your sense of fairness with the reality that 'life is not fair'?",
        "Support others in exploring their beliefs and perceptions about people from diverse backgrounds",
        "Take steps to make your workplace more inclusive, encouraging, or supportive",
        "Lead an organization that offers under-privileged people a level playing field",
        "Self-monitor to see whether you think about or treat people of other ethnicities and cultures stereotypically",
        "The next time you make a mistake, self-monitor to see whether you admit it",
        "Involve others in decisions that affect them and allow them to disagree with your ideas and assumptions. Invite their ideas for other ways to approach the decision"
    ],
    "Forgiveness" : [
        "What are the circumstances in which it is easy for you to be forgiving? Who is easiest in your life to forgive? Why?",
        "How do you reconcile forgiving someone while holding the belief that people should be held accountable for transgressions?",
        "Is it easier or more challenging to forgive someone at work or someone at home? Why?",
        "If someone offends you at work, take the time to think about how they are a complex human being, rather than seeing them as 'all bad'",
        "Let go of minor irritants in your life, such as someone cutting you off in traffic",
        "Forgive those who you've held a grudge against for too long",
        "Take 20 minutes and write about the personal benefits that resulted from a negative incident",
        "Think of someone who wronged you recently. Put yourself in their shoes and try to understand their perspective",
        "Make a list of individuals against whom you hold a grudge. Choose one person. Either meet with them personally, or visualize a conversation in which you practice forgiveness"
    ],
    "Gratitude" : [
        "What circumstances make it most likely you will experience gratitude? What circumstances make it most likely you will express gratitude?",
        "Are there people to whom you have not adequately expressed gratitude, as an oversight or intentionally holding it back?",
        "To what degree do you express gratitude to others out of a deep feeling of appreciation as opposed to social convention?",
        "Point out one small attribute or behavior to one of your close relationships that you appreciate but that typically goes unnoticed",
        "Write down three good things that you are grateful for each day",
        "Set aside at least ten minutes every day to savor a pleasant experience",
        "Make a point to go out of your way to express thanks to someone at work who is not typically recognized. Be sure to offer a few sentences of explanation about why you are grateful to them and note the impact their actions have had on you"
    ],
    "Honesty" : [
        "How well do you honor your commitments, agreements, and compromises in your personal and professional relationships?",
        "How often do you neutralize guilt by making excuses, blaming, minimizing, or rationalizing the truth away? Are you aware of these processes when they are happening?",
        "Who is one of your models of honesty? How might you improve on your own modeling of honesty to others?",
        "When someone asks for your honest opinion, give it to them (with a dose of kindness too)",
        "When you are speaking with your co-workers, use speech that is direct, clear, and specific",
        "Be honest with yourself. Name a struggle, bad habit, or vice you have been avoiding then face or talk about this dilemma",
        "The next time you are asked for advice, give constructive, direct and authentic feedback",
        "Honor your commitments in all of your relationships. If you agree to do something or schedule a time to meet with someone, be reliable and follow through",
        "Write about a community issue that you believe has not been dealt with directly and honestly. Consider sharing your writing with others"
    ],
    "Hope" : [
        "What are the conditions that have led you to be hopeful in your life?",
        "How do you balance what is realistic and what is unrealistic in terms of your expression of hope and optimism?",
        "What role does hope play during challenging times in your life? How do you express hope at those times?",
        "Notice accomplishments with your relationship partner",
        "Set a goal at work for tasks you want to accomplish that day. For any goal you make, consider at least three pathways by which it could be achieved",
        "Offer a friend the gift of hopeful comments and ideas",
        "Write an internal movie that features one of your goals. Picture yourself overcoming the obstacles, developing pathways around and through problems, to reach your goal"
    ],
    "Humility" : [
        "Where does your humility come from and how do you express it?",
        "How does humility limit your life or get in your way?",
        "How do you balance humility with a need for recognition and appreciation?",
        "Express humility by listening attentively to your co-workers’ ideas, and compliment them when you feel they have good input without trying to add your ideas as well",
        "Notice if you speak more than others in a group or team situation, and focus on the other people in the group",
        "Prime yourself to be humble before interacting in one of your close relationships. This means spending a few minutes thinking about humility and how you could act modestly with the person in an upcoming situation",
        "Resist showing off accomplishments for a week and notice the changes in your interpersonal relationships",
        "Notice if you speak more than others in a group situation",
        "Admit your mistakes and apologize even to those who are younger than you"
    ],
    "Humor" : [
        "How do you initiate playfulness, and how does that change from situation to situation?",
        "How do other people you know express playfulness? What can you learn from observing playfulness in others?",
        "In what situations has humor been a barrier for you in connecting with others?",
        "Watch a sitcom or funny movie with a friend or family member",
        "Look for the lighter side of a difficult situation in your relationship. Bring appropriate pleasure and playfulness to the situation",
        "Send a funny video from YouTube to several of your colleagues. You might consider the timing of this, and send the video when your co-workers or work team could use a break from a stressful situation",
        "Think about a past event in which you used humor for your benefit and the benefit of others",
        "Write down the humor of your everyday life. Each day make a conscious effort to be aware of your sense of humor, others' sense of humor, funny situations, and clever comments and record them in a daily journal",
        "Watch a funny sitcom/movie or read a comic blog daily"
    ],
    "Judgment" : [
        "How do you express your judgment/critical thinking to others?",
        "With what people and in what circumstances is it difficult for you to think rationally without being confused by strong emotions?",
        "As you gather information about a person, weigh it based on its merits, and analyze the information rationally so you can avoid jumping to conclusions",
        "Consider a current work project. Express judgment by adding another angle or opinion to the project, maybe something new or an option that you may have rejected too quickly at first",
        "Watch a political program that shares a very different or opposite point of view from your own, and try to understand how others could believe that position deeply",
        "Play devil’s advocate on an issue that you have strong opinions about",
        "Examine a past event that you are not happy with (not following through with a goal) and brainstorm ideas for other ways that you could have approached that event/activity",
        "Choose a strong opinion you have and live briefly (in a positive way) as if you have the opposite opinion. If acting as if you hold that opinion is too challenging, then experiment with this as a mental activity"
    ],
    "Kindness" : [
        "What are some way you have observed the expression of kindness and compassions by different people in different situations?",
        "How are your kind acts received by others?",
        "What character strengths best support your expressions of kindness?",
        "Surprise someone with whom you are in a close relationship with a random act of kindness",
        "While getting a morning cup of coffee at your local coffee shop, purchase a second cup 'to go' for one of your co-workers. Alternate the extra cup between your co-workers. If a co-worker has been unkind to you, consider including them in the rotation",
        "Offer deliberate kind acts to neighbors in your community, such as helping a neighbor in need with their lawn, with snow on their driveway, with their groceries, or with their pet",
        "Perform a random act of kindness each day (ex: slowing to allow a car in front of you, complimenting a co-worker, buying a treat for your partner)",
        "Say kinder and softer words to people when interacting through email, writing letters, talking on phone. Smile when answering the phone and sound happy to hear from the person on the other end of the line",
        "Take out a friend(s) on a surprise dinner and pay for it"
    ],
    "Leadership" : [
        "What is the difference between how effective you have been as a leader and how much you enjoy being a leader? How can you bring them into better agreement?",
        "How do you decide when to lead and when to allow others to lead?",
        "How do you keep the two key tasks of leadership — getting things done and helping people get along — in mind while you are leading?",
        "Organize a social event for some of your colleagues or a celebration for someone’s birthday, anniversary, or workplace accomplishment. Take charge by organizing the people, setting, activities, and logistics",
        "Discuss with someone who reports to you about how they can align their top character strength more in their work",
        "When two people are in an argument, mediate by inviting others to share their thoughts and emphasizing problem solving",
        "Lead an activity, assignment or project and actively solicit opinions from group members",
        "Read a biography and/or watch film of your favorite leader and evaluate how he/she inspires you in practical ways"
    ],
    "Love" : [
        "Who are the people who matter most to you across each of the domains of your life (friends, family, partners, co-workers)? How do you express love in a healthy way with each group? How does your love express itself differently?",
        "What are the ways in which you express love to others, and how is it received?",
        "How well do you receive love? It is often easier to give than to receive, but good relationships are a two-way street. Do signs of love make you uncomfortable or afraid of what others may expect from you?",
        "Carve out some time each week to experience uninterrupted quality time in your closest relationship",
        "Convey love at work by making an effort to understand who you're working with, finding out what is important to them and engaging with them on the topic regularly",
        "Engage in a favorite activity with a loved one (e.g., hiking, going to an amusement park, biking, walking in the park, swimming, camping, jogging)",
        "Reflect on what it might look like to express more love to your community. Perhaps you already feel love for your neighborhood or city, but what might be one step forward to demonstrate that love by putting it into action?"
    ],
    "Love of Learning" : [
        "What areas of learning (factual knowledge, people, skills, philosophy, or spirituality) do you find most interesting?",
        "What is it that you love about learning?",
        "How does the breadth and depth of your knowledge affect your relationships, from people recently met to people who are close to you?",
        "Seek out someone with whom you can have an in-depth conversation on a topic of mutual interest or a topic you are interested in learning more about",
        "During a work break, use 5–10 minutes to learn something new on a specific topic that interests you",
        "Deliberately learn five new words, including their meaning and usage, at least twice a week",
        "Read a non-fiction book monthly on a topic you find absorbing and engaging",
        "Consider a community topic that is important to you. Spend time learning all you can about the topic, issue, phenomenon, or situation. Then think about how you can use that knowledge to contribute to the community"
    ],
    "Perserverance" : [
        "When does persevering in a task feel engrossing to you as opposed to a chore?",
        "What causes you to stop persevering?",
        "When you succeed in persevering, how does that affect how you approach subsequent challenges?",
        "When you experience a relationship setback and feel the urge to pull back from that person, instead you can use this opportunity to move the relationship forward by addressing it directly",
        "Set small goals weekly. Break them into practical steps, and accomplish them on time",
        "Keep a checklist of things to do and regularly update it",
        "Select a role-model who exemplifies perseverance and determine how you can follow her/his footsteps"
    ],
    "Perspective" : [
        "When has looking at a problem from another level been most helpful for you personally and for others around you?",
        "What are examples of times when your perspective was easiest to share?",
        "What have been one or two of your missed opportunities in sharing this strength?",
        "Help a family member weigh all possibilities when they are dealing with a personal dilemma",
        "When facing a conflict in your life, stop and access what your best option is going forward",
        "For your next interaction, first focus on listening carefully and then focus on sharing your ideas and thoughts",
        "Read quotes on wisdom, find one that resonates and then re-write it to make it your own and put it to memory. Try to think about ways that you can live truer to that quote",
        "Find someone wise (alive or someone who has passed on), read or watch a film on their life, and identify how their life can guide your decisions and actions"
    ],
    "Prudence" : [
        "What are the personal benefits you experience in being prudent?",
        "How has prudence served you well over the years, in big and small ways?",
        "What regrets do you have about times you held yourself back from taking a risk?",
        "Organize and plan things before you act so that you minimize the risk of making mistakes or falling short of goals",
        "Drive cautiously. Notice your mental activity and bodily sensations as you do so",
        "Think twice before saying anything. Do this exercise at least ten times a week and note its effects",
        "Remove all extraneous distractions before your make your next three important decisions",
        "Visualize the consequences of your next decision in one, five, and ten years’ time"
    ],
    "Self Regulation" : [
        "How does self-regulation play a role in your greatest successes in life?",
        "What areas of your life are best regulated?",
        "How does self-regulation affect your tolerance for situations that are vague or unpredictable?",
        "Stick with an exercise or walking routine and involve one of your close relationships in the discipline",
        "Make a to-do list for a neighborhood or community-oriented event, come up with an action plan, and carry it out",
        "Next time you get upset, make a conscious effort to control your emotions and focus on positive attributes",
        "Set goals to improve your everyday living (e.g., room cleaning, laundry, doing dishes, cleaning your desk) and make sure you complete the tasks",
        "Pay close attentions to your biological clock. Do your most important tasks when you are most alert"
    ],
    "Social Intelligence" : [
        "What are the social situations that have had the most positive outcomes for you, and how did you positively influence the interactions?",
        "When has it been helpful for you to double-check your 'read' on situations? How did you do the double-check?",
        "When has your social intelligence gotten in your way?",
        "When you find yourself in a relational argument that you have been in before, attempt to find at least one positive element in the other person’s comments and opinions",
        "Practice noticing, labeling and expressing emotions. After you become aware of an emotion, label it, and if appropriate, express it to another",
        "Write five personal feelings daily for four weeks and monitor patterns",
        "Watch a favorite TV program or film muted and write feelings observed"
    ],
    "Spirituality" : [
        "What positive role (relationships, health, achievement, community involvement) does spirituality or a sense of meaning play in your life?",
        "How is spirituality related to your religious practices or lack thereof?",
        "To what extent do you feel that there is one true way to be spiritual for all people as opposed to people finding their own way?",
        "Place a symbol or meaningful object at your desk that reminds you of the sacredness of life or reflects your spirituality or religion",
        "Pause to connect with the sacred within, what some refer to as your inner spirit",
        "Cultivate sacred moments in which you set aside time to 'just be' with a special/sacred object or space/environment",
        "Build in spiritual tools as a regular practice (ex: prayer, meditation, exploring nature) or as a way of approaching life (ex: giving charity, showing compassion to less fortunate individuals)",
        "When experiencing trauma or a difficult situation, look for the deeper meaning and purpose of the experience"
    ],
    "Teamwork" : [
        "What is most gratifying to you about being part of a team?",
        "How do you feel and act when you carry more than your fair share of the weight for a team?",
        "How does teamwork extend into your personal life; for example, parenting, family, partner, friendship?",
        "Examine the tasks facing your team at work. Offer to help with one of the elements of a task that seems to be overlooked or that a colleague is struggling with",
        "Volunteer weekly for a community service project in your town"
    ],
    "Zest" : [
        "What conditions (people, places, or activities) bring out your zest?",
        "How does zest lead you, if at all, in directions that you later regret?",
        "Zest is well described as a value-added strength, meaning that its moral nature is best revealed when it is combined with other character strengths. Which of your character strengths might combine best with zest?",
        "Because zest is affected by exercise, go for periodic walks while you are at work, in between tasks",
        "Approaching a task in your community with enthusiasm and energy",
        "Improve your sleep hygiene by establishing regular sleep time, eating 3-4 hours before sleeping, avoiding doing any work in the bed, not taking caffeine late in the evening, etc. Notice changes in your energy level",
        "Do a physically rigorous activity (bike riding, running, sports) that you always wanted to do but have not done yet",
        "Call old friends and reminisce good old times"
    ]
]
