import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> uploadStories() async {
  try {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference stories = firestore.collection('Stories');

final List<Map<String, dynamic>> storyList = [
      {
        "Title": "Bhaskara II and the Gravity of Earth",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The mathematician who described gravity 500 years before Newton.",
        "Description": "In his 12th-century masterpiece 'Siddhanta Shiromani', Bhaskara II wrote: 'Objects fall on earth due to a force of attraction by the earth. Therefore, the earth, planets, constellations, moon, and sun are held in orbit due to this attraction.' He also calculated the time taken for the Earth to orbit the Sun to within 3 minutes of modern calculations.",
        "Modern Edge": "The lesson is Trusting Your Inner Vision. Bhaskara II proved that if your logic is sound, you don't need external validation or fancy tools to know the truth. Trust your path even when others lack the instruments to see what you see."
      },
      {
        "Title": "Charaka: The Father of Medicine",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who codified Ayurveda and medical ethics.",
        "Description": "Charaka was the principal contributor to the Charaka Samhita. He emphasized that a physician's first duty is to the patient, not to fame or wealth. He was among the first to realize that digestion, metabolism, and immunity are the pillars of health, and he classified thousands of medicinal plants that are still used in modern pharmacology.",
        "Modern Edge": "The lesson is Root-Cause Healing. We often try to fix our lives by changing external circumstances. Charaka teaches that true stability starts from within—fix your internal state and your relationship with yourself first."
      },
      {
        "Title": "Panini: The Father of Linguistics",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The grammarian who created the world's first formal language system.",
        "Description": "Panini's 'Ashtadhyayi' is a 4,000-rule grammar of Sanskrit that functions like a modern computer program. He used Boolean logic and null operators long before they were defined in the West. Modern computer scientists, including those who developed Fortran and Backus-Naur Form, acknowledge Panini’s work as the foundation of formal language theory.",
        "Modern Edge": "The lesson is the Power of Structure. Panini turned chaos into a perfect system. Once you define the rules of your own life and ethics, you stop wasting energy on confusion. Clarity is the ultimate form of discipline."
      },
      {
        "Title": "The Vision of Krishnadevaraya",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Golden Age of the Vijayanagara Empire.",
        "Description": "Emperor Krishnadevaraya was not just a warrior but a scholar-king. He protected the South from invasions while turning Hampi into one of the world's largest and wealthiest cities. He was famous for his justice, personally listening to the grievances of commoners, and for patronizing 'Ashtadiggajas' (eight great poets) in his court.",
        "Modern Edge": "The lesson is Staying Grounded. Despite his immense power, he sought the truth directly from the people. Don't let your success isolate you; keep your ears open to the honest, unvarnished truth of those around you."
      },
      {
        "Title": "Lalitaditya Muktapida: The Alexander of Kashmir",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The king who expanded India's borders to Central Asia.",
        "Description": "Lalitaditya of the Karkota dynasty was a conqueror who built an empire stretching from the Caspian Sea to the Pragjyotisha (Assam). He built the magnificent Martand Sun Temple, an architectural marvel. He is remembered for his administrative reforms that ensured even the most remote parts of his empire were self-sufficient.",
        "Modern Edge": "The lesson is Empowering Independence. A great leader doesn't make people dependent on them; they build systems where others can thrive on their own. True strength is creating a legacy that functions without your constant intervention."
      },
      {
        "Title": "The Battle of Rajasthan",
        "Category": "Battles",
        "Region": "West",
        "Summary": "When a coalition of Indian Kings stopped the Umayyad Caliphate.",
        "Description": "In the 8th Century, a massive Arab army attempted to invade mainland India. Nagabhata I of the Gurjara-Pratihara dynasty and Bappa Rawal of Mewar formed a rare coalition. They decisively defeated the invaders in the deserts of Rajasthan, protecting the Indian heartland from foreign conquest for the next 300 years.",
        "Modern Edge": "The lesson is Strength in Unity. These kings set aside rivalries to face a common threat. Stop fighting petty internal battles and recognize the bigger challenges—you are always more capable when you work as a team."
      },
      {
        "Title": "The Battle of Tunga",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The Rajput resistance against the Maratha-Mughal pressure.",
        "Description": "In 1787, the combined forces of Jaipur and Jodhpur faced the professionalized battalions of Mahadji Scindia. Despite facing heavy artillery, the Rajput cavalry charged with such intensity that they forced a stalemate and eventual retreat. It remains a testament to the traditional valor of the desert warriors.",
        "Modern Edge": "The lesson is the Power of Commitment. When you are outmatched by external odds, the only move is a full-speed, high-conviction charge. Pure heart can often break a technical advantage that logic says is unbeatable."
      },
      {
        "Title": "Suheldev: The Protector of Shravasti",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The king who defeated the Ghaznavid army.",
        "Description": "When Salar Masud, the nephew of Mahmud Ghazni, invaded India with a massive force, King Suheldev of Shravasti gathered local tribes and kings. In 1033 CE at Bahraich, he wiped out the entire invading army. For nearly 150 years after this battle, no foreign invader dared to cross into the Gangetic plains.",
        "Modern Edge": "The lesson is Local Agency. Suheldev didn't wait for a central savior; he rallied his own community. You have the power to protect your own peace and territory without waiting for permission or external help."
      },
      {
        "Title": "The Sacrifice of Panna Dhai",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The nurse who sacrificed her own son to save the heir of Mewar.",
        "Description": "When the assassin Banbir came to kill the infant Prince Udai Singh, Panna Dhai placed her own sleeping son in the royal bed. She watched her son die to ensure that the bloodline of Mewar survived. Prince Udai Singh grew up to found Udaipur, a city that stands today because of a mother's ultimate sacrifice.",
        "Modern Edge": "The lesson is Living for a Greater Cause. Panna Dhai’s story is a reminder that some things are bigger than our personal attachments. It is the ultimate lesson in duty and the profound weight of selfless sacrifice."
      },
      {
        "Title": "Birsa Munda: Dharati Aba",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The tribal leader who challenged the British Empire.",
        "Description": "Birsa Munda led the 'Ulgulan' (Great Tumult) against the British and the exploitative Zamindari system. He worked to restore the tribal rights over their land and forests. Though he died in prison at age 25, his movement forced the British to pass laws protecting tribal lands, making him a legend in Indian history.",
        "Modern Edge": "The lesson is Dignity in Roots. Birsa Munda reminds us that freedom is tied to our connection with our environment and heritage. Never let the modern world strip you of your core identity or your 'soil'."
      },
      {
        "Title": "Alluri Sitarama Raju: Manyam Veerudu",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The hero of the Rampa Rebellion.",
        "Description": "A young man who became a sanyasi and led the tribal people of Andhra Pradesh in a guerrilla war against the British. He raided police stations to seize weapons for his people. He was so respected that even his enemies admired his integrity and tactical brilliance in the dense forests.",
        "Modern Edge": "The lesson is Integrity in Struggle. Alluri showed that you can be a warrior without losing your spiritual center. Never let a conflict turn you into the very thing you are fighting against."
      },
      {
        "Title": "Vanchinathan and the Ashe Murder",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The young revolutionary of Tamil Nadu.",
        "Description": "Vanchinathan was part of a secret society dedicated to ending British rule. In 1911, he assassinated the collector Robert Ashe, who was known for suppressing the Swadeshi shipping movement. Vanchinathan then took his own life to avoid capture, leaving a note stating that his action was to alert the world to the plight of India.",
        "Modern Edge": "The lesson is the Weight of a Signal. Vanchinathan believed that sometimes a single, dramatic act of defiance is needed to wake up a sleeping conscience. It's a reminder to be bold when silence is no longer an option."
      },
      {
        "Title": "Madhava: The Father of Calculus",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The Kerala mathematician who found infinite series before Newton.",
        "Description": "Madhava of Sangamagrama founded the Kerala School of Astronomy and Mathematics in the 14th century. He discovered the infinite series for Pi, sine, and cosine—concepts that form the basis of modern Calculus. His work was centuries ahead of European mathematicians like Gregory, Leibniz, and Newton.",
        "Modern Edge": "The lesson is Depth over Distance. Madhava outperformed the world from an isolated village. Your location doesn't limit your potential—deep, persistent work can change the world from anywhere."
      },
      {
        "Title": "Nagarjuna: The Master of Metallurgy",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "The ancient chemist who transformed base metals into gold-like alloys.",
        "Description": "Nagarjuna was a brilliant chemist and alchemist who lived in the Satavahana era. In his work 'Rasaratnakara', he described processes for the extraction of metals like silver, gold, and copper. He was a pioneer in the use of minerals in medicine, creating 'Rasayana' to prolong life and heal chronic diseases.",
        "Modern Edge": "The lesson is Finding Value in the Ignored. Nagarjuna saw potential in base minerals that others discarded. In your life, learn to see the 'gold' in your failures or undervalued skills—transformation is always possible."
      },
      {
        "Title": "Brahmagupta and the Laws of Negative Numbers",
        "Category": "Ancient Science",
        "Region": "West",
        "Summary": "The mathematician who taught the world how to use 'Zero'.",
        "Description": "In the 7th century, Brahmagupta wrote 'Brahmasphutasiddhanta'. He was the first to give rules to compute with zero and negative numbers. He referred to positive numbers as 'property' and negative numbers as 'debt', creating the logical framework for modern algebra and accounting.",
        "Modern Edge": "The lesson is Embracing the 'Negative'. Brahmagupta proved that 'Zero' and 'Debt' (negatives) are manageable if you have a system. Don't fear the low points in life; build a logical framework to navigate them."
      },
      {
        "Title": "Rani Rashmoni: The Rebel Queen of Bengal",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The widow who defied the British East India Company to protect the poor.",
        "Description": "Rani Rashmoni was a visionary leader who managed a vast estate in Bengal. When the British imposed a tax on poor fishermen, she blocked the shipping trade on the Hooghly river until the tax was repealed. She built the Dakshineswar Kali Temple and stood as a pillar of strength against social and colonial oppression.",
        "Modern Edge": "The lesson is Using Leverage for Good. She didn't just complain; she used her resources to hit the oppressors where it mattered. True power is found in using what you have to protect those who have nothing."
      },
      {
        "Title": "The Maritime Genius of Kanhoji Angre",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Admiral who was never defeated by European navies.",
        "Description": "Kanhoji Angre was the Chief of the Maratha Navy. For over 30 years, he defended the Konkan coast against the British, Dutch, and Portuguese. He developed a system of coastal forts and fast, maneuverable ships that utilized local currents to trap and defeat the heavy, slow-moving European vessels.",
        "Modern Edge": "The lesson is Mastering Your Environment. Victory isn't about being the biggest; it's about being the most adapted to your surroundings. Use your 'home turf' advantage to outmaneuver any giant."
      },
      {
        "Title": "Kapilendra Deva and the Suryavamsa Empire",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The king who defended Odisha from three directions.",
        "Description": "Rising from a humble background to become the Emperor of Odisha, Kapilendra Deva expanded his kingdom from the Ganges to the Kaveri. He was a great patron of Odia literature and culture, ensuring that his people’s identity remained strong despite constant external threats.",
        "Modern Edge": "The lesson is Multi-Front Resilience. Kapilendra Deva thrived because he empowered capable people. If you are facing many challenges at once, don't try to micro-manage—trust and empower your support system."
      },
      {
        "Title": "The Battle of Puvathur",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The unsung resistance against the Portuguese expansion.",
        "Description": "When the Portuguese tried to dominate the spice trade in Kerala, local chieftains and the Zamorin of Calicut fought back. In the Battle of Puvathur, the local forces used guerrilla naval tactics to destroy Portuguese supply lines, delaying European colonization of the interior for decades.",
        "Modern Edge": "The lesson is Tactical Patience. They didn't attack the main fleet; they cut off the supplies. To solve a big problem, don't hit it head-on—weaken the things that keep the problem alive first."
      },
      {
        "Title": "The Battle of Itakhuli",
        "Category": "Battles",
        "Region": "East",
        "Summary": "The final Ahom victory that expelled the Mughals forever.",
        "Description": "In 1682, the Ahom army led by Dihingia Alun Borbarua fought the Mughals at Itakhuli. This decisive victory pushed the Mughal border back to the Manas river. After this battle, the Mughals never attempted to invade the Brahmaputra valley again, securing the sovereignty of Assam.",
        "Modern Edge": "The lesson is Setting Uncrossable Lines. Once you defeat a challenge, set a firm boundary to ensure it never returns. Respect is earned when you decide what you will absolutely not tolerate."
      },
      {
        "Title": "Khudiram Bose: The Youngest Martyr",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The 18-year-old who walked to the gallows with a smile.",
        "Description": "Khudiram Bose was a teenage revolutionary in Bengal. He attempted to assassinate a cruel British judge to protest colonial atrocities. When he was caught and sentenced to death, he went to the gallows holding the Bhagavad Gita, becoming a symbol of eternal youth and sacrifice for India's freedom.",
        "Modern Edge": "The lesson is Purpose over Fear. Khudiram found something worth living for, which made him fearless toward the end. When your conviction is deep enough, the world loses its power to intimidate you."
      },
      {
        "Title": "U Tirot Sing: The Hero of Khasi Hills",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The tribal chief who fought the British for four years.",
        "Description": "U Tirot Sing, a Khasi chief, realized the British were using road construction as a pretext for colonization. He organized his tribesmen and fought a fierce guerrilla war in the dense jungles of Meghalaya. Despite being outgunned, his bravery earned him the respect of even his British captors.",
        "Modern Edge": "The lesson is Discerning True Intent. Tirot Sing teaches us to look behind 'improvements' to see if they come with hidden costs. Always value your freedom more than an easy path provided by others."
      },
      {
        "Title": "The Bravehearts of Tarapur",
        "Category": "Battles",
        "Region": "Central",
        "Summary": "The 1932 massacre that mirrored Jallianwala Bagh.",
        "Description": "In a small village in Bihar, 34 young freedom fighters were killed by British police while trying to hoist the Tricolor flag at a government building. This remains the largest collection of martyrs in a single incident during the freedom struggle after 1919, yet their story remains largely untold.",
        "Modern Edge": "The lesson is Persistent Visibility. They died to keep the symbol alive. If your mission is right, keep showing up. As long as the 'flag' is visible, the movement hasn't failed."
      },
      {
        "Title": "Kanada: The Father of Atomic Theory",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who conceptualized the 'Anu' (Atom) 2,600 years ago.",
        "Description": "Acharya Kanada founded the Vaisheshika school of philosophy. He proposed that every object in the universe is made of 'Paramanu' (atoms), which are indestructible and eternal. He explained that atoms combine in pairs (dwinuka) and triplets (trinuka) to form different types of matter, predating John Dalton's atomic theory by more than two millennia.",
        "Modern Edge": "The lesson is Modular Thinking. Life is just a combination of small, modular habits and choices. Don't worry about the whole 'mountain'—just focus on the 'atoms' of your daily actions."
      },
      {
        "Title": "Baudhayana: The First Geometrician",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The mathematician who wrote the Pythagoras theorem before Pythagoras.",
        "Description": "In the 'Baudhayana Sulba Sutra', written around 800 BCE, Baudhayana gave the geometric proof for the relationship between the sides of a right-angled triangle. He also calculated the square root of 2 and the value of Pi with incredible precision, all to help in the construction of complex Vedic altars.",
        "Modern Edge": "The lesson is Applied Excellence. Math wasn't just a theory for Baudhayana; it was for building something perfect. Ensure your preparation is as rigorous as the result you want to achieve."
      },
      {
        "Title": "Adi Shankara: The Unifier of India",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The philosopher who revitalized Advaita Vedanta at age 32.",
        "Description": "Adi Shankara traveled from Kerala to the Himalayas on foot four times. He established four 'Mathas' in the four corners of India (Puri, Dwaraka, Sringeri, Badrinath), weaving the spiritual fabric of the nation together. His philosophy of Non-dualism (Advaita) remains one of the most profound intellectual achievements of mankind.",
        "Modern Edge": "The lesson is Building for Continuity. Adi Shankara didn't just spread an idea; he built the 'hubs' to keep it alive after him. If you have a vision, build the systems that allow it to survive without your constant presence."
      },
      {
        "Title": "Vachaspati Misra: The Intellectual Giant",
        "Category": "Scholars",
        "Region": "East",
        "Summary": "The 9th-century scholar who mastered every school of Indian philosophy.",
        "Description": "Living in Mithila, Vachaspati Misra wrote commentaries on almost every major branch of Indian thought—Yoga, Nyaya, Vedanta, and Samkhya. His work was so detailed that he is said to have forgotten his own wedding while writing, naming his masterpiece 'Bhamati' after his wife as a tribute to her patience.",
        "Modern Edge": "The lesson is Deep Integration. To truly master a field, you must understand all sides of it. Vachaspati teaches us that the highest form of knowledge is being able to connect different truths into one single, beautiful picture."
      },
      {
        "Title": "Bappa Rawal: The Founder of Mewar",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who defeated the first major Arab invasion of India.",
        "Description": "Bappa Rawal consolidated the small clans of Rajasthan into a powerful force. In the 8th century, he didn't just stop the invading Umayyad Caliphate; he chased them back through the deserts into modern-day Afghanistan. His military prowess ensured that his dynasty, the Guhilots, would rule Mewar for 1,000 years.",
        "Modern Edge": "The lesson is Decisive Resolution. Bappa Rawal didn't just defend; he finished the problem. When facing a threat in life, don't just push it back—deal with it so thoroughly that it never has the chance to return."
      },
      {
        "Title": "Rani Chennamma of Kittur",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The first female ruler to lead an armed rebellion against the British.",
        "Description": "In 1824, 33 years before the 1857 mutiny, Rani Chennamma stood against the British 'Doctrine of Lapse'. She defeated the British forces in the first battle at Kittur. Though she was eventually captured, her defiance became a rallying cry for the later freedom movement in Karnataka.",
        "Modern Edge": "The lesson is Early Resistance. Don't wait for a trend to stand against what is wrong. If you see an unfair path in your life, be the first to challenge it before it becomes the status quo."
      },
      {
        "Title": "The Battle of Korgaon",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The Maratha victory that broke the myth of British invincibility.",
        "Description": "During the First Anglo-Maratha War in 1779, the Maratha forces led by Mahadji Scindia lured the British army deep into the Western Ghats. By cutting off their supplies and using the rugged terrain, the Marathas forced the British to sign the Treaty of Wadgaon, the only time the British army ever surrendered in India.",
        "Modern Edge": "The lesson is Playing to Your Strengths. Never fight on someone else's terms. Lure your challenges into the 'narrow passes' of your specific expertise where your strengths shine and their advantages become irrelevant."
      },
      {
        "Title": "The Siege of Arcot",
        "Category": "Battles",
        "Region": "South",
        "Summary": "A turning point in the struggle for Southern India.",
        "Description": "In 1751, Robert Clive and Chanda Sahib fought a grueling 50-day siege. This battle changed the course of the Carnatic Wars and established British dominance over the French in India. It was a brutal conflict that showed how European rivalries played out on Indian soil.",
        "Modern Edge": "The lesson is the Power of Endurance. Success isn't always about who has the better plan or more talent; it is often about who can sit through the pressure for one day longer than the other person. Your ability to outlast a difficult season is a skill in itself."
      },
      {
        "Title": "Hemchandra Vikramaditya: The Last Hindu Emperor of Delhi",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The general who won 22 consecutive battles.",
        "Description": "Hemu started as a commoner and rose to become the Chief Minister. He won 22 battles against Afghan rebels and Mughal forces. In 1556, he captured Delhi and declared himself Emperor 'Vikramaditya'. He was on the verge of winning the Second Battle of Panipat until a stray arrow struck his eye, changing the fate of India.",
        "Modern Edge": "Hemu teaches us about the fragility of Momentum. You can do everything right for 22 steps, but life can still turn on a single moment. It is a reminder to remain humble in victory and to always protect your most vulnerable points when you are at the finish line."
      },
      {
        "Title": "The 13 Martyrs of Mahad",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The struggle for basic human dignity and water rights.",
        "Description": "Led by Dr. B.R. Ambedkar in 1927, thousands marched to the Chavdar Tank in Mahad to assert their right to drink water. This was not a battle of swords, but a battle for civil rights. It marked the beginning of a social revolution that eventually shaped the Constitution of India.",
        "Modern Edge": "The lesson is fighting for the Fundamentals. We often get distracted by luxuries, but these martyrs remind us that the most important battles are for basic dignity. If you base your actions on a universal truth—like the right to water—your movement becomes unstoppable."
      },
      {
        "Title": "Komaram Bheem: Jal, Jangal, Zameen",
        "Category": "Freedom Fighters",
        "Region": "Central",
        "Summary": "The Gond leader who fought the Nizam's tyranny.",
        "Description": "Komaram Bheem led a rebellion against the Nizam of Hyderabad's forest taxes. He coined the slogan 'Jal, Jangal, Zameen' (Water, Forest, Land), asserting that those who live in the forest should own its resources. He fought using traditional weapons against modern guns until his martyrdom.",
        "Modern Edge": "The lesson is about Identity and Roots. Bheem realized that freedom is hollow if you don't have control over the resources that sustain you. In life, make sure you own your own narrative and your own foundations, or you will always be at the mercy of others."
      },
      {
        "Title": "Bhikaiji Cama: The Mother of the Indian Revolution",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The woman who unfurled the first Indian flag on foreign soil.",
        "Description": "In 1907, at the International Socialist Congress in Germany, Madam Cama hoisted the first version of the Indian National Flag. She spent her life in exile in Europe, organizing Indian revolutionaries and speaking out against British imperialism despite failing health and constant surveillance.",
        "Modern Edge": "Cama’s lesson is about Perspective from Distance. Sometimes you can see the truth of your home better when you are away from it. She used the global stage to fight local battles, showing us that if your voice is being suppressed in one place, you should find a new platform to be heard."
      },
      {
        "Title": "Sushruta: The Father of Surgery",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who performed plastic surgery 2,500 years ago.",
        "Description": "Long before modern medicine, Sushruta practiced in Kashi. He authored the Sushruta Samhita, describing over 300 surgical procedures and 120 surgical instruments. He is most famous for 'Rhinoplasty' (reconstructing a nose), using a flap of skin from the cheek or forehead—a technique essentially unchanged in modern surgery today.",
        "Modern Edge": "The lesson is the Value of Sharing Knowledge. Sushruta didn't just keep his skills to himself; he documented them so perfectly that they are still used today. True mastery isn't just in the doing; it is in the teaching and the legacy you leave for others to build upon."
      },
      {
        "Title": "Aryabhata and the Concept of Zero",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The mathematician who calculated the Earth's circumference.",
        "Description": "In the 5th century, Aryabhata calculated the value of Pi to four decimal places and proposed that the Earth is spherical and rotates on its axis. By defining 'Zero' not just as a symbol but as a mathematical concept, he laid the foundation for modern computing and space exploration.",
        "Modern Edge": "Aryabhata teaches us to Question the Defaults. While everyone else believed the Earth was static, he looked at the data and dared to see a different world. Don't just accept what society tells you is true—recalculate the model yourself."
      },
      {
        "Title": "Chhatrapati Shivaji Maharaj: The Father of Indian Navy",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The strategic genius who built a naval force from scratch.",
        "Description": "Shivaji Maharaj realized early that 'He who rules the seas, rules the land.' He built strategic coastal forts like Sindhudurg and a powerful indigenous navy to defend against the Siddis, Portuguese, and British. His use of 'Ganimi Kava' (Guerrilla Warfare) and focus on 'Swarajya' (Self-rule) redefined Indian resistance.",
        "Modern Edge": "The lesson is Visionary Preparation. Shivaji looked at the coastline and saw a threat that others ignored. In your own life, look beyond the immediate problems. Prepare for the 'storms' that are still on the horizon, not just the ones already at your door."
      },
      {
        "Title": "Rani Durgavati’s Defiance",
        "Category": "Freedom Fighters",
        "Region": "Central",
        "Summary": "The Gondwana Queen who chose death over surrender.",
        "Description": "Rani Durgavati ruled the Gondwana kingdom with great efficiency. When the Mughal army under Akbar attacked, she led her troops personally. Even when wounded by arrows in the eye and neck, she refused to surrender, choosing to take her own life with her dagger to maintain her dignity and honor.",
        "Modern Edge": "Durgavati’s lesson is about Personal Sovereignty. She understood that while she couldn't control the outcome of the battle, she could always control her own dignity. Never allow your circumstances to force you into a compromise that betrays your core identity."
      },
      {
        "Title": "Raja Raja Chola I and the Great Living Temples",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who built the Brihadisvara Temple without a shadow.",
        "Description": "Raja Raja Chola I was a visionary who built the Brihadisvara Temple in Thanjavur. The temple's 'Kumbam' (top stone) weighs 80 tons and was moved to the top via a 6km long ramp. His administration was so advanced that it included an early form of local self-government and a massive land survey.",
        "Modern Edge": "The lesson is Thinking in Centuries. Raja Raja didn't build for his own ego; he built for eternity. When you start a project, ask yourself: is this just for today, or is the foundation strong enough to carry a heavy burden for a thousand years?"
      },
      {
        "Title": "The Battle of Haldighati",
        "Category": "Battles",
        "Region": "North",
        "Summary": "Maharana Pratap's legendary stand for independence.",
        "Description": "In 1576, Maharana Pratap faced the massive Mughal army. Despite being outnumbered, Pratap and his loyal horse Chetak fought with legendary bravery. Pratap never surrendered his pride or his land, living in the Aravalli forests for years to continue his struggle for Mewar's freedom.",
        "Modern Edge": "The lesson is the Power of the Unbroken Spirit. You aren't defeated when you lose your comfort; you are only defeated when you stop fighting. As long as you are still in the 'forest' and refusing to yield, you are still the master of your destiny."
      },
      {
        "Title": "The Naval Battle of Colachel",
        "Category": "Battles",
        "Region": "South",
        "Summary": "When an Indian Kingdom defeated a European superpower.",
        "Description": "In 1741, King Marthanda Varma of Travancore defeated the Dutch East India Company. This was the first time an Asian power had decisively defeated a European naval force in a organized war, effectively ending Dutch colonial ambitions in India.",
        "Modern Edge": "The lesson is that Size is Not Destiny. A small, focused force can defeat a global giant if it picks the right place to stand. Do not be intimidated by the 'big' things in life. If you focus your energy on one specific goal, you can overcome any obstacle."
      },
      {
        "Title": "Banda Singh Bahadur’s Justice",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The man who abolished the Zamindari system.",
        "Description": "An ascetic turned warrior, Banda Singh Bahadur was sent by Guru Gobind Singh to protect the people of Punjab. He established a state where the tillers owned the land, abolishing the oppressive Zamindari system, and issued coins in the name of the Gurus before his martyrdom.",
        "Modern Edge": "The lesson is Shared Prosperity. Banda Singh realized that a movement only stays strong if the people involved have a real stake in its success. In your life, empower the people around you. When everyone wins, the collective defense becomes unbreakable."
      },
      {
        "Title": "Ahilyabai Holkar: The Philosopher Queen",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "Rebuilding India's spiritual spine.",
        "Description": "After losing her family, she didn't retreat. She ruled Indore for 30 years, building temples from Somnath to Kashi. She was known for her accessibility to her subjects and her strict adherence to Dharma, earning the title 'Matoshree'.",
        "Modern Edge": "The lesson is Resilience through Service. When Ahilyabai lost her family, she didn't drown in grief; she turned that energy toward rebuilding the world for others. The best way to heal your own wounds is to help heal the world."
      },
      {
        "Title": "Pingala: The Binary Code Pioneer",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The scholar who described binary numbers 2,000 years ago.",
        "Description": "In his work 'Chandaḥśāstra', Pingala analyzed Sanskrit poetry and prosody. To map out patterns of short and long syllables, he created a system that is functionally identical to modern binary code (0s and 1s). He also described the 'Meru Prastara', which is known today in the West as Pascal's Triangle.",
        "Modern Edge": "The lesson is finding Logic in the Beautiful. Pingala looked at the art of poetry and found the math underneath it. Everything in your life—even the chaotic or artistic parts—has an underlying logic. Learn to see the patterns."
      },
      {
        "Title": "Thiruvalluvar: The Divine Poet",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The author of Thirukkural, the guide to ethical living.",
        "Description": "Thiruvalluvar composed 1,330 couplets (Kurals) covering ethics, wealth, and love. His work is entirely secular and universal, translated into almost every major language in the world. He lived as a simple weaver, proving that the most profound philosophical insights can come from a life of humble labor.",
        "Modern Edge": "The lesson is Simplicity and Depth. You don't need a thousand pages to say something true. Live your life with clarity—brief, honest, and powerful. Complexity is often just a mask for lack of clarity."
      },
      {
        "Title": "Bhaskaracharya I: The Astronomer of Kerala",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The scientist who pioneered the study of planetary positions.",
        "Description": "Not to be confused with Bhaskara II, the first Bhaskara was a 7th-century astronomer who wrote the 'Mahabhaskariya'. He gave a unique rational approximation for the sine function, which was incredibly accurate for its time and was used by sailors and astronomers across the Indian Ocean for navigation.",
        "Modern Edge": "The lesson is Practicality over Perfection. Bhaskara knew that a formula that works *right now* to guide a ship is better than a perfect proof that takes years to find. In life, don't let the search for the 'perfect' choice paralyze you from making a 'good' one that moves you forward."
      },
      {
        "Title": "Gautamiputra Satakarni: The Destroyer of Shakas",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The king who restored the pride of the Satavahana Dynasty.",
        "Description": "Gautamiputra Satakarni inherited a weak kingdom but transformed it into an empire. He decisively defeated the Western Kshatrapas and foreign invaders like the Shakas and Yavanas. He was unique for using his mother's name as a prefix, showing the high status of women in his society and his deep devotion to his roots.",
        "Modern Edge": "The lesson is Rooted Renewal. When his dynasty was failing, Satakarni didn't look to copy foreign models; he went back to his roots and honored his history. Sometimes the way forward is to look back at the values that originally made you strong."
      },
      {
        "Title": "Martanda Varma: The Maker of Modern Travancore",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who dedicated his entire kingdom to the Divine.",
        "Description": "After defeating the Dutch, Martanda Varma did something unprecedented. He performed 'Thrippadidanam', surrendering his kingdom and sword to Lord Padmanabhaswamy and ruling thereafter as a 'Padmanabha Dasa' (servant of the Lord). This act of humility ensured that the royal family saw themselves as trustees, not owners, of the people's wealth.",
        "Modern Edge": "The lesson is the Power of Humility. By moving from 'Owner' to 'Servant,' Martanda Varma gained the total trust of his people. If you want people to follow you, stop acting like you are above them and start acting like you are working for them."
      },
      {
        "Title": "The Battle of Sakharkherda",
        "Category": "Battles",
        "Region": "Central",
        "Summary": "The establishment of the Nizam's independence in the Deccan.",
        "Description": "In 1724, Nizam-ul-Mulk fought against the Mughal-backed Mubariz Khan. This battle marked the end of direct Mughal control over the Deccan and the birth of the Hyderabad State. It showed how the fragmentation of the central Mughal power led to the rise of powerful regional identities and military structures.",
        "Modern Edge": "The lesson is knowing when to Stand Alone. When the central authority was fading, the Nizam didn't sink with the ship; he established his own ground. Learn to recognize when a system is failing so you can build your own path before it collapses."
      },
      {
        "Title": "The Battle of Rakshas Tangadi (Talikota)",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The tragic end of the magnificent Vijayanagara Empire.",
        "Description": "In 1565, a coalition of Deccan Sultanates joined forces against Rama Raya of Vijayanagara. Despite the empire's wealth and military size, internal betrayals and superior gunpowder technology of the invaders led to a crushing defeat. The city of Hampi was looted for six months, leaving behind the ruins we see today.",
        "Modern Edge": "The lesson is Awareness of the New. Vijayanagara had wealth, but they ignored the changing technology and internal threats. Never let your current success make you blind to the new changes that are shifting the rules of the world around you."
      },
      {
        "Title": "Tantya Bhil: The Indian Robin Hood",
        "Category": "Forgotten Heroes",
        "Region": "Central",
        "Summary": "The tribal revolutionary who fed the hungry.",
        "Description": "Tantya Bhil was a legendary figure in Madhya Pradesh who fought British exploitation for 12 years. He would loot the British treasuries and distribute the grain and money among the poor tribes. He was so popular that the British had to use an army of spies to finally capture him, as no local person would betray him.",
        "Modern Edge": "The lesson is the Protection of the People. Tantya lived for others, and in return, they became his shield. If your life adds value to the people around you, you will never be truly alone in your struggles."
      },
      {
        "Title": "Jhalkari Bai: The Shadow of the Rani",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The brave soldier who disguised herself as Rani Laxmibai.",
        "Description": "A member of the Durga Dal (women’s army), Jhalkari Bai looked remarkably like Rani Laxmibai. During the Siege of Jhansi, she took command of the army and rode out disguised as the Queen to draw the British fire away, allowing the real Rani Laxmibai to escape safely. She fought until her last breath to protect her leader.",
        "Modern Edge": "The lesson is Loyal Self-Sacrifice. Jhalkari knew that the symbol of the Queen was more important than her own life. In your life, identify what is truly essential and be willing to defend it. The mission matters more than the ego."
      },
      {
        "Title": "Sidhu and Kanhu Murmu: The Santhal Rebellion",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The brothers who led the first major peasant revolt.",
        "Description": "In 1855, two years before the Sepoy Mutiny, the Santhal brothers Sidhu and Kanhu mobilized 30,000 Santhals against the British and oppressive moneylenders. Armed only with bows and arrows, they took over large parts of Bengal and Bihar before the British deployed specialized forces to suppress the movement.",
        "Modern Edge": "The lesson is Collective Action. The Murmu brothers didn't have the best weapons, but they had 30,000 people with a single purpose. You don't need the most expensive tools to start a movement; you just need a group of people pulling in the same direction."
      },
      {
        "Title": "Pritilata Waddedar: The Revolutionary of Chittagong",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The teacher who led an attack on a 'Europeans Only' club.",
        "Description": "A student of Surya Sen, Pritilata led a group of revolutionaries to attack the Pahartali European Club, which had a sign saying 'Dogs and Indians not allowed.' After the successful raid, she was cornered by police. To avoid capture, she consumed cyanide, sacrificing her life at age 21 for the honor of her nation.",
        "Modern Edge": "The lesson is Breaking the Aura of Arrogance. Pritilata attacked a symbol of exclusion to show that no 'club' is untouchable. You have the right to challenge any door that is unfairly closed to you."
      },
      {
        "Title": "Vishwakarma: The Architect of the Gods",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The legendary engineer of ancient Indian cities.",
        "Description": "In Indian tradition, Vishwakarma is the divine engineer. Historically, the 'Vishwakarma' community developed the Vastu Shastra—a sophisticated system of civil engineering and architecture. They mastered the science of acoustics, town planning, and the 'Lost Wax' casting method used to create the world's most detailed bronze icons.",
        "Modern Edge": "The lesson is Harmony with Environment. We often try to force our lives into shapes that do not fit. Vishwakarma teaches that if you build your life in alignment with natural laws and balance, your peace will be structural and lasting, not just a temporary decoration."
      },
      {
        "Title": "The Iron Pillar of Delhi: Ancient Metallurgy",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The 1,600-year-old pillar that refuses to rust.",
        "Description": "Built during the Gupta Empire, this 7-meter tall pillar is a metallurgical marvel. Despite standing in the open air for over 16 centuries, it has not rusted. Modern scientists discovered that ancient Indian smiths used a high-phosphorus content in the iron, creating a protective 'misawite' layer—a technology far ahead of its time.",
        "Modern Edge": "The lesson is Inner Resilience. The pillar doesn't resist the rain by fighting it; it developed an internal quality that turns the threat into a protective layer. In life, do not let external hardships corrode you. Develop a character that uses challenges to become even more durable."
      },
      {
        "Title": "Abhinavagupta: The Master of Aesthetics",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The philosopher who decoded the science of emotions.",
        "Description": "A polymath from Kashmir, Abhinavagupta wrote the 'Abhinavabharati'. He developed the 'Rasa' theory, explaining how art, music, and drama evoke specific emotional states in the human mind. His work is the foundation of Indian classical dance and music theory.",
        "Modern Edge": "The lesson is Emotional Awareness. Life is a series of Rasas—joy, fear, anger, and peace. Abhinavagupta teaches that you are not your emotions; you are the observer of them. Once you understand the science of your feelings, you can experience the beauty of life without being drowned by its drama."
      },
      {
        "Title": "Mahadji Scindia: The Regent of Delhi",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The statesman who restored Maratha influence over North India.",
        "Description": "After the disaster at Panipat, it was Mahadji Scindia who rebuilt the Maratha power. He professionalized his army with European-style infantry and artillery. For decades, he was the 'Vakil-ul-Mutlaq' (Regent) of the Mughal Emperor, effectively making the Marathas the true masters of the Indian heartland.",
        "Modern Edge": "The lesson is Rebuilding After Disaster. After a total loss, most people give up. Mahadji shows that you can start from zero, adapt to a changing world, and regain your influence. It isn't about how you fell; it is about the wisdom you gather while getting back up."
      },
      {
        "Title": "The Battle of Umberkhind",
        "Category": "Battles",
        "Region": "West",
        "Summary": "Shivaji Maharaj's masterclass in mountain warfare.",
        "Description": "In 1661, a massive Mughal army under Kartalab Khan tried to cross the Sahyadri mountains. Shivaji Maharaj lured them into the narrow, forested pass of Umberkhind. Hidden Maratha soldiers attacked from all sides using rocks and arrows. The Mughals were so trapped they had to surrender their entire treasury just to be allowed to retreat.",
        "Modern Edge": "The lesson is Knowing Your Own Ground. You don't have to be the loudest or biggest person to win. You just need to know your strengths and stay where you are most capable. When life feels overwhelming, move the struggle to a place where you feel most comfortable and grounded."
      },
      {
        "Title": "The Battle of Pullalur",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The victory of the Pallavas over the Chalukyas.",
        "Description": "King Mahendravarman I of the Pallava dynasty faced a massive invasion by the Chalukya king Pulakeshin II. At Pullalur, the Pallavas fought a defensive masterpiece that saved their capital, Kanchipuram. This battle sparked a centuries-long rivalry that defined the culture and politics of Southern India.",
        "Modern Edge": "The lesson is Protecting Your Peace. Some things are non-negotiable. Your core values and your mental health are your capital city. When external pressures invade, you must draw a line. Defending your boundaries is the first step toward a personal golden age."
      },
      {
        "Title": "Sarkhel Kanhoji Angre’s Fortress",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The unconquerable island of Khanderi.",
        "Description": "Kanhoji Angre fortified the island of Khanderi just off the coast of Mumbai. The British and Portuguese tried multiple times to capture it with their superior warships, but Angre's small, fast 'Gallivats' used the shallow waters and rocky coast to wreck the enemy ships, maintaining Indian control over the waters.",
        "Modern Edge": "The lesson is Self-Reliance. Kanhoji didn't have the big ships of the Europeans, so he mastered the environment they feared. You don't need fancy tools to succeed; you just need to master the unique gifts you already have."
      },
      {
        "Title": "The Courage of Onake Obavva",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The woman who defended a fort with a pestle.",
        "Description": "When the forces of Hyder Ali tried to sneak into the Chitradurga Fort through a narrow hole, Obavva saw them. While her husband was at lunch, she took a wooden pestle (Onake) and killed the soldiers one by one as they emerged from the hole, saving the fort until the guards were alerted.",
        "Modern Edge": "The lesson is Individual Agency. Obavva didn't wait for the army or even her husband. She saw a problem and fixed it with what she had in her hand. Never underestimate your power to change a situation just because you feel small or unsupported."
      },
      {
        "Title": "Vasudev Balwant Phadke: The Father of Armed Rebellion",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The clerk who left his job to start a revolution.",
        "Description": "Moved by the plight of farmers during the famine, Phadke formed a revolutionary group of Ramoshis and Dhangars. He led raids against British communications and treasuries in Maharashtra, aiming to establish an Indian Republic. He was the first to use organized guerrilla warfare against the British in the 19th century.",
        "Modern Edge": "The lesson is Courage of Conviction. Phadke left the safety of a stable life because his heart couldn't ignore the suffering of others. Living a meaningful life often requires stepping out of your comfort zone to stand up for what is right."
      },
      {
        "Title": "Tirupur Kumaran: Kodi Kaatha Kumaran",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The man who died holding the flag aloft.",
        "Description": "During a protest against the British in 1932, Kumaran was brutally assaulted by the police. Even as he fell unconscious and eventually died from his injuries, he refused to let the Indian National Flag touch the ground. He is remembered in Tamil Nadu as the hero who 'protected the flag'.",
        "Modern Edge": "The lesson is Devotion to a Higher Cause. Kumaran’s physical body failed, but his spirit stayed upright through his commitment to the flag. When you live for something bigger than yourself, you find a strength that even physical pain cannot break."
      },
      {
        "Title": "Narayana Pandita: The Master of Combinatorics",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The 14th-century mathematician who explored 'Magic Squares'.",
        "Description": "Narayana Pandita's 'Ganita Kaumudi' contains the earliest known discussion of combinatorics and magic squares in India. He developed methods to calculate the number of permutations of a set and explored sequence patterns that predate modern Western mathematics, showing that Indian logic was deeply experimental and numerical.",
        "Modern Edge": "The lesson is Perspective. A magic square is just the same numbers seen in a new way. When you feel stuck in life, remember that the elements of your situation haven't changed, but how you arrange them can create perfect balance."
      },
      {
        "Title": "Lagadha: The Father of Indian Astronomy",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who authored the Vedanga Jyotisha.",
        "Description": "Lagadha was one of the first to systematize astronomy to determine the timing for Vedic rituals. He calculated the solstices and the lunar cycles with high accuracy around 1200 BCE. His work laid the foundation for the 'Panchang' system that Indians use to this day to understand the movements of celestial bodies.",
        "Modern Edge": "The lesson is Patience and Timing. Everything in the universe has a rhythm. If you are struggling, it might just be that the season isn't right. Learn to watch the cycles of your own life with the same patience Lagadha watched the stars."
      },
      {
        "Title": "The Lion of Gondwana: Raja Bakht Buland Shah",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The ruler who founded the city of Nagpur.",
        "Description": "Bakht Buland Shah was a visionary Gond ruler who transformed a series of small villages into the thriving city of Nagpur. He invited craftsmen, merchants, and farmers from all over India to settle in his kingdom, creating a multicultural hub of trade and agriculture that remains one of India's most important cities today.",
        "Modern Edge": "The lesson is Inclusivity. A great life isn't built in isolation. Bakht Buland Shah created greatness by welcoming others and creating space for them to thrive. Your own growth is often tied to how much you help those around you grow."
      },
      {
        "Title": "Rani Avantibai Lodhi of Ramgarh",
        "Category": "Freedom Fighters",
        "Region": "Central",
        "Summary": "The first female martyr of the 1857 revolution in MP.",
        "Description": "When the British took over Ramgarh using the Doctrine of Lapse, Rani Avantibai raised an army of 4,000. She personally led her troops into battle and defeated the British in the first encounter. When finally surrounded, she chose to die by her own sword rather than be captured, stating that she belonged to her land, not to the crown.",
        "Modern Edge": "The lesson is Self-Ownership. Avantibai believed that her life and her honor belonged to her, not to an outside force. It is a reminder that no matter what the world takes from you, your soul and your choices remain yours alone."
      },
      {
        "Title": "The Battle of Bhadli",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The final stand of the Jethwa clan.",
        "Description": "This battle represents the fierce internal rivalries and external pressures of the Saurashtra region. It highlights the 'Paaliyas' (hero stones) culture of Gujarat, where warriors fought to protect their villages and cattle, proving that valor was not just for emperors but for every village chieftain.",
        "Modern Edge": "The lesson is Ordinary Heroism. You don't need a crown to be a hero. Protecting your home, your family, and your small community is as noble as leading an empire. Valor is found in the everyday choice to protect what you love."
      },
      {
        "Title": "The Battle of Topra",
        "Category": "Battles",
        "Region": "North",
        "Summary": "Firoz Shah Tughlaq’s encounter with the Ashokan Pillars.",
        "Description": "While not a battle between armies, this was a battle of engineering. Tughlaq was so fascinated by the massive Ashokan pillars at Topra that he devised an elaborate system involving silk cotton and thousands of laborers to transport them to Delhi without a single crack, showing the enduring awe ancient Indian engineering inspired.",
        "Modern Edge": "The lesson is Respect for Ancestry. Even a powerful ruler stopped to admire the wisdom of those who came before him. We are all standing on pillars built by our ancestors. Take a moment to appreciate the heritage that holds you up today."
      },
      {
        "Title": "The 1200 Architects of Konark",
        "Category": "Forgotten Heroes",
        "Region": "East",
        "Summary": "The anonymous masters who built the Sun Temple.",
        "Description": "The Sun Temple at Konark was built by 1,200 craftsmen over 12 years. The legend of Dharmapada tells of the chief architect's son who completed the temple's crown when the masters failed. To save the reputation of the 1,200 workers from the King's wrath, the boy jumped into the sea, sacrificing himself for his community.",
        "Modern Edge": "The lesson is Selfless Contribution. Dharmapada didn't finish the temple for fame; he did it to save his people. Sometimes, the most important work you do will be anonymous, done simply because it needed to be finished and because you cared for your community."
      },
      {
        "Title": "Matangini Hazra: The Old Lady Gandhi",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The 73-year-old who faced British bullets for the flag.",
        "Description": "In 1942, during the Quit India Movement, Matangini Hazra led a peaceful procession in Bengal. Even after being shot repeatedly by British police, she kept marching and chanting 'Vande Mataram,' holding the Tricolour high so it wouldn't fall until she collapsed. Her bravery shamed the armed soldiers who faced her.",
        "Modern Edge": "The lesson is Purpose Beyond Age. People often think their time to make an impact has passed. Matangini shows that as long as you have breath, you can stand for something. Your age is not a limit to your courage."
      },
      {
        "Title": "Dharmapala and the Nalanda Renaissance",
        "Category": "Scholars",
        "Region": "East",
        "Summary": "The king who made India the global center of learning.",
        "Description": "Emperor Dharmapala of the Pala Dynasty revived Nalanda and founded Vikramshila University. Under his patronage, these centers housed 10,000 students and 2,000 teachers from across Asia. They taught everything from logic and grammar to medicine and star-mapping, preserving the world's knowledge in 'Dharmaganja', the massive nine-story library.",
        "Modern Edge": "The lesson is the Power of Mind. Dharmapala knew that a kingdom's true strength isn't in its swords, but in its knowledge. Invest in your own mind; it is the only asset that no one can ever take from you and that grows the more you share it."
      },
      {
        "Title": "Atisa Dipamkara: The Light of Asia",
        "Category": "Scholars",
        "Region": "East",
        "Summary": "The Bengali scholar who traveled to Tibet to restore peace.",
        "Description": "Atisa was a high priest at Vikramshila. In the 11th century, at the age of 60, he crossed the treacherous Himalayas on foot to reach Tibet. He translated hundreds of Sanskrit texts and reformed the spiritual practices of the region, creating a cultural bridge between India and the roof of the world that exists to this day.",
        "Modern Edge": "The lesson is Serving the World. Atisa could have stayed in the comfort of a great university, but he chose to travel to a difficult place to help others. True fulfillment comes when you take what you know and use it to light the way for someone else."
      },
      {
        "Title": "Hemachandracharya: The Omniscient",
        "Category": "Scholars",
        "Region": "West",
        "Summary": "The 12th-century polymath of Gujarat.",
        "Description": "A scholar in the court of Kumarapala, Hemachandracharya wrote the 'Siddha-Hema-Shabdanushasana', a comprehensive grammar. He was a master of logic, mathematics, and history. He is credited with describing the 'Fibonacci' sequence patterns in Sanskrit poetry long before Leonardo Fibonacci was born in Italy.",
        "Modern Edge": "The lesson is Curiosity. Hemachandracharya saw patterns in poetry that were actually math. If you keep your mind open, you will find beauty and logic in the most unexpected places. Life is full of secrets waiting for a curious heart."
      },
      {
        "Title": "The Republics of the Licchavis",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The world's first successful experiments with democracy.",
        "Description": "Long before the Greeks, the Licchavis of Vaishali practiced a 'Gana-Sangha' (republican) form of government. Decisions were made in a central assembly (Santhagara) where members voted using wooden pieces called 'Salakas'. They proved that collective leadership and the rule of law could govern a prosperous and stable society.",
        "Modern Edge": "The lesson is Listening. The Licchavis flourished because they valued the voices of many over the ego of one. In your own life and family, remember that the best decisions come when everyone has a voice and everyone is heard."
      },
      {
        "Title": "Rani Naiki Devi: The Vanquisher of Ghori",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Queen of Gujarat who defeated Muhammad Ghori.",
        "Description": "In 1178 CE, Muhammad Ghori invaded Gujarat. Rani Naiki Devi, the regent queen, took her young son on her lap and led the Solanki army into the rugged terrain of Kayadara. She utilized the geography to trap Ghori's forces, inflicting such a crushing defeat that he did not dare attack India for another 13 years.",
        "Modern Edge": "The lesson is Maternal Strength. Naiki Devi fought with a child in her lap. It is a powerful image of how we often have to balance being protectors and warriors at the same time. You are capable of handling your responsibilities and your battles simultaneously."
      },
      {
        "Title": "The Battle of Sammel",
        "Category": "Battles",
        "Region": "West",
        "Summary": "Sher Shah Suri’s narrow escape against the Rathores.",
        "Description": "In 1544, Sher Shah Suri faced the Marwar army led by Jaita and Kumpa. Despite having a massive army, Sher Shah was nearly defeated by the sheer ferocity of the 12,000 Rajput warriors. After the victory, he famously remarked: 'For a handful of bajra (millet), I had almost lost the empire of Hindustan.'",
        "Modern Edge": "The lesson is Not Risking the Essential. We often chase small, shiny things and risk our entire peace of mind for them. Sher Shah’s regret is a warning: do not gamble your 'Empire' (your family, your health, your soul) for a 'Handful of Millet' (a petty argument or a small greed)."
      },
      {
        "Title": "The Siege of Janjira",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The unconquerable sea fort that resisted all powers.",
        "Description": "For centuries, the Marathas, British, and Portuguese tried to capture the sea fort of Janjira, held by the Siddis. Despite massive naval blockades and even attempts to build a stone bridge through the sea by Sambhaji Maharaj, the fort remained independent, highlighting the importance of naval architecture and defensive planning.",
        "Modern Edge": "The lesson is Unshakeable Identity. Janjira stood in the middle of a turbulent sea, surrounded by enemies, yet it never fell. In a world that constantly tries to change you, be like Janjira—stay rooted in who you are, no matter how hard the waves hit."
      },
      {
        "Title": "The Nameless Weavers of Muslin",
        "Category": "Forgotten Heroes",
        "Region": "East",
        "Summary": "The masters of 'Woven Air' that the world envied.",
        "Description": "The weavers of Dhaka and Bengal produced Muslin, a fabric so fine a 50-meter roll could pass through a thumb ring. When the British industrial revolution began, they couldn't compete with this quality. Legend says the British cut the thumbs of these master weavers to destroy the industry, a dark chapter in the history of Indian craftsmanship.",
        "Modern Edge": "The lesson is Dignity in Excellence. These weavers reached the absolute peak of human skill. Though their thumbs were cut, their legend remains. It’s a reminder that true excellence is a form of resistance; even if someone tries to stop you, the beauty of what you created can never be forgotten."
      },
      {
        "Title": "Vandevi: The Warrior of the Forests",
        "Category": "Forgotten Heroes",
        "Region": "Central",
        "Summary": "The tribal woman who protected the sacred groves.",
        "Description": "In the tribal belts of Central India, oral traditions tell of Vandevi, who organized forest dwellers to protect their sacred 'Sarnas' from being cut down for colonial timber. She taught her people that the forest was not a resource to be sold, but a parent to be protected, predating the modern Chipko movement by centuries.",
        "Modern Edge": "The lesson is the Sanctity of Foundations. Vandevi teaches us that some things are too sacred to be traded for temporary gain. If you compromise your core values or your environment for a quick 'win,' you invite total collapse. Protect your 'Sacred Grove'—the principles that sustain you—to ensure a meaningful future."
      },
      {
        "Title": "Sawai Jai Singh II and Jantar Mantar",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The King who built the world's largest stone sundials.",
        "Description": "In the early 18th century, Maharaja Jai Singh II built five astronomical observatories called Jantar Mantars. Dissatisfied with small brass instruments, he built massive stone structures to measure time, track stars, and predict eclipses with an accuracy of within two seconds. The Samrat Yantra in Jaipur remains the largest stone sundial in the world.",
        "Modern Edge": "The lesson is Upgrading Your Perspective. When your current tools give you 'fuzzy' results, don't just work harder—build a better framework. Jai Singh realized that precision requires a stable, massive foundation. If you want accuracy in your life and decisions, you must build deeper, more reliable habits."
      },
      {
        "Title": "The Iron-Cased Rockets of Hyder Ali",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The invention that birthed modern rocket science.",
        "Description": "During the Anglo-Mysore Wars, Hyder Ali and Tipu Sultan developed the first iron-cased rockets. Unlike the bamboo rockets used in China, the iron casing allowed for higher internal pressure and longer ranges (up to 2km). After the wars, the British took these rockets to England to develop the Congreve rocket, directly influencing modern missile technology.",
        "Modern Edge": "The lesson is the Power of the Container. Hyder Ali took an old idea and changed the 'containment.' In your life, the 'material' of your character matters. By strengthening your internal discipline (the iron casing), you can handle much higher pressure and reach goals that were previously impossible."
      },
      {
        "Title": "The Sangam Scholars and the First Academy",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The 2,000-year-old literary tradition of Tamil Nadu.",
        "Description": "The Sangam periods were massive gatherings of poets and scholars in Madurai. They produced a body of work (Ettuthogai and Pattupattu) that is remarkable for its focus on secular life, ethics, and nature. They developed a unique classification of 'Thinai' (landscapes), mapping human emotions to the specific geography of the land.",
        "Modern Edge": "The lesson is Emotional Mapping. The Sangam scholars realized that our feelings are often tied to our surroundings. To understand yourself, look at your 'landscape.' By categorizing your experiences and emotions within their proper context, you gain clarity and a deeper connection to nature."
      },
      {
        "Title": "The Magnanimity of Raja Paari",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who gave his chariot to a climbing jasmine plant.",
        "Description": "One of the 'Seven Great Patrons' (Kadai Ezhu Vallalgal) of the Sangam era, King Paari was famous for his empathy. Legend says that while traveling, he saw a weak jasmine creeper with no support. He left his royal chariot in the forest so the plant could climb on it, symbolizing that a ruler's duty extends to all living beings, not just humans.",
        "Modern Edge": "The lesson is Ego-less Support. Raja Paari gave up his most prized possession for a tiny, fragile life. It teaches us that true greatness is found in using your strength to support those who have none. Sometimes, leaving your 'chariot' behind is the most noble thing you can do."
      },
      {
        "Title": "Amoghavarsha I: The Scholar Emperor",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Rashtrakuta king known as the 'Ashoka of the South'.",
        "Description": "Amoghavarsha I ruled for 64 years, one of the longest reigns in history. He was a deeply religious and scholarly man who wrote the 'Kavirajamarga', the earliest available work on Kannada poetics. He was known for his peace-loving nature, choosing to solve conflicts through diplomacy and culture rather than constant warfare.",
        "Modern Edge": "The lesson is Peace as a Long-term Strategy. While others sought glory through war, Amoghavarsha sought it through culture and poetics. He proved that a life built on intellectual and spiritual foundations lasts much longer than one built on aggression. Focus on building community, not winning arguments."
      },
      {
        "Title": "The Battle of Koppam",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The Chola victory led by a king crowned on the battlefield.",
        "Description": "In 1054 CE, the Chola and Chalukya armies met in a brutal conflict. The Chola King Rajadhiraja was killed while leading from the front on an elephant. His younger brother, Rajendra II, didn't retreat. He immediately took the command, was crowned king right there on the battlefield, and turned a certain defeat into a massive victory.",
        "Modern Edge": "The lesson is Decisive Continuity. When tragedy strikes, the worst thing you can do is hesitate. Rajendra II showed that by stepping into responsibility immediately, you prevent panic from setting in. In a crisis, don't wait for the 'perfect' ceremony—take charge and move forward."
      },
      {
        "Title": "The Battle of Merta",
        "Category": "Battles",
        "Region": "West",
        "Summary": "A display of unmatched cavalry bravery.",
        "Description": "In 1790, the Maratha forces under De Boigne faced the Rathore cavalry of Jodhpur. The Rathores performed a legendary 'death charge', riding straight into the mouth of modern artillery. Though they lost due to the technological gap, their bravery was so immense that the French generals in the Maratha camp saluted them in respect.",
        "Modern Edge": "The lesson is Balancing Heart with Reality. Bravery is admirable, but it cannot overcome a fundamental lack of preparation or tools. This story reminds us to respect our traditions and spirit, but also to stay aware of how the world is changing so that our efforts are not in vain."
      },
      {
        "Title": "The Nameless Sculptors of Ellora",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "Carving a cathedral from a single mountain top-down.",
        "Description": "The Kailasa Temple at Ellora was carved out of a single rock. Unlike most buildings, it was built from the top down. 200,000 tons of rock were removed with only hammers and chisels. The engineering was so precise that even the drainage systems and ventilation were planned before the first strike of the hammer.",
        "Modern Edge": "The lesson is Visionary Discipline. These sculptors started with the end in mind and 'removed' what wasn't necessary. In life, focus on your final vision and subtract the distractions. When you plan with total precision, the 'heavy lifting' becomes an act of art."
      },
      {
        "Title": "Gunda Dhur and the Bhumkal Rebellion",
        "Category": "Forgotten Heroes",
        "Region": "Central",
        "Summary": "The tribal hero of Bastar who fought the British.",
        "Description": "In 1910, Gunda Dhur led the tribes of Bastar against the British forest policies. He used 'Lali Mirchi' (Red chillies) and mango branches as secret signals to mobilize villages. He successfully cut off British communications for weeks, fighting for the 'Bhum' (land) and the rights of the indigenous people.",
        "Modern Edge": "The lesson is Creative Communication. Gunda Dhur used simple, everyday objects to organize a massive movement. It reminds us that you don't need high-tech systems to connect with people; you just need a shared language and a common heart. Use what you have to find your community."
      },
      {
        "Title": "The Battle of the Hydaspes",
        "Category": "Battles",
        "Region": "North",
        "Summary": "How the Paurava resistance broke the morale of the Macedonian army.",
        "Description": "In 326 BCE, the invading forces of Alexander encountered King Porus. While Western accounts claim a Greek victory, the aftermath suggests a different story. The Macedonian army, having faced the ferocity of Indian war-elephants and the unparalleled valor of the Paurava infantry, suffered such heavy casualties that they mutinied. Alexander was forced to stop his campaign and retreat, never reaching the heart of India. Porus remained a powerful sovereign, proving that the Indian defense had successfully blunted the greatest military machine of the West.",
        "Modern Edge": "The lesson is Resilience as a Barrier. You don't always have to 'defeat' an obstacle to make it go away. By standing your ground and making it difficult for an 'invader' (or a negative influence) to stay, you win through persistence. Make the 'cost' of attacking you too high for anyone to pay."
      },
      {
        "Title": "The Wootz Steel Revolution",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The world's first high-carbon steel developed in South India.",
        "Description": "Centuries before the industrial revolution, Indian smiths in the South developed 'Wootz Steel'. By heating iron with charcoal in closed crucibles, they created steel with a high carbon content and a beautiful wavy pattern. This steel was exported to Damascus to make the world-famous 'Damascus Swords', which could cut through a falling silk scarf and never lost their edge.",
        "Modern Edge": "The lesson is Mastering the Core. By focusing on the quality of the 'raw material'—your character and your skills—you create something that becomes a global standard. When your internal quality is high, your external output (the sword) will always be unmatched."
      },
      {
        "Title": "Sarangadhara: The Medieval Veterinarian",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The author of the world's first comprehensive book on plant and animal health.",
        "Description": "In the 13th century, Sarangadhara wrote the 'Upavana Vinoda', detailing the science of 'Vrikshayurveda' (Health of plants). He described how to treat plant diseases, create seed hybrids, and even how to make plants bloom out of season. His work proved that India had a deep ecological science that treated plants as living, feeling beings.",
        "Modern Edge": "The lesson is Nurturing the Source. Sarangadhara knew that if you treat the internal health of a living thing, it will flourish beyond expectations. Apply this to your own growth: focus on your 'roots'—your health and mindset—to produce results that seem 'impossible' to others."
      },
      {
        "Title": "The Strategic Peace of Rani Abakka Chowta",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Queen of Ullal who defeated the Portuguese for 40 years.",
        "Description": "Rani Abakka was the last Tuluva Queen of Ullal. She was a master of diplomacy and naval warfare. For four decades, she repelled Portuguese attacks on her port. She utilized a diverse army of Hindus and Muslims, including the famous 'Mapilla' archers, proving that communal unity was the key to defending India's coastline.",
        "Modern Edge": "The lesson is Strength in Diversity. Rani Abakka built an 'un-hackable' defense by uniting people from different backgrounds under one goal. It teaches us that a diverse group of thinkers and specialists is much more resilient than a uniform one. Unity is your best shield."
      },
      {
        "Title": "Zamorin of Calicut and the Kunjali Marakkars",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The legendary naval admirals of the Malabar coast.",
        "Description": "The Kunjali Marakkars were the hereditary admirals of the Hindu Zamorin of Calicut. They fought a relentless 100-year naval war against the Portuguese. They were the first to use heavy cannon on small, fast ships, successfully challenging the European monopoly over the Indian Ocean for generations.",
        "Modern Edge": "The lesson is Speed beats Bulk. The Marakkars showed that being small and agile with 'heavy' intent is better than being huge and slow. In life, don't worry about being 'big'; focus on being fast and having a clear, powerful purpose. Small moves can topple giants."
      },
      {
        "Title": "The Battle of Saragarhi",
        "Category": "Battles",
        "Region": "North",
        "Summary": "21 Sikh soldiers against 10,000 Afghan tribesmen.",
        "Description": "In 1897, 21 soldiers of the 36th Sikhs defended a signaling post at Saragarhi. Facing an onslaught of 10,000 Afghans, they refused to surrender or retreat. They fought for over seven hours, killing hundreds of the enemy, until the very last man fell. Their sacrifice gave the main fort enough time to prepare for the defense.",
        "Modern Edge": "The lesson is the Duty of the Few. Sometimes, a small group must bear a heavy load to save the whole system. This story reminds us that your individual stand matters. Even if you feel outnumbered, your persistence gives others the time they need to succeed."
      },
      {
        "Title": "The Battle of Kamrup",
        "Category": "Battles",
        "Region": "East",
        "Summary": "The total annihilation of the Bakhtiyar Khalji's army.",
        "Description": "After destroying Nalanda, Bakhtiyar Khalji attempted to invade Tibet through Assam. The King of Kamrup, Prithu, used a 'scorched earth' policy, burning all crops and bridges. The invaders were trapped without food. Of the 10,000 horsemen who entered Assam, only a few dozen managed to return alive, ending the threat to the East.",
        "Modern Edge": "The lesson is Controlling the Ground. Prithu didn't fight a losing head-on battle; he removed the resources the enemy needed to survive. To overcome a major challenge, don't just fight it—change the environment so the problem has no 'fuel' to stay alive."
      },
      {
        "Title": "The Sacrifice of Baba Deep Singh",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The warrior who fought with his head in his hand.",
        "Description": "At the age of 75, Baba Deep Singh vowed to liberate the Golden Temple from Afghan desecrators. During the battle, legend and historical accounts state that even after being fatally wounded in the neck, he supported his head with one hand and continued to wield his sword with the other, reaching the temple complex before finally breathing his last.",
        "Modern Edge": "The lesson is Unstoppable Commitment. Baba Deep Singh proved that when your purpose is deep enough, your 'hardware' (the body) will follow the 'software' (the soul). Never give up on your goal until the final process is complete, no matter the damage taken along the way."
      },
      {
        "Title": "The Nameless Architects of the Tanjore Shadow",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The mystery of the shadow-less Brihadeeswarar Temple.",
        "Description": "The Chola architects designed the main tower (Vimana) of the Tanjore temple so perfectly that at noon during certain times of the year, the shadow of the massive structure never falls on the ground, but only on its own base. This required advanced knowledge of solar angles and architectural geometry that remains a mystery to this day.",
        "Modern Edge": "The lesson is Perfect Alignment. When you align your work perfectly with the world around you, you create no waste and leave no room for error. It is a reminder to study your environment deeply so that your actions are in total harmony with your surroundings."
      },
      {
        "Title": "The Uprising of the Poligars",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "Puli Thevar: The first to refuse tax to the British.",
        "Description": "In 1755, decades before the 1857 mutiny, Puli Thevar of Nellai refused to pay taxes to the British East India Company. He formed a coalition of local chieftains and defeated the British and Nawab forces in several encounters, marking the earliest organized armed resistance to colonial rule in India.",
        "Modern Edge": "The lesson is the Courage to Opt-Out. Puli Thevar was the first to say 'No' to an unfair system. It teaches us that breaking the aura of an 'unbeatable' force starts with one small player standing up. Once the fear is gone, others will follow your lead."
      },
      {
        "Title": "The Vastu Shastra of Maya Danava",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The ancient science of architecture and town planning.",
        "Description": "Maya Danava is the legendary author of the 'Mayamata'. This text describes the mathematical principles of town planning, temple architecture, and sculpture. It categorized soil types, directions, and wind flow to ensure that buildings were not just structures, but living spaces that resonated with the environment's energy.",
        "Modern Edge": "The lesson is Building for Harmony. Don't just build a 'structure' (a career or a house); build a space that flows with your life. Maya Danava teaches us that our environment affects our energy—make sure your surroundings support your peace and growth."
      },
      {
        "Title": "Nagarjuna: The Master of the Middle Way",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The philosopher who pioneered the concept of 'Shunyata' (Emptiness).",
        "Description": "Born in the Satavahana Empire, Nagarjuna is one of the most important Buddhist philosophers after the Buddha himself. His 'Mulamadhyamakakarika' used rigorous logic to prove that all things are interdependent. His philosophy later influenced the development of modern quantum logic and systemic thinking.",
        "Modern Edge": "The lesson is Interdependence. Nagarjuna realized that nothing exists in a vacuum. You are defined by your connections to others and the world. Master the 'Middle Way'—be flexible, remain connected, and realize that your strength comes from your relationships."
      },
      {
        "Title": "The Metallurgy of the Dhar Iron Pillar",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "The massive medieval iron pillar of the Paramara Dynasty.",
        "Description": "While the Delhi pillar is famous, the Iron Pillar of Dhar (Mandu) was once the largest of its kind in the world, standing over 13 meters tall. Created during the reign of Raja Bhoja, it showcased the Paramara dynasty's mastery over forge-welding massive pieces of iron, a feat that European smiths could not replicate for centuries.",
        "Modern Edge": "The lesson is Scaling through Integration. The smiths didn't try to cast one giant piece; they perfectly welded smaller high-quality parts into a monolith. Scale your success by perfecting the way you connect smaller wins together. A great life is many 'one-meter' successes welded together."
      },
      {
        "Title": "Rani Rudrama Devi: The King-Queen",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Kakatiya ruler who dressed as a man to save her kingdom.",
        "Description": "One of the few female monarchs in Indian history, Rudrama Devi was formally designated as a son through a ritual. She led her armies into battle, completed the massive Warangal Fort, and repelled the Yadavas and Cholas. Marco Polo, the Italian traveler, visited her kingdom and praised her as a lady of high intelligence and justice.",
        "Modern Edge": "The lesson is Authenticity through Action. Rudrama Devi didn't let social expectations stop her from leading. In the end, it was her results (the Warangal Fort) that earned respect. Don't worry about 'fitting in'; focus on your results, and the world will adjust its expectations."
      },
      {
        "Title": "Prataparudra Deva and the Gajapati Might",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The Lords of the Elephants who ruled the Eastern Coast.",
        "Description": "The Gajapati Kings of Odisha were known as 'Lords of the Elephants' because of their massive elephantry. Prataparudra Deva defended the sovereignty of Odisha against the combined pressures of the Vijayanagara Empire and the Sultanates, while also being a great patron of Sri Chaitanya Mahaprabhu and the arts.",
        "Modern Edge": "The lesson is Heavy Defense. Prataparudra maintained 'elephants' (strong internal values and infrastructure) that made it too difficult for rivals to push him over. To survive a difficult season, invest in your personal 'elephants'—those solid skills and values that no one can easily dismantle."
      },
      {
        "Title": "Vikramaditya VI: The Chalukya-Vikrama Era",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who started his own calendar.",
        "Description": "A powerful ruler of the Western Chalukyas, Vikramaditya VI abolished the old Shaka era and started the 'Vikrama-Chalukya era'. His reign was a golden age for Kannada and Sanskrit literature. He was known for his massive temple-building projects and for maintaining a peaceful empire for over 50 years.",
        "Modern Edge": "The lesson is Defining Your Own Time. Vikramaditya didn't just follow the old clock; he started his own era. It reminds us that you have the power to reset your own life 'calendar.' Stop living by other people's timelines and start your own era of growth."
      },
      {
        "Title": "The Battle of Venni",
        "Category": "Battles",
        "Region": "South",
        "Summary": "Karikala Chola's decisive victory over a grand coalition.",
        "Description": "In this ancient battle, the young Karikala Chola faced a massive coalition of the Cheras, Pandyas, and eleven minor chieftains. Despite being outnumbered, his strategic use of his infantry and his personal valor led to a total victory, establishing the Cholas as the dominant power of the Sangam era.",
        "Modern Edge": "The lesson is Breaking the Coalition of Doubts. Karikala didn't fight everyone at once; he found the weakest link in the alliance against him. When facing a group of problems, don't be overwhelmed—find the one 'weak link' and strike there. Once the first problem falls, the rest follow."
      },
      {
        "Title": "The Battle of Bahraich",
        "Category": "Battles",
        "Region": "North",
        "Summary": "Raja Suheldev’s stand against the Ghaznavid invasion.",
        "Description": "When Salar Masud, nephew of Mahmud of Ghazni, invaded with a massive army, Raja Suheldev of Shravasti united the local chieftains. At the Battle of Bahraich in 1033 CE, the invading army was completely annihilated. This victory was so decisive that no major foreign invasion from the North-West occurred for the next 150 years.",
        "Modern Edge": "The lesson is the Power of Decisive Action. Suheldev teaches us that when you face a threat, a halfway defense is not enough. By addressing a problem with total focus and strength, you don't just solve it for today—you create a boundary of peace and respect that lasts for generations."
      },
      {
        "Title": "The Sacrifice of 363 Bishnois",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "Amrita Devi and the first environmental protest.",
        "Description": "In 1730, when the King of Jodhpur sent soldiers to cut Khejri trees for a new palace, Amrita Devi Bishnoi hugged the trees to protect them. She said, 'A chopped head is cheaper than a felled tree.' She and 362 others sacrificed their lives, eventually forcing the King to pass a permanent decree protecting the trees and wildlife.",
        "Modern Edge": "The lesson is Radical Integrity. The Bishnois proved that some values are more important than personal survival. In a world that often asks you to compromise your principles for comfort, remember that standing by your truth—even at a great cost—is the only way to create lasting change."
      },
      {
        "Title": "The Architects of the Modhera Sun Temple",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "Designing a temple where the sun kisses the deity.",
        "Description": "Built by the Solanki dynasty, the Modhera Sun Temple is a mathematical marvel. Its design ensures that on the equinoxes, the first rays of the rising sun fall directly on the diamond-studded crown of the Sun God. The intricate 'Kund' (stepped tank) in front is a masterpiece of geometry and water conservation.",
        "Modern Edge": "The lesson is Patient Alignment. The architects didn't try to force the sun to shine; they designed the temple to be ready when the sun arrived. In life, don't rush or 'spam' your efforts. Align your habits and character so that when the right opportunity arises, you are perfectly positioned to capture the light."
      },
      {
        "Title": "Varahamihira: The Ancient Meteorologist",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "Predicting rainfall and earthquakes in the 6th century.",
        "Description": "Varahamihira was a polymath in the court of Ujjain. In his work 'Brihat Samhita', he outlined the 'Science of Clouds', explaining how to predict rainfall based on the shape of clouds and the behavior of animals. He was also the first to propose that earthquakes were caused by internal shifts in the earth’s elements, long before modern seismology was born.",
        "Modern Edge": "The lesson is Awareness of Subtle Changes. Varahamihira teaches us that major life 'earthquakes' are rarely sudden; they are preceded by internal shifts. By paying attention to the small signs and the 'shape of the clouds' in your own life, you can prepare yourself long before the storm hits."
      },
      {
        "Title": "The Architecture of the Vakatakas",
        "Category": "Scholars",
        "Region": "Central",
        "Summary": "The dynasty that patronized the Ajanta Caves.",
        "Description": "The Vakatakas were the contemporaries of the Guptas. Under Queen Prabhavatigupta (daughter of Chandragupta II), they created the world-famous rock-cut Buddhist viharas and chaityas at Ajanta. Their scholars preserved the techniques of 'fresco' painting, using natural minerals to create colors that remain vibrant even after 1,500 years.",
        "Modern Edge": "The lesson is Substance over Hype. The Vakatakas didn't use cheap, flashy materials; they used deep, natural minerals. If you want your personal legacy or work to remain vibrant for a lifetime, invest in 'mineral-grade' quality—depth, honesty, and hard work—rather than temporary trends that fade in the sun."
      },
      {
        "Title": "Dhanvantari: The God of Ayurveda",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The legendary surgeon of the early Vedic era.",
        "Description": "Dhanvantari is regarded as the father of Indian medicine. Historically, his lineage of scholars perfected the use of salt as an antiseptic and leeches for blood purification. He taught that surgery should only be performed when the body’s internal 'Doshic' balance could not be restored through herbs and diet.",
        "Modern Edge": "The lesson is Preventative Care. Dhanvantari viewed extreme measures as a last resort. In your daily life, fix the 'imbalances'—your stress, your habits, and your relationships—with small, consistent changes. Don't wait until a crisis forces you to make a painful 'amputation' in your life."
      },
      {
        "Title": "Suhungmung: The Architect of Greater Assam",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The Ahom king who modernized the administration.",
        "Description": "Suhungmung was one of the most important Ahom kings. He was the first to adopt a Hindu title (Swarganarayana) and expanded the kingdom to include various local tribes, creating a unified Assamese identity. He introduced the use of firearms in the Ahom army, which later became the backbone of their resistance against the Mughals.",
        "Modern Edge": "The lesson is Inclusive Growth. Suhungmung didn't just conquer; he integrated. He took different groups and gave them a shared identity and better tools. To build a great life or community, bring people together and help them upgrade their skills immediately. Unity and progress must go hand-in-hand."
      },
      {
        "Title": "The Jaintia Kings and the Living Root Bridges",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "Engineering with nature in the hills of Meghalaya.",
        "Description": "The Jaintia and Khasi kings encouraged a unique form of bio-engineering. Instead of building stone bridges that would wash away in heavy rain, they guided the roots of Ficus trees across rivers. Over decades, these grew into 'Living Root Bridges' that grow stronger with age and can hold the weight of 50 people at once.",
        "Modern Edge": "The lesson is Nurturing Growth over Static Building. Instead of building something 'hard' that can break, grow something 'living' that gets stronger with time. In your habits and relationships, focus on slow, natural growth. The more 'weight' and 'traffic' a living system handles, the tougher it becomes."
      },
      {
        "Title": "Lakshmana Sena: The Last Great Sena King",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "A patron of literature and the defender of Bengal.",
        "Description": "Lakshmana Sena was a great conqueror who expanded the Sena Empire into Bihar and Odisha. He was a poet himself and his court was graced by Jayadeva, the author of 'Gita Govinda'. Despite his old age, he maintained a high standard of justice and cultural patronage that marked the final golden era of ancient Bengal.",
        "Modern Edge": "The lesson is Grace in Transitions. Lakshmana Sena knew his era was coming to an end, yet he never lowered his standards of justice or culture. Even if you are leaving a job, a home, or a phase of life, do so with excellence. How you finish a chapter defines your legacy as much as how you started it."
      },
      {
        "Title": "The Siege of Gingee Fort",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The 'Troy of the East' that stood for 8 years.",
        "Description": "Gingee Fort in Tamil Nadu was so well-fortified that the Mughal army had to siege it for eight years to capture it from the Marathas. Its unique three-hill structure and sophisticated water supply system allowed a small garrison to defy an empire, proving the superiority of Indian hill-fort engineering.",
        "Modern Edge": "The lesson is Resilience through Redundancy. Gingee wasn't just one peak; it was three hills sharing one system. In your own life, don't rely on just one source of strength or joy. By having 'three hills'—perhaps your family, your passions, and your inner faith—you can survive a long 'siege' of hardship."
      },
      {
        "Title": "The Nameless Smiths of the Damascus Blade",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Gujarati and Rajasthani smiths of the Sirohi sword.",
        "Description": "The Sirohi region was world-famous for its swords. The local smiths (Lohars) perfected a specific curvature and tempering process that made the Sirohi sword the favorite of Rajput warriors. These swords were exported globally, but the names of the master craftsmen who perfected the carbon-tempering remain lost to history.",
        "Modern Edge": "The lesson is Personal Mastery over Recognition. These smiths didn't care about their names being known; they cared about the edge of the blade. True mastery is its own reward. If you focus on making your 'craft'—your character and skill—perfect, the world will seek you out even if you remain in the shadows."
      },
      {
        "Title": "Rana Sanga: The Warrior of Eighty Scars",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Rajput king who fought despite losing an eye, an arm, and a leg.",
        "Description": "Maharana Sangram Singh, or Rana Sanga, was the head of the Rajput confederacy. He was a veteran of countless battles and bore 80 scars from swords and lances on his body. He was the last ruler who successfully united the various Rajput clans under one banner to defend the heartland against foreign invasions from the North.",
        "Modern Edge": "The lesson is Leadership through Sacrifice. Rana Sanga had 'proof' of his commitment written on his body. You cannot inspire others to work hard or stay united unless you have been willing to 'bleed' for the cause more than anyone else. Credibility is earned through the scars of your efforts."
      },
      {
        "Title": "The Strategic Foresight of Shahu Maharaj",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Chhatrapati who empowered the Peshwas and expanded the Maratha Empire.",
        "Description": "Chhatrapati Shahu, grandson of Shivaji Maharaj, was instrumental in transforming the Maratha state into a pan-Indian empire. He had the vision to recognize the talent of Balaji Vishwanath and Bajirao I, delegating authority to capable leaders while maintaining the central pillar of the Maratha identity. Under his reign, the Maratha flag reached from Cuttack to Attock.",
        "Modern Edge": "The lesson is the Power of Delegation. Shahu Maharaj realized that he didn't need to do everything himself to be a great leader. He found talented people and gave them the freedom to act. In your life, learn to trust others and empower them. You achieve more when you stop trying to 'operate' and start supporting talent."
      },
      {
        "Title": "Rao Jodha and the Creation of Mehrangarh",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The founder of Jodhpur and the invincible 'Citadel of the Sun'.",
        "Description": "Rao Jodha moved his capital to a 400-foot high cliff to ensure better defense. He built the Mehrangarh Fort, an engineering marvel with walls so thick that they remained unscathed by heavy cannon fire. His strategic shift ensured the survival and prosperity of the Rathore clan for centuries.",
        "Modern Edge": "The lesson is Seeking the High Ground. When life feels too chaotic or 'noisy,' move your focus to a higher plane. Rao Jodha teaches us to step away from the distractions and 'plains' of mediocrity to build our character where the 'cannon fire' of daily life cannot reach us."
      },
      {
        "Title": "The Stepwells of Rajasthan: Geometric Engineering",
        "Category": "Ancient Science",
        "Region": "West",
        "Summary": "Chand Baori and the science of desert water conservation.",
        "Description": "In the arid deserts of Rajasthan, ancient engineers built stepwells (Baoris) like Chand Baori. With 3,500 narrow steps over 13 stories, these structures were designed to reach the groundwater while keeping the water cool through a unique microclimate created by the geometric architecture. It is a masterclass in combining aesthetics with survival science.",
        "Modern Edge": "The lesson is Finding Depth in Dry Seasons. When life feels 'dry' and resources are low, don't look across the surface; look deeper within. By 'drilling down' into your own resilience and using a structured, disciplined approach, you can find the 'groundwater' that keeps you cool and steady."
      },
      {
        "Title": "Savithribai Phule: The Pioneer of Education",
        "Category": "Scholars",
        "Region": "West",
        "Summary": "The first female teacher of India who fought social stigma.",
        "Description": "Savithribai, along with her husband Jyotirao Phule, opened the first school for girls in Pune in 1848. Despite people throwing mud and stones at her while she walked to school, she carried a second sari and continued teaching. She broke the monopoly of knowledge and paved the way for modern Indian women's education.",
        "Modern Edge": "The lesson is Practical Persistence. Savithribai knew people would 'throw mud' at her for doing the right thing, so she simply carried a spare sari. When you are trying to do good, expect criticism. Don't let it stop you—just have a 'backup' plan to clean yourself up and keep going."
      },
      {
        "Title": "The Battle of Palkhed",
        "Category": "Battles",
        "Region": "West",
        "Summary": "Bajirao I's masterclass in mobile warfare.",
        "Description": "In 1728, Peshwa Bajirao I faced the Nizam of Hyderabad. Instead of a direct clash, Bajirao used lightning-fast cavalry movements to cut off the Nizam's supplies and artillery. He forced the superior Mughal-style army into a waterless region, compelling the Nizam to surrender without a major bloodshed. It is studied globally as a masterpiece of strategic maneuvering.",
        "Modern Edge": "The lesson is Agility over Force. You don't always have to face a giant problem head-on. Bajirao shows us that by being fast and cutting off the 'fuel' that feeds a conflict, you can win without unnecessary struggle. Use your speed and wits to lead your problems into a place where they lose their power."
      },
      {
        "Title": "The Battle of Dewair",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The 'Marathon of Mewar' where Maharana Pratap reclaimed his land.",
        "Description": "Often overshadowed by Haldighati, the Battle of Dewair in 1582 was a decisive victory for Maharana Pratap. Using the guerrilla tactics he perfected in the Aravallis, he decimated the Mughal garrisons. This battle forced the Mughals to abandon their outposts in Mewar, proving that Pratap's persistence had finally turned the tide.",
        "Modern Edge": "The lesson is Persistence as Victory. You don't need a total win on the first day. By consistently chipping away at a challenge and refusing to leave, you eventually make it too 'expensive' for the problem to stay in your life. Persistence is the force that turns the tide."
      },
      {
        "Title": "The Courage of Rani Hadi",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Queen who sacrificed her life to send her husband to war.",
        "Description": "When the newlywed Rao Ratan Singh hesitated to go to battle because of his love for his wife, Rani Hadi. To remove his distraction and remind him of his duty to the land, she cut off her own head and sent it to him as a 'souvenir.' Heartbroken but inspired, the Rao fought like a lion, securing the victory for his people.",
        "Modern Edge": "The lesson is Removing Hesitation. While the story is extreme, it teaches that deep attachment can sometimes cloud our sense of duty. If your focus is divided, you cannot succeed. Identify what is distracting you from your highest path and have the courage to 'cut the cord' of that distraction."
      },
      {
        "Title": "Durgadas Rathore: The Unconquerable",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The man who protected the heir of Marwar for 30 years.",
        "Description": "Durgadas Rathore fought a relentless guerrilla war against the Mughal Emperor Aurangzeb to protect the infant Prince Ajit Singh. For three decades, he lived in the deserts and forests, refusing bribes and facing every hardship to ensure the Rathore bloodline survived. He is remembered as the 'Ulysses of Rajputana'.",
        "Modern Edge": "The lesson is Long-Term Stewardship. Durgadas teaches us that some tasks take decades, not days. If you have a 'future hope' or a 'child' (a dream or a person) to protect, be prepared to live in the 'wilderness' for as long as it takes. True loyalty is measured in years, not moments."
      },
      {
        "Title": "The Martyrs of the Mulshi Satyagraha",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The world's first anti-dam struggle led by Senapati Bapat.",
        "Description": "In the 1920s, the farmers of Mulshi, Maharashtra, fought against the forced acquisition of their land for a hydroelectric project. Led by Pandurang Mahadev 'Senapati' Bapat, this was one of the earliest environmental and land-rights movements in India, blending the spirit of Swaraj with the rights of the tiller.",
        "Modern Edge": "The lesson is Protecting the Source. The farmers knew that without their land, they had no independence. It is a reminder to never trade your 'soil'—the foundational parts of your life like health and family—for 'temporary progress' offered by someone else."
      },
      {
        "Title": "Raja Bhoja: The Polymath King",
        "Category": "Scholars",
        "Region": "Central",
        "Summary": "The ruler who wrote 84 books on science, arts, and engineering.",
        "Description": "Raja Bhoja of the Paramara dynasty was a true 'Vidyapati'. His work 'Samarangana Sutradhara' is a detailed treatise on civil engineering, town planning, and even mechanical devices (Yantras). He established the Bhojshala, a university for Sanskrit studies, and built the Bhojeshwar Temple, which houses one of the largest monolithic Shivlingas in India.",
        "Modern Edge": "The lesson is Being a Scholar-Builder. Raja Bhoja didn't just study; he created. He proved that the best knowledge is the kind that results in a 'monolith'—something real and solid. Don't just research your life; build it as you learn."
      },
      {
        "Title": "Kamalakara and the Geometry of the Sphere",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The 17th-century scholar who bridged Indian and Islamic astronomy.",
        "Description": "Kamalakara wrote the 'Siddhanta Tattva Viveka', where he introduced trigonometric concepts to calculate planetary positions with incredible precision. He lived in Varanasi and was one of the few scholars who successfully integrated traditional Indian mathematical logic with the astronomical findings of the Persian and Arabic worlds.",
        "Modern Edge": "The lesson is Synthesis over Exclusion. Kamalakara didn't ignore ideas just because they were 'foreign.' He took the best findings from around him and added them to his own logic. To be wise, learn from everyone and build a model that is as accurate as possible."
      },
      {
        "Title": "The Chandelas and the Fortress of Kalinjar",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The kings who built the world-famous Khajuraho temples.",
        "Description": "The Chandela Rajputs were masters of architecture and defense. While they are world-famous for the intricate temples of Khajuraho, their true strength lay in the Kalinjar Fort. This fort was considered 'Kala-jar' (one who has conquered time) because of its impregnable walls and strategic location, surviving dozens of sieges over 500 years.",
        "Modern Edge": "The lesson is Balancing Beauty and Strength. The Chandelas had 'Khajuraho' (art and beauty) but they kept 'Kalinjar' (strength and security). In your life, it is good to have art and culture, but you must keep your 'fortress'—your inner strength and resources—impregnable to survive the hard times."
      },
      {
        "Title": "Nana Patil and the Patri Sarkar",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The parallel government that challenged British rule in Maharashtra.",
        "Description": "In 1943, Krantisimha Nana Patil established a parallel government (Prati Sarkar) in Satara. They set up their own courts, shadow administration, and supply lines, effectively ending British control in the region for nearly two years. It was the most successful and longest-running parallel government during the Quit India movement.",
        "Modern Edge": "The lesson is Building your own System. Nana Patil didn't just protest a broken government; he built a functioning one alongside it. If you find yourself in a system that doesn't work, don't just complain—build your own 'parallel' way of living and working until the old one becomes unnecessary."
      },
      {
        "Title": "The Maritime Wisdom of the Kolis",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The traditional seafaring community that protected the Western coast.",
        "Description": "The Koli community of Maharashtra and Gujarat were the backbone of India's maritime strength. They possessed an ancestral understanding of tides, currents, and monsoon winds. They served as the primary sailors for the Maratha Navy, using their indigenous boats (Galivats and Sangameshwari) to outmaneuver the heavy warships of the European powers.",
        "Modern Edge": "The lesson is Mastery of the Environment. While the 'big ships' had power, the Kolis had 'the tides.' Learn the specific 'winds' and 'currents' of your own life. When you understand the environment better than anyone else, you can outmaneuver even the most powerful opponent."
      },
      {
        "Title": "The Battle of Rakshas Bhuvan",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The Maratha victory that checked the Nizam's expansion.",
        "Description": "In 1763, Madhavrao Peshwa, a young but brilliant leader, faced the Nizam of Hyderabad. Despite the Maratha army being in a state of recovery after Panipat, Madhavrao’s strategic brilliance on the banks of the Godavari river led to a decisive victory, proving that the Maratha spirit was still the dominant force in the Deccan.",
        "Modern Edge": "The lesson is Bouncing Back Quickly. A 'battered' spirit doesn't need long rest; it needs a small, aggressive 'win.' The quickest way to recover your confidence after a failure is to step back into the challenge and prove to yourself that you are still a force to be reckoned with."
      },
      {
        "Title": "The Battle of Kumbher",
        "Category": "Battles",
        "Region": "North",
        "Summary": "The Jat resistance against the Maratha-Mughal siege.",
        "Description": "In 1754, the Jat King Suraj Mal defended the Kumbher Fort against a massive combined force. The Jats used their knowledge of the local terrain and fortifications to withstand a four-month siege. This battle eventually led to a peace treaty, establishing the Jats as a major sovereign power in North India.",
        "Modern Edge": "The lesson is Exhausting the Opposition. If you are being pressured, just stay 'within your walls.' By holding your ground and not letting the 'aggressor' break you, you eventually make them tire out. Peace is often won by the person who can wait the longest."
      },
      {
        "Title": "The 63 Martyrs of the Vedaranyam Salt March",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The Southern response to the Dandi March.",
        "Description": "Led by C. Rajagopalachari in 1930, hundreds marched from Trichy to Vedaranyam to break the salt law. Despite brutal police crackdowns and the British trying to hide all food and water along the route, local villagers risked their lives to feed the marchers, proving that the struggle for freedom was a truly pan-Indian heartbeat.",
        "Modern Edge": "The lesson is the Strength of Community. This march only succeeded because the local villagers provided 'food and water' in a desert. In your own life, build a community that supports you. When the road is hard, it is the quiet support of friends and family that keeps you moving."
      },
      {
        "Title": "The Architects of the Hampi Aqueducts",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "Bringing water to a city of a million people in a rocky desert.",
        "Description": "The engineers of the Vijayanagara Empire built a 40-km long system of stone aqueducts and canals. They used gravity and siphon logic to move water across uneven terrain, ensuring that even during summer, the city's tanks and temple ponds were full. Much of this system still functions today, centuries after the empire fell.",
        "Modern Edge": "The lesson is Architecture over Activity. Instead of constantly 'hauling water' through manual hustle, design your life and habits to use 'natural gravity.' If you set up the right systems once, your life will stay 'hydrated' with peace and progress even during the dry seasons of hardship."
      },
      {
        "Title": "Usha Mehta and the Secret Congress Radio",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The woman who kept the voice of freedom alive underground.",
        "Description": "During the Quit India Movement, when the British banned all news of the struggle, 22-year-old Usha Mehta set up a secret radio station. She moved the transmitter every day to avoid detection, broadcasting news of protests and speeches across India for months until she was finally captured and imprisoned.",
        "Modern Edge": "The lesson is Mobility of Truth. When external forces try to silence your voice or block your path, don't stay in one place to be captured by negativity. Keep your spirit moving and find unconventional ways to speak your truth. A dynamic mind can never be truly caged by a rigid authority."
      },
      {
        "Title": "The Gond Queen Durgavati",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The defender of Garha Katanga against the Mughal expansion.",
        "Description": "Rani Durgavati was a warrior queen who refused to surrender her kingdom to Akbar’s generals. She was a master of defensive warfare, using the hilly terrain of the Satpuras to trap larger armies. When she was finally cornered and wounded, she chose to end her own life with a dagger rather than face the dishonor of being a prisoner.",
        "Modern Edge": "The lesson is Controlling your Narrative. Durgavati teaches us that even when external defeat is inevitable, you still have the power to control your dignity. Do not let others define your value or your ending; keep your inner sovereignty intact until the very last breath."
      },
      {
        "Title": "Raja Martanda Varma and the Battle of Colachel",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The first time an Asian power defeated a European naval force.",
        "Description": "In 1741, the Dutch East India Company attempted to invade Travancore. Martanda Varma's forces utilized a superior understanding of the coastline to trap the Dutch fleet. This victory was so total that it permanently ended Dutch colonial ambitions in the Indian subcontinent.",
        "Modern Edge": "The lesson is Using Local Advantage. A giant problem is only powerful in its own territory. Martanda Varma shows us that by drawing a massive challenge into your 'shallows'—the areas you know best—you can ground the problem and finish it. Use your unique personal strengths to neutralize overwhelming odds."
      },
      {
        "Title": "The Iron-Smelting Tribes of Agaria",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "The traditional keepers of India's metallurgical secrets.",
        "Description": "The Agaria tribe in Central India practiced a form of small-scale iron smelting that produced rust-resistant iron for centuries. They understood the specific chemical properties of different clays used in their kilns, a tribal science that eventually contributed to the development of modern high-grade steel.",
        "Modern Edge": "The lesson is the Value of Deep Secrets. You don't need a massive platform to be essential. By mastering one specific, 'rust-resistant' skill or piece of knowledge, you create a value that cannot be easily copied. Your 'micro-recipe' for excellence is your best defense against being replaced."
      },
      {
        "Title": "Acharya Lalla and the Gnomon",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The astronomer who perfected the measurement of time.",
        "Description": "In the 8th century, Lalla wrote the 'Shishyadhividdhida Tantra'. He perfected the use of the 'Gnomon' (Shanku)—a vertical rod used to track the sun's shadow. This allowed for the precise calculation of local latitude and the exact timing of the equinoxes, crucial for both agriculture and sea navigation.",
        "Modern Edge": "The lesson is Minimalist Calibration. You don't need expensive tools to understand your life's direction. Lalla used a simple stick to calculate the heavens. Stop waiting for perfect circumstances or high-tech solutions; use the basic 'metrics' available to you right now to track where you are going."
      },
      {
        "Title": "The Bravehearts of the Vaikom Satyagraha",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The peaceful struggle for the right to walk on public roads.",
        "Description": "In 1924, people of all castes stood together in Vaikom, Kerala, to demand that the roads around the local temple be opened to everyone. Despite being arrested and standing in waist-deep water during the monsoon for months, they remained non-violent, forcing a change in the social fabric of India.",
        "Modern Edge": "The lesson is Moral Endurance. Vaikom teaches us that standing your ground through the 'monsoon' of hardship—without lashing out—eventually drains the power of the opposition. If you are in a difficult phase, remember that your persistence itself is a powerful force for change."
      },
      {
        "Title": "Kanaklata Barua: The Girl with the Flag",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The 17-year-old martyr of the Quit India movement.",
        "Description": "During the 1942 movement in Assam, Kanaklata led a group of protesters to hoist the national flag at a police station. When the British police threatened to fire, she stepped forward, refusing to let the flag fall. She was shot and died holding the flag, becoming a symbol of youth defiance in the East.",
        "Modern Edge": "The lesson is Courage of Conviction. Kanaklata proved that age is irrelevant when it comes to standing up for what is right. When you believe in a cause, step forward without fear. One person’s refusal to let their 'flag' fall can inspire an entire generation to pick it up."
      },
      {
        "Title": "Bhartrihari: The Grammarian Philosopher",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The sage who linked language to consciousness.",
        "Description": "Bhartrihari's 'Vakyapadiya' explored the idea that thought and language are inseparable. He proposed the 'Sphota' theory—that meaning is grasped in a sudden flash of insight. His work remains a foundational text in both linguistics and the philosophy of the mind.",
        "Modern Edge": "The lesson is Controlling the Inner Narrative. Bhartrihari teaches us that how we speak determines how we think. If you want to change your life, change your vocabulary. Master your 'inner language' to change the boundaries of what you believe is possible for yourself."
      },
      {
        "Title": "The Kachari Kings and the Monolithic Pillars",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The unique mushroom-shaped architecture of Dimapur.",
        "Description": "The Kachari dynasty in Nagaland and Assam created massive monolithic sandstone pillars. These structures were not just ritualistic but served as markers of the kingdom's engineering capability. They developed unique stone-joining techniques that allowed these pillars to withstand the high seismic activity of the North-East.",
        "Modern Edge": "The lesson is Flexibility as Strength. The Kacharis built pillars that could survive earthquakes by using interlocking designs rather than rigid ones. In your own life, don't be so rigid that you 'snap' under pressure. Build a flexible mindset and 'interlocking' support systems that can shake with the world and remain standing."
      },
      {
        "Title": "Velu Nachiyar: The First Queen to use a Suicide Bomber",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The Queen of Sivaganga who outsmarted the British.",
        "Description": "Rani Velu Nachiyar was the first Indian queen to fight the British. She discovered where the British stored their ammunition and organized a 'suicide attack' where her loyal commander, Kuyili, doused herself in ghee, set herself on fire, and jumped into the armory, destroying the enemy's gunpowder supply.",
        "Modern Edge": "The lesson is Turning the Problem against Itself. Nachiyar didn't just fight the guns; she destroyed the source. When facing an overwhelming problem, look for its 'armory'—the one thing that gives it power—and find a way to turn that strength into a weakness. One bold act can neutralize a thousand threats."
      },
      {
        "Title": "The Maritime Strength of the Marwaris",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The inland kings who dominated the Eastern trade routes.",
        "Description": "While based in the deserts of Rajasthan, the Marwar merchant-kings and chieftains established 'Kothis' (trading posts) across the world. They financed the navies of other Indian kingdoms and controlled the movement of silk and spices, proving that economic power is a form of sovereignty that can rule across oceans even from a desert.",
        "Modern Edge": "The lesson is Transcending your Environment. You do not have to be defined by where you start. The Marwaris ruled the oceans from a desert. No matter how 'dry' your current situation is, you can still influence distant horizons if you build the right connections and manage your resources wisely."
      },
      {
        "Title": "Nilakantha Somayaji and the Planetary Model",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The 15th-century astronomer who refined the solar system model.",
        "Description": "A giant of the Kerala School, Nilakantha wrote the 'Tantrasamgraha'. He proposed a partially heliocentric model where the planets orbit the Sun, which in turn orbits the Earth. This was a significant mathematical advancement that preceded the Tychonic system of Europe by nearly a century.",
        "Modern Edge": "The lesson is Continuous Refinement. Nilakantha didn't need to be 100% right immediately; he focused on making the current model more accurate. In life, don't wait for a total revelation to start improving. Refine your 'map' of the world iteratively based on reality, and you will eventually see things as they truly are."
      },
      {
        "Title": "The Battle of Bagasra",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The resistance of the Kathi Kshatriyas against expansionism.",
        "Description": "In the heart of Saurashtra, the Kathi chieftains fought a series of defensive battles to protect their nomadic heritage and lands. They utilized the 'Dharo' (local militia) system, where every household contributed a warrior, making it impossible for larger imperial forces to maintain a permanent occupation of their rugged terrain.",
        "Modern Edge": "The lesson is Decentralized Strength. The Kathis proved that when everyone takes responsibility for defense, the group becomes unconquerable. In your own community or family, foster a culture where everyone is a 'warrior' for the common good. Unity at the smallest level prevents any outside force from occupying your peace."
      },
      {
        "Title": "The Nameless Engineers of the Kallanai Dam",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The world's oldest functional water-regulator structure.",
        "Description": "Built by Karikala Chola in the 2nd century CE, the Grand Anicut (Kallanai) was constructed using unhewn stones laid across the Kaveri river. The engineers developed a 'scouring' method to prevent the dam from silting up. It is so perfectly built that it still diverts water to millions of acres of farmland today, 2,000 years later.",
        "Modern Edge": "The lesson is Self-Cleaning Systems. The Chola engineers knew that 'silt' (clutter and waste) would eventually ruin their work, so they built a way for the dam to clean itself. In your life, build systems—like daily reflection or routines—that automatically 'scour' away the stress and technical debt before they clog your potential."
      },
      {
        "Title": "Chanakya’s Vow and the Fall of Dhanananda",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The scholar who toppled an empire with a single vow.",
        "Description": "Dhanananda, the last Nanda king, publicly insulted the scholar Chanakya (Kautilya). In response, Chanakya untied his shikha (hair-lock), vowing not to tie it until the Nanda dynasty was uprooted. He found a young boy named Chandragupta, trained him in statecraft and warfare, and together they dismantled the massive Nanda army to establish the Mauryan Empire.",
        "Modern Edge": "The lesson is Channeled Determination. Chanakya took a public insult and used it as fuel for a lifelong mission. Instead of getting angry, get strategic. Use your setbacks as a 'visible vow'—a constant reminder to yourself to keep working until you have completely replaced your obstacles with success."
      },
      {
        "Title": "Chandragupta Maurya: The Liberator",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The first Emperor to unite the Indian subcontinent.",
        "Description": "Chandragupta Maurya was the first ruler to unify disparate kingdoms into one empire. He defeated the Greek general Seleucus Nicator, securing the borders of North-West India. Later in life, he famously abdicated his throne to become a Jain monk, passing the empire to his son Bindusara and seeking spiritual peace at Shravanabelagola.",
        "Modern Edge": "The lesson is Knowing When to Step Away. Chandragupta shows us that true power is knowing when you have finished your mission. Build your legacy, secure your 'borders,' and then have the wisdom to 'pass the torch' and seek your own peace. A great life is measured by both what you build and how you let go."
      },
      {
        "Title": "Peshwa Baji Rao I: The Unbeaten Cavalry",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The general who never lost a battle.",
        "Description": "Baji Rao I expanded the Maratha Empire into North India, moving the administrative seat to Pune. He is legendary for the Battle of Palkhed, where he outmaneuvered the Nizam of Hyderabad using only high-speed light cavalry. In 20 years of continuous warfare, he remained undefeated, establishing Maratha supremacy across the Deccan.",
        "Modern Edge": "The lesson is Speed over Mass. Baji Rao proved that you don't need a massive, slow army to win if you are fast and agile. In life, don't get bogged down by heavy, outdated ways of thinking. Use speed and quick adjustments to stay ahead of giant problems that are too slow to react to your moves."
      },
      {
        "Title": "Ashoka and the Turn to Dharma",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The conqueror who realized that true victory is through peace.",
        "Description": "After the bloody Kalinga War, Emperor Ashoka was struck by remorse. He abandoned 'Digvijaya' (conquest by force) for 'Dharmavijaya' (conquest by righteousness). He erected pillars across the subcontinent inscribed with edicts on non-violence, medical care for animals, and respect for all faiths, spreading the message of Indian ethics as far as Greece and Egypt.",
        "Modern Edge": "The lesson is the Power of Character. Ashoka realized that conquering people's bodies is temporary, but winning their hearts through values is eternal. Once you have achieved outward success, shift your focus to your 'inner pillars'—your ethics and kindness. True influence lasts longer than raw power."
      },
      {
        "Title": "Maharana Kumbha: The Architect King",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The invincible ruler of Mewar who built 32 forts.",
        "Description": "Rana Kumbha was a polymath who never lost a battle. He built the massive Kumbhalgarh Fort, which has the second-longest wall in the world after the Great Wall of China. He was also a scholar of music and grammar, proving that a king's strength lies in both his fortress and his library.",
        "Modern Edge": "The lesson is Dual Strength. Rana Kumbha shows that you shouldn't just be a 'warrior' or just a 'scholar.' Build 'forts' for your physical security and daily discipline, but also build a 'library' of knowledge and arts. A complete person is one who is strong enough to defend and wise enough to create."
      },
      {
        "Title": "Prithviraj Chauhan: The Last Sun of Delhi",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The legendary archer-king of the Chahamana dynasty.",
        "Description": "Ruling from Ajmer and Delhi, Prithviraj was famous for his 'Shabd-Bhedi' (aiming by sound) skills. He defeated the invader Muhammad Ghori in the First Battle of Tarain and released him out of Rajput chivalry—a decision that changed Indian history. He remains the ultimate symbol of Rajput honor and gallantry.",
        "Modern Edge": "The lesson is Discerning Mercy. Prithviraj was a master of hitting invisible targets, but his kindness to a repeat threat cost him everything. Chivalry is a virtue, but you must know when a problem needs to be finished completely so it doesn't return to haunt you. Don't be merciful to habits that seek to destroy you."
      },
      {
        "Title": "Chhatrapati Sambhaji: The Unyielding Martyr",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The second Chhatrapati who fought the Mughals for nine years.",
        "Description": "The son of Shivaji Maharaj, Sambhaji faced the full might of Aurangzeb's 500,000-strong army. He fought 120 battles and lost none. When captured, he was offered his life if he converted, but he refused to betray his faith or his motherland, facing a brutal end with a smile that inspired the entire Maratha nation to continue the fight.",
        "Modern Edge": "The lesson is the Power of an Unbroken Spirit. Sambhaji teaches us that while they can take your life or your freedom, they cannot take your choice. By refusing to break under extreme pressure, he became a legend that inspired millions. Your refusal to compromise your soul is your ultimate victory."
      },
      {
        "Title": "Chhatrapati Rajaram and the War of 27 Years",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who ruled from the moving saddle.",
        "Description": "After Sambhaji, his brother Rajaram led the Marathas. He realized they couldn't fight a conventional war, so he moved the capital to Gingee in the South. He transformed the empire into a decentralized resistance, forcing the Mughals into a 27-year-long war of attrition that eventually broke the Mughal treasury.",
        "Modern Edge": "The lesson is Endurance through Adaptability. When the situation is too heavy to face head-on, move your 'capital.' Rajaram stayed in the 'saddle' for years, refusing to give the enemy a stationary target. Stay mobile and persistent, and eventually, the massive weight of the problem will break itself."
      },
      {
        "Title": "Tarabai: The Queen Who Led the Resurgence",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The widow queen who defeated Aurangzeb's pride.",
        "Description": "Rani Tarabai, the widow of Rajaram, took command of the Maratha forces herself. She organized the counter-offensive that drove the Mughals out of the Deccan. It was under her leadership that the Marathas moved from defense to offense, crossing the Narmada river to take the fight to North India.",
        "Modern Edge": "The lesson is Turning Defense into Offense. Tarabai shows us that there is a moment when you must stop just surviving and start attacking your problems. Once the 'enemy' (your fear or hardship) is tired of chasing you, that is the exact time to strike back and reclaim your territory."
      },
      {
        "Title": "Maharana Pratap: The Unbending Pillar of Mewar",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who chose the forest over a puppet throne.",
        "Description": "Maharana Pratap stands as the ultimate symbol of Rajput resistance. In 1576, at the Battle of Haldighati, he faced a Mughal army that vastly outnumbered his own. Though he had to retreat, he never surrendered. For the next 20 years, he lived in the Aravalli hills, eating rotis made of grass seed, and perfected 'Guerilla Warfare.' He famously vowed never to sleep on a bed or eat from gold plates until Chittor was liberated. By the time of his death, he had won back almost all of Mewar except the fort of Chittor itself.",
        "Modern Edge": "The lesson is Choosing Freedom over Comfort. Pratap could have lived in luxury as a puppet, but he chose grass rotis and the forest to stay free. If your 'comfort' requires you to give up your values, it is a prison. Sacrifice your luxuries today so you can live with your head held high tomorrow."
      },
      {
        "Title": "Chhatrapati Shahu and the Expansion of the Empire",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The visionary who transformed the Maratha state into a Pan-Indian power.",
        "Description": "Grandson of Shivaji Maharaj, Shahu spent years in Mughal captivity. Upon his release, he unified the warring Maratha factions. He had the genius to recognize the talent of the Peshwas, delegating military command while remaining the moral and sovereign head. Under his reign, the Marathas moved from defending the Deccan to collecting taxes from the gates of Delhi and Bengal.",
        "Modern Edge": "The lesson is Empowering Talent. Shahu knew he didn't need to be the best warrior to be a great king; he just needed to find the best warriors and trust them. In your life, don't try to be everything. Find people who are better than you in certain areas, empower them, and together you will reach far beyond your own limits."
      },
      {
        "Title": "Maharana Amar Singh and the Treaty of Dignity",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who secured peace without surrendering honor.",
        "Description": "After decades of continuous war, Mewar was exhausted. In 1615, Amar Singh negotiated a peace treaty with Prince Khurram (Shah Jahan). Uniquely, the Maharana refused to attend the Mughal court personally (sending his son instead) and insisted that Mewar would never give a daughter in marriage to the Mughals—terms unheard of in that era. He ensured Mewar remained a 'Vatan' (sovereign home) while finally allowing his people to rebuild.",
        "Modern Edge": "The lesson is Respecting your Limits. There is a time to fight and a time to rebuild. Amar Singh recognized his people's exhaustion and chose peace, but he refused to negotiate on his 'soul.' Learn to find a middle ground that allows you to recover without giving away the things that make you who you are."
      },
      {
        "Title": "Bhagat Singh: The Intellectual Revolutionary",
        "Category": "Freedom Fighters",
        "Region": "North",
        "Summary": "The youth who used the court and the gallows as a stage for freedom.",
        "Description": "Bhagat Singh was a brilliant thinker who believed that 'the sword of revolution is sharpened on the whetting-stone of ideas.' After the death of Lala Lajpat Rai, he and his comrades took a stand against British tyranny. In 1929, he threw non-lethal smoke bombs in the Central Legislative Assembly to 'make the deaf hear.' He refused to escape, using his trial to spread the message of independence. At the age of 23, he went to the gallows with a smile, singing songs of patriotism, sparking a fire that eventually led to the end of colonial rule.",
        "Modern Edge": "The lesson is the Power of Ideas. Bhagat Singh knew that a person can be killed, but an idea is immortal. Use your intellect and your voice to 'make the deaf hear.' When you stand up for a truth with total conviction, even your setbacks become a stage to inspire others."
      },
      {
        "Title": "Hakim Khan Suri: The Loyal Vanguard",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Pathan warrior who stood by Pratap until the very end.",
        "Description": "Hakim Khan Suri was the chief of Maharana Pratap's artillery and led the frontal assault at Haldighati. He saw Pratap as the true leader of a sovereign India. Legend has it that he fought so fiercely that even after he fell, his grip on his sword was so tight that it had to be buried with him. He remains a symbol of the deep communal harmony and shared sacrifice of the Mewari resistance.",
        "Modern Edge": "The lesson is Shared Values over Tribalism. Hakim Khan didn't fight for Pratap because they were from the same background, but because they shared the same mission. Align yourself with people who share your values, not just your history. Loyalty built on a shared purpose is the strongest bond of all."
      },
      {
        "Title": "Jhala Maan: The Royal Double",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The chieftain who wore the royal crown to save his King.",
        "Description": "During the heat of the Battle of Haldighati, Maharana Pratap was surrounded and wounded. Seeing the danger, Jhala Maan snatched the Royal Insignia and Umbrella from the Maharana, placing them on himself. The Mughal forces, thinking he was the King, diverted their entire attack toward him. This gave Pratap the vital window to retreat and continue the guerrilla war, while Jhala Maan fell fighting heroically.",
        "Modern Edge": "The lesson is Selfless Shielding. Sometimes, to save the 'vision,' someone has to step into the fire. Jhala Maan teaches us the beauty of sacrifice. Be the kind of person who is willing to take the 'hit' for a greater cause or for someone who is leading the way to a better future."
      },
      {
        "Title": "Rana Punja Bhil: The Guardian of the Aravallis",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The tribal chief who mastered the art of guerrilla warfare.",
        "Description": "Rana Punja and his Bhil warriors were the masters of the rugged Aravalli terrain. At Haldighati, they rained boulders and arrows down from the cliffs, causing chaos in the Mughal ranks. Punja's unwavering support was why Pratap could survive in the forests for 20 years. To this day, the Mewar Royal Emblem features a Bhil warrior on one side, honoring Rana Punja's legacy.",
        "Modern Edge": "The lesson is the Power of Local Wisdom. Rana Punja shows that those who know the 'terrain' of a situation are your most valuable allies. Respect and listen to the 'scouts'—the people who understand the ground level. Their simple tools (boulders and arrows) can defeat any 'emperor's' army."
      },
      {
        "Title": "Jaimal and Kalla: The Four-Armed Warrior",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The uncle and nephew who became a single force of nature.",
        "Description": "During the Siege of Chittorgarh, the commander Rao Jaimal was wounded in the leg by a musket shot and could not walk. Determined to fight in the final 'Saka' (last stand), his nephew Kalla Ji took Jaimal on his shoulders. With Jaimal wielding two swords above and Kalla wielding two below, they appeared to the enemy as a single, four-armed deity. They decimated the opposition until their last breath, defending the gates of their motherland.",
        "Modern Edge": "The lesson is Synergy in Hardship. When you are 'wounded' in one area, lean on someone else's strength. Together, you become something more powerful than any individual. Two people working as one 'four-armed warrior' can overcome any obstacle, even when one is carrying the other."
      },
      {
        "Title": "Patta Chawat: The Young Defender",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The 16-year-old who led the defense of Chittor.",
        "Description": "Alongside Jaimal and Kalla, the young Rawat Patta Sisodia fought with legendary bravery. After his mother and wife donned saffron and committed Jauhar, Patta led the charge against the Mughal forces. His valor was so immense that Akbar later erected stone statues of Jaimal and Patta at the gates of Agra Fort to honor their indomitable spirit.",
        "Modern Edge": "The lesson is Absolute Dedication. Patta shows that when you have lost everything except your duty, you become truly invincible. Don't let your 'youth' or 'inexperience' stop you from leading. If you are fully committed to your path, even your 'enemies' will have to build a statue to your courage."
      },
      {
        "Title": "Isar Das Chauhan: The Lion of the Gate",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The warrior who charged an elephant with a dagger.",
        "Description": "During the final breach of Chittorgarh, a Mughal war elephant was crushing the Rajput ranks. Isar Das Chauhan, seeing the devastation, did the unthinkable. He charged the beast alone, grabbed its tusk, and used it to pull himself up. He stabbed the mahout (driver) and challenged the elephant's trunk with his bare hands. His suicidal bravery stalled the elephant line, giving the Rajputs time to regroup for their final charge.",
        "Modern Edge": "The lesson is Facing the Giant Directly. When a massive problem is crushing you, don't run. Charge the 'elephant' and take out the 'driver.' Most giant problems have one small point of control. If you are brave enough to grab the 'tusk,' you can stop the whole beast from moving forward."
      },
      {
        "Title": "The Night Engineers of Mewar",
        "Category": "Ancient Science",
        "Region": "West",
        "Summary": "Repairing a fortress under the cover of darkness.",
        "Description": "The Siege of Chittor lasted months because of the Mewari engineers. Every day, Mughal cannons would blast holes in the limestone walls. Every night, under a rain of musket fire, the workers and soldiers (led by Jaimal) would use a specific mixture of stone, lime, and jaggery to rebuild the walls. This 'instant-setting' masonry kept the fort impregnable for months against the world’s most advanced artillery of that time.",
        "Modern Edge": "The lesson is Daily Restoration. You will get 'hit' every day by life's cannons, but the secret is to 'rebuild the wall' every night. Don't go to sleep with a hole in your spirit. Use your own 'limestone and jaggery'—your routines and reflections—to patch your character before the sun rises."
      },
      {
        "Title": "Phool Kanwar: The Flame of Chittor",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Queen who led the final Jauhar.",
        "Description": "Phool Kanwar was the wife of Rawat Patta and the sister of Kalla Ji. When it became clear that the fort would fall, she did not wait in despair. She organized and led thousands of women into the 'Jauhar' (ceremonial fire) to protect their honor. Her leadership ensured that the men could walk out into the 'Saka' (final fight) without any worry for their families, focusing purely on their duty to the land.",
        "Modern Edge": "The lesson is Focused Determination. Phool Kanwar shows that even in the face of total loss, you can provide the peace of mind that allows others to do their duty. Lead with such strength that those around you feel 'free' to focus on their own purpose. Honor is the one thing no one can take from you."
      },
      {
        "Title": "Udai Singh II: The Founder of Udaipur",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The King who built a city that could never be conquered.",
        "Description": "Udai Singh II realized that the massive walls of Chittorgarh could not withstand the new age of Mughal artillery. He founded a new capital, Udaipur, nestled deep within the Aravalli hills and protected by the Girwa valley. He built Lake Pichola to ensure a permanent water supply, creating a strategic, green oasis that remained unconquered for centuries while other desert forts fell.",
        "Modern Edge": "The lesson is Adapting to the Times. Udai Singh realized that staying in an 'obsolete fortress' just because it was traditional would lead to ruin. Don't cling to old ways of living or thinking when the 'artillery' of life changes; have the courage to build a new, sustainable environment where you can truly thrive."
      },
      {
        "Title": "Maharaja Ranjit Singh: The Lion of Punjab",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The one-eyed King who built the most powerful army in Asia.",
        "Description": "Ranjit Singh survived smallpox as a child (which left him with one eye) and rose to unify the Sikh Misls at age 12. He captured Lahore in 1799 and established a kingdom that stretched from the Khyber Pass to Tibet. He modernized his army with European tactics, but maintained a deeply Indian soul, donating tons of gold to the Kashi Vishwanath temple and the Harmandir Sahib (Golden Temple). He was so respected that for 40 years, the British dared not cross the Sutlej River into his territory.",
        "Modern Edge": "The lesson is Balancing Progress with Soul. Ranjit Singh shows that you can adopt modern tools and 'tactics' to stay strong without losing your cultural or personal identity. Improve your skills and your 'armor,' but never let modernization delete the values that make you unique."
      },
      {
        "Title": "Maharana Hammir Singh: The Liberator of Mewar",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who reclaimed Chittorgarh from the shadows.",
        "Description": "After the fall of Chittor in 1303, the land was under foreign occupation. Hammir Singh, a young scion of the Sisodia branch, stayed in the hills, building a grassroots army. In 1326, through brilliant strategy and local support, he recaptured the Chittorgarh Fort. He defeated the Tughlaq forces at the Battle of Singoli and took the Sultan as a prisoner. He replaced the title 'Rawal' with 'Rana' and 'Maharana,' marking the beginning of the Sisodia era that lasted for centuries.",
        "Modern Edge": "The lesson is Patient Recovery. When you lose your position or feel defeated, retreat to the 'hills'—your inner circle and quiet places—to rebuild. Wait for the right moment to reclaim your life. A well-timed comeback, backed by grassroots support, can redefine your entire future."
      },
      {
        "Title": "Sadashivrao Bhau: The Commander of the North",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The Maratha General who fought 1,000 miles from home.",
        "Description": "Sadashivrao Bhau led the Maratha forces to Panipat to defend the Indian subcontinent from foreign invasion. Despite being cut off from supply lines and facing a brutal winter, he refused to retreat. He launched a massive infantry charge that nearly broke the Afghan center. He died fighting in the thick of the battle, choosing a hero's death over a dishonorable surrender.",
        "Modern Edge": "The lesson is Total Commitment to a Vision. Bhau proves that true leadership is being willing to extend yourself far beyond your comfort zone to protect a greater cause. Even if the 'winter' is harsh, your willingness to stand at the edge of your map defines your character."
      },
      {
        "Title": "Ibrahim Khan Gardi: The Loyal Musketeer",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The General who proved loyalty knows no religion.",
        "Description": "Ibrahim Khan Gardi was the commander of the Maratha artillery. Using advanced French-trained tactics, his cannons decimated the Afghan ranks in the early hours of the battle. When the Maratha line began to crumble, he was offered safety to defect because of his faith, but he refused, stating his loyalty was to the Maratha State and Sadashivrao Bhau. He fought until he was captured and executed.",
        "Modern Edge": "The lesson is Integrity over Convenience. Gardi shows that a person is defined by their refusal to abandon their post when things get difficult. In a crisis, your most valuable trait is the integrity to stay with your convictions, even when you are offered an 'easy way out' that betrays your word."
      },
      {
        "Title": "Shamsher Bahadur: The Lion's Son",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The brave prince who fell defending the Maratha dream.",
        "Description": "Shamsher Bahadur was a key commander at Panipat. He led his cavalry into the heart of the Afghan ranks, sustaining multiple wounds. He managed to escape the battlefield but eventually succumbed to his injuries. His presence at Panipat showed the unity of the Maratha house in the face of a national threat.",
        "Modern Edge": "The lesson is Unity through Action. Shamsher proved his place in the 'house' by being the first to face the threat. If you want to be part of something great, don't just talk about it; be the one who leads the charge. Your actions are the only metric of loyalty that truly matters."
      },
      {
        "Title": "Rajendra Chola I: The Ocean King",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Emperor who turned the Bay of Bengal into a Chola Lake.",
        "Description": "Rajendra Chola I took the Chola Empire to its zenith. He led a daring expedition to North India, reaching the Ganges, and built a new capital, Gangaikondacholapuram, to celebrate. Most notably, he launched a massive naval invasion of Southeast Asia (Srivijaya/Indonesia), securing trade routes to China. His navy was the most advanced of its time, featuring ships capable of carrying war elephants across the ocean. He was a patron of arts and built the magnificent Brihadisvara Temple at Gangaikondacholapuram.",
        "Modern Edge": "The lesson is Expanding Horizons. Rajendra realized that land borders are for the limited; the 'ocean' is for the visionary. In your own life, don't be a 'local player' stuck in your own backyard. Expand your reach, learn new 'logistics,' and connect with different cultures to truly dominate your path."
      },
      {
        "Title": "Hari Singh Nalwa: The Frontier Tiger",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The legendary Sikh Commander who terrified invaders.",
        "Description": "As the Commander-in-chief of the Sikh Empire, Hari Singh Nalwa secured the Khyber Pass—the gateway used by invaders for centuries. He built forts and established a presence so formidable that his name alone became a deterrent against potential invasions for generations.",
        "Modern Edge": "The lesson is Building a Formidable Reputation. Nalwa shows that by being consistently excellent and strong, your reputation becomes a 'wall' that prevents problems from even starting. Aim to be so reliable and capable that difficulties 'stay home' rather than challenging you."
      },
      {
        "Title": "Rani Abbakka Chowta: The Fearless Queen",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Tuluva Queen who fought the Portuguese for 40 years.",
        "Description": "Known as 'Abhaya Rani', she repeatedly defeated Portuguese attempts to capture the port of Ullal. She used fire-arrows and night-raid tactics to protect her trade freedom, refusing to pay tribute to foreign invaders for over four decades.",
        "Modern Edge": "The lesson is Using Unconventional Tactics. Abbakka didn't fight the 'big fleet' out in the open where they were strong; she hit them where they were weak. When facing a massive challenge, don't use brute force. Use 'fire-arrows'—targeted, smart disruptions—to make the problem too 'expensive' to continue."
      },
      {
        "Title": "Raja Dahir: The Last Hindu King of Sindh",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The King who fought the first Arab invasion of the subcontinent.",
        "Description": "In 711 CE, Raja Dahir faced the Arab general Muhammad bin Qasim, who was invading from the West. Despite being outnumbered and facing a new kind of warfare, Dahir's forces fought fiercely to defend their land. He was eventually defeated and killed in battle, but his resistance delayed the Arab conquest of the subcontinent for decades.",
        "Modern Edge": "The lesson is Standing at the Gate. Dahir shows that even if you can't win the final war alone, your resistance matters. By taking the 'first hit' of a major threat, you give those behind you the time to prepare and adapt. Sometimes, holding the line is the greatest service you can perform."
      },
      {
        "Title": "Zorawar Singh: The Himalayan Conqueror",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The General who fought at the roof of the world.",
        "Description": "General Zorawar Singh led expeditions into Ladakh and Tibet, regions where no army had ever dared to campaign due to the extreme altitude and cold. He expanded the borders of the Dogra Empire into the clouds through sheer physical and mental endurance.",
        "Modern Edge": "The lesson is Conquering the Hard Places. Zorawar went where there was 'no oxygen'—where the challenge was too high for others to even try. Growth often lives in the 'impossible geography' of your fears. If a path is easy, everyone is on it; seek the high, difficult peaks instead."
      },
      {
        "Title": "Nagabhata I and the Great Resistance",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The King who saved India from the Umayyad invasion.",
        "Description": "In the 8th century, the Umayyad Caliphate was an unstoppable global force until they met Nagabhata I. He led a confederacy of Indian kings to decisively defeat the invaders in Rajasthan, protecting the heartland of India for centuries to come.",
        "Modern Edge": "The lesson is Unity against Existential Threats. Nagabhata realized that bickering with his peers would lead to everyone's ruin. When a massive outside force threatens your world, set aside minor differences and unite. Synergy with others is often the only way to survive a 'global' crisis."
      },
      {
        "Title": "Peer Ali Khan: The Rebel Bookseller",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The quiet intellectual who fueled a revolution.",
        "Description": "A bookshop owner in Patna who became a key organizer of the 1857 rebellion. He used his shop as a secret meeting point for revolutionaries, proving that the pen and the word are often as dangerous to tyrants as the sword.",
        "Modern Edge": "The lesson is the Power of a Quiet Hub. You don't need to be on a battlefield to start a revolution. Peer Ali used his 'boring' day job as a cover to organize something much bigger. Your daily routine can be the foundation for a profound change if you use it with intention."
      },
      {
        "Title": "Mihira Bhoja: The Constant Defender",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The Gurjara-Pratihara king who held the line for 50 years.",
        "Description": "Mihira Bhoja maintained a massive standing army, including a legendary cavalry, to defend India's western borders. His reign was so stable and prosperous that travelers noted his kingdom was safe from even the smallest crimes, creating a golden age of security.",
        "Modern Edge": "The lesson is the Value of Consistency. Bhoja proved that 50 years of being a 'reliable constant' creates more prosperity than short-lived bursts of action. Be the person that people can trust when everything else is in chaos. Reliability is its own form of greatness."
      },
      {
        "Title": "Kuyili: The First Human Bomb",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The commander who sacrificed herself to destroy the enemy's armory.",
        "Description": "Kuyili was a trusted commander of Rani Velu Nachiyar, the first queen to fight the British in India. During a critical battle, when the British had taken over the fort's armory, Velu Nachiyar ordered Kuyili to destroy it. Kuyili doused herself in ghee, set herself on fire, and jumped into the armory, causing a massive explosion that turned the tide of the battle in favor of the queen.",
        "Modern Edge": "The lesson is Identifying the Single Point of Failure. Kuyili shows that even a giant force can be stopped if you hit its 'gunpowder.' Instead of fighting a whole army, find the one thing that gives the problem its power and apply your full commitment to neutralizing it."
      },
      {
        "Title": "Bagha Jatin: The Tiger of Bengal",
        "Category": "Forgotten Heroes",
        "Region": "East",
        "Summary": "The revolutionary who believed in 'Amra morbo, jagbe desh'.",
        "Description": "Jatin Mukherjee was a key leader of the Jugantar movement. He famously fought a Royal Bengal Tiger with only a dagger. Later, he organized an international network to ship arms to India, dying in a heroic trench fight against the British police in Balasore.",
        "Modern Edge": "The lesson is Global Perspective. Jatin knew that while a 'local tiger' is fought with a dagger (hustle), a 'global empire' requires international networks. Connect with resources and support from far and wide to fuel your personal growth and solve big problems."
      },
      {
        "Title": "Tipu Sultan: The Tiger of Mysore",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The pioneer of rocket artillery and the fiercest foe of the British.",
        "Description": "Tipu Sultan was the ruler of the Kingdom of Mysore who fought four Anglo-Mysore wars. He was a polymath who modernized his army with the 'Mysorean Rockets'—iron-cased rockets that terrified British troops and later influenced the development of modern rocketry. Despite immense pressure, he refused to become a subsidiary of the British Empire, dying on the battlefield defending his capital, Seringapatam.",
        "Modern Edge": "The lesson is Owning your Innovations. Tipu didn't just 'buy' tools; he built his own. In your life, don't just follow someone else's manual; innovate and create your own 'rocket R&D.' If you own the unique skills and ideas, you become someone who cannot be easily ignored or controlled."
      },
      {
        "Title": "Uda Devi: The Hidden Sniper of 1857",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The woman who took down 32 British soldiers from a single tree.",
        "Description": "During the Siege of Lucknow, Uda Devi, dressed in male attire, climbed a large pipal tree with a musket and a bag of ammunition. She single-handedly held off a British battalion, taking down 32 soldiers from her hidden vantage point before she was finally spotted. Her bravery remains a legendary symbol of the grassroots resistance in Awadh.",
        "Modern Edge": "The lesson is Finding the Vantage Point. Uda Devi showed that one person in the right 'tree' can hold off a whole battalion. In your life, look for the 'high ground'—a unique perspective or skill—that makes the 'numbers' of your opposition irrelevant. Position yourself where you can do the most good."
      },
      {
        "Title": "The Battle of Takkolam",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "A sudden shift in the Chola-Rashtrakuta rivalry.",
        "Description": "A decisive clash in 949 CE where the Rashtrakutas used a surprise elephant charge to kill the Chola prince Rajaditya. This battle temporarily halted Chola expansion, proving that a single, well-timed tactical strike can dismantle the momentum of a rising empire.",
        "Modern Edge": "The lesson is the Power of a Targeted Strike. You don't always need to win every small skirmish; you just need to address the 'core' of a problem. Identify the one vulnerability that keeps a negative situation moving forward, and aim your focus there to stall its momentum."
      },
      {
        "Title": "The Battle of Khanwa",
        "Category": "Battles",
        "Region": "North",
        "Summary": "The battle that established Mughal dominance in India.",
        "Description": "In 1527, Babur faced a coalition of Rajput kings led by Rana Sanga. Despite being outnumbered, Babur's use of field artillery and innovative tactics led to a decisive victory, paving the way for the Mughal Empire's establishment in India.",
        "Modern Edge": "The lesson is Skill over Numbers. Babur proved that a 10:1 disadvantage in numbers doesn't matter if you have better 'artillery' (skills and preparation). Don't let overwhelming odds scare you; focus on out-thinking and out-skilling the challenge instead."
      },
      {
        "Title": "The Battle of Plassey",
        "Category": "Battles",
        "Region": "North",
        "Summary": "The battle that marked the beginning of British colonial rule.",
        "Description": "In 1757, Robert Clive led the British East India Company against the Nawab of Bengal, Siraj ud-Daulah. Through a combination of military strategy and political intrigue (including bribing key allies), the British secured a decisive victory that allowed them to establish control over Bengal and eventually the entire subcontinent.",
        "Modern Edge": "The lesson is Managing Internal Friction. Clive didn't win with just bullets; he won by identifying the cracks in the opposition's team. In your own life, ensure your inner circle is unified. If you have internal conflict, even a 'small' outside force can bring everything down."
      },
      {
        "Title": "Malharrao Holkar: The Shepherd King",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The founder of the Holkar dynasty who rose from humble roots.",
        "Description": "Starting as a soldier in the Peshwa's army, Malharrao's tactical brilliance in the battles of Amjhera and Delhi led to his rise as a frontline commander. He was granted the territory of Malwa, where he established Indore. He was a master of 'Ganimi Kava' (guerrilla tactics) and played a pivotal role in expanding Maratha influence into Northern India during the 18th century.",
        "Modern Edge": "The lesson is Starting from the Ground Up. Malharrao proved that being a master of the 'technical' skills on the ground is the best resume for leadership. Master the core aspects of your craft better than anyone else, and your path to 'sovereignty' will open naturally."
      },
      {
        "Title": "Sukhdev: The Mastermind of HRSA",
        "Category": "Freedom Fighters",
        "Region": "North",
        "Summary": "The chief strategist who organized the revolutionary network.",
        "Description": "Sukhdev Thapar was the brain behind the organizational structure of the HSRA. While others were the face of the movement, Sukhdev was the planner who established revolutionary cells across North India. He was instrumental in the Lahore Conspiracy Case and was the one who pushed the group toward intellectual growth, making sure every revolutionary was as well-read as they were brave.",
        "Modern Edge": "The lesson is the Architect Model. Every movement needs a 'brain' to design the system. While others might be the face, you can find your strength in building the backend support and intellectual foundation that makes the whole structure stand firm."
      },
      {
        "Title": "Rajguru: The Precision Marksman",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The fearless revolutionary from Maharashtra who provided the firepower.",
        "Description": "Shivaram Rajguru was a master of physical fitness and marksmanship. Hailing from Pune, he joined the HSRA with a single-minded goal: to free India from British rule through direct action. He was the one who fired the first shot in the assassination of J.P. Saunders to avenge Lala Lajpat Rai, executing a high-risk mission with deadly precision and calm.",
        "Modern Edge": "The lesson is Focused Execution. Rajguru proves that every big mission needs one person who stays calm and hits the target with 100% precision. In your life, aim to be the 'specialist' who can execute a task when there is no room for error."
      },
      {
        "Title": "Rani Lakshmibai: The Rebel Queen",
        "Category": "Freedom Fighters",
        "Region": "North",
        "Summary": "The warrior queen who became the face of the 1857 resistance.",
        "Description": "After the British attempted to annex Jhansi under the 'Doctrine of Lapse,' Lakshmibai refused to cede her kingdom. She famously declared, 'Main apni Jhansi nahi doongi' (I will not give up my Jhansi). She transformed herself into a soldier, training a regiment of women and leading her troops on horseback. She died fighting in Gwalior, earning the respect of even her enemies, who called her 'the most dangerous of all rebel leaders.'",
        "Modern Edge": "The lesson is Taking Extreme Ownership. Rani Lakshmibai shows that once you declare 'I will not give up,' you stop being a victim and start being a leader. True freedom begins when you take 100% responsibility for your own 'territory' and your own life."
      },
      {
        "Title": "Mangal Pandey: The First Spark",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The soldier whose single act of defiance ignited the 1857 Uprising.",
        "Description": "A sepoy in the 34th Bengal Native Infantry, Mangal Pandey revolted against the use of greased cartridges that offended his religious beliefs. On March 29, 1857, at Barrackpore, his open rebellion and call to his comrades to join him became the catalyst for the First War of Indian Independence. Though he was executed, his name became a rallying cry for thousands of soldiers across the subcontinent.",
        "Modern Edge": "The lesson is Breaking the Inertia. One single act of radical integrity can shatter a century of people just 'going along' with a bad system. If you see something that is fundamentally wrong, don't wait for a committee; be the spark that forces everyone else to choose where they stand."
      },
      {
        "Title": "Sardar Patel: The Iron Will",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The organizational genius who turned small protests into a national movement.",
        "Description": "Before becoming the architect of modern India, Vallabhbhai Patel led the Bardoli Satyagraha with such surgical precision that the title 'Sardar' (Chief) was given to him by the people. He excelled in the 'ground game'—organizing villages, managing logistics, and ensuring absolute non-violent discipline among thousands. His ability to bridge the gap between high-level political strategy and grassroots execution made the freedom struggle an unstoppable force.",
        "Modern Edge": "The lesson is the Strength of Logistics. Sardar Patel shows that you don't win just with speeches; you win by organizing every small detail into a disciplined unit. Master the unglamorous backend work to create an unstoppable frontend result."
      },
      ];

  // --- AUTOMATED CHANGE DETECTION ---
  // 1. Calculate a hash of the local data
  final String localDataJson = jsonEncode(storyList);
  final int localHash = _generateSimpleHash(localDataJson);

  final DocumentReference configDoc =
      firestore.collection('AppConfig').doc('storiesConfig');

  // 2. Check Firestore for the last uploaded hash
  final configSnapshot = await configDoc.get();
  int? remoteHash;
  if (configSnapshot.exists && configSnapshot.data() != null) {
    remoteHash = (configSnapshot.data() as Map<String, dynamic>)['hash'];
  }

  // 3. If hashes match, stop immediately.
  if (localHash == remoteHash) {
    debugPrint('Stories data is up to date (Hash: $localHash). No sync needed.');
    return;
  }

  debugPrint('Change detected in Stories. Syncing...');

  // 4. Get all existing docs for smart diff
  QuerySnapshot currentDocs = await stories.get();
  final Map<String, dynamic> existingDataMap = {
    for (var doc in currentDocs.docs) doc.id: doc.data()
  };

  final Set<String> scriptTitles = storyList.map((s) => s['Title']! as String).toSet();

  WriteBatch batch = firestore.batch();
  int writeCount = 0;

  // 5. DELETE
  for (var doc in currentDocs.docs) {
    if (!scriptTitles.contains(doc.id)) {
      batch.delete(doc.reference);
      writeCount++;
    }
  }

  // 6. ADD/UPDATE
  for (var story in storyList) {
    final String docId = story['Title'];
    final DocumentReference docRef = stories.doc(docId);

    bool needsUpdate = true;
    if (existingDataMap.containsKey(docId)) {
      if (jsonEncode(existingDataMap[docId]) == jsonEncode(story)) {
        needsUpdate = false;
      }
    }

    if (needsUpdate) {
      batch.set(docRef, story);
      writeCount++;
    }
  }

  // 7. Update Config Hash
  batch.set(configDoc, {'hash': localHash, 'lastUpdated': FieldValue.serverTimestamp()});
  writeCount++;

  await batch.commit();
  debugPrint('✅ Synced Stories: $writeCount write operations performed.');
  } catch (e) {
    debugPrint("Error in uploadStories: $e");
  }
}

// Simple hash function
int _generateSimpleHash(String input) {
  var hash = 0;
  for (var i = 0; i < input.length; i++) {
    hash = 0x1fffffff & (hash + input.codeUnitAt(i));
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= hash >> 6;
  }
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash ^= hash >> 11;
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}