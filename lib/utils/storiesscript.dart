import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> uploadStories() async {
  try {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference stories = firestore.collection('Stories');

final List<Map<String, dynamic>> storyList = [
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Bhaskara II and the Gravity of Earth",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The mathematician who described gravity 500 years before Newton.",
        "Description": "In his 12th-century masterpiece 'Siddhanta Shiromani', Bhaskara II wrote: 'Objects fall on earth due to a force of attraction by the earth. Therefore, the earth, planets, constellations, moon, and sun are held in orbit due to this attraction.' He also calculated the time taken for the Earth to orbit the Sun to within 3 minutes of modern calculations.",
        "Modern Edge": "Great ideas don't need immediate consensus. If your data is solid, trust your calculations even if the market isn't ready to see the gravity of your vision."
      },
      {
        "Title": "Charaka: The Father of Medicine",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who codified Ayurveda and medical ethics.",
        "Description": "Charaka was the principal contributor to the Charaka Samhita. He emphasized that a physician's first duty is to the patient, not to fame or wealth. He was among the first to realize that digestion, metabolism, and immunity are the pillars of health, and he classified thousands of medicinal plants that are still used in modern pharmacology.",
        "Modern Edge": "Ethics aren't a constraint; they are the foundation of longevity. Prioritize the user's well-being over short-term profit to build a brand that survives generations."
      },
      {
        "Title": "Panini: The Father of Linguistics",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The grammarian who created the world's first formal language system.",
        "Description": "Panini's 'Ashtadhyayi' is a 4,000-rule grammar of Sanskrit that functions like a modern computer program. He used Boolean logic and null operators long before they were defined in the West. Modern computer scientists, including those who developed Fortran and Backus-Naur Form, acknowledge Panini’s work as the foundation of formal language theory.",
        "Modern Edge": "Codify your intuition. By creating a grammar for your operations—clear rules and logic—you turn chaotic creativity into a scalable, error-free system."
      },

      // --- RULERS ---
      {
        "Title": "The Vision of Krishnadevaraya",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Golden Age of the Vijayanagara Empire.",
        "Description": "Emperor Krishnadevaraya was not just a warrior but a scholar-king. He protected the South from invasions while turning Hampi into one of the world's largest and wealthiest cities. He was famous for his justice, personally listening to the grievances of commoners, and for patronizing 'Ashtadiggajas' (eight great poets) in his court.",
        "Modern Edge": "Be a 'Scholar-King.' Don't just manage resources; actively patronize innovation and listen to the ground reality. Accessibility is the hallmark of a secure leader."
      },
      {
        "Title": "Lalitaditya Muktapida: The Alexander of Kashmir",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The king who expanded India's borders to Central Asia.",
        "Description": "Lalitaditya of the Karkota dynasty was a conqueror who built an empire stretching from the Caspian Sea to the Pragjyotisha (Assam). He built the magnificent Martand Sun Temple, an architectural marvel. He is remembered for his administrative reforms that ensured even the most remote parts of his empire were self-sufficient.",
        "Modern Edge": "Expansion requires infrastructure. You can conquer new markets with aggression, but you keep them only through administrative excellence and self-sufficiency."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Rajasthan",
        "Category": "Battles",
        "Region": "West",
        "Summary": "When a coalition of Indian Kings stopped the Umayyad Caliphate.",
        "Description": "In the 8th Century, a massive Arab army attempted to invade mainland India. Nagabhata I of the Gurjara-Pratihara dynasty and Bappa Rawal of Mewar formed a rare coalition. They decisively defeated the invaders in the deserts of Rajasthan, protecting the Indian heartland from foreign conquest for the next 300 years.",
        "Modern Edge": "Coalitions win where solo heroes fail. When facing a market disruptor, drop the ego and form strategic alliances to protect your core territory."
      },
      {
        "Title": "The Battle of Tunga",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The Rajput resistance against the Maratha-Mughal pressure.",
        "Description": "In 1787, the combined forces of Jaipur and Jodhpur faced the professionalized battalions of Mahadji Scindia. Despite facing heavy artillery, the Rajput cavalry charged with such intensity that they forced a stalemate and eventual retreat. It remains a testament to the traditional valor of the desert warriors.",
        "Modern Edge": "Technology is not a substitute for morale. A motivated team with conviction can outmaneuver a better-funded competitor who lacks spirit."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "Suheldev: The Protector of Shravasti",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The king who defeated the Ghaznavid army.",
        "Description": "When Salar Masud, the nephew of Mahmud Ghazni, invaded India with a massive force, King Suheldev of Shravasti gathered local tribes and kings. In 1033 CE at Bahraich, he wiped out the entire invading army. For nearly 150 years after this battle, no foreign invader dared to cross into the Gangetic plains.",
        "Modern Edge": "Decisive action in a crisis buys decades of stability. Don't procrastinate on existential threats; handle them with overwhelming focus to secure your future."
      },
      {
        "Title": "The Sacrifice of Panna Dhai",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The nurse who sacrificed her own son to save the heir of Mewar.",
        "Description": "When the assassin Banbir came to kill the infant Prince Udai Singh, Panna Dhai placed her own sleeping son in the royal bed. She watched her son die to ensure that the bloodline of Mewar survived. Prince Udai Singh grew up to found Udaipur, a city that stands today because of a mother's ultimate sacrifice.",
        "Modern Edge": "Stewardship sometimes demands painful sacrifices. True loyalty is prioritizing the organization's long-term survival over your personal attachments."
      },

      // --- FREEDOM FIGHTERS ---
      {
        "Title": "Birsa Munda: Dharati Aba",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The tribal leader who challenged the British Empire.",
        "Description": "Birsa Munda led the 'Ulgulan' (Great Tumult) against the British and the exploitative Zamindari system. He worked to restore the tribal rights over their land and forests. Though he died in prison at age 25, his movement forced the British to pass laws protecting tribal lands, making him a legend in Indian history.",
        "Modern Edge": "Disruption comes from the edge. Never underestimate the power of a grassroots movement organized around a shared identity and rights."
      },
      {
        "Title": "Alluri Sitarama Raju: Manyam Veerudu",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The hero of the Rampa Rebellion.",
        "Description": "A young man who became a sanyasi and led the tribal people of Andhra Pradesh in a guerrilla war against the British. He raided police stations to seize weapons for his people. He was so respected that even his enemies admired his integrity and tactical brilliance in the dense forests.",
        "Modern Edge": "Resourcefulness beats resources. If you lack capital, use your terrain and local knowledge to outwit a larger, slower incumbent."
      },
      {
        "Title": "Vanchinathan and the Ashe Murder",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The young revolutionary of Tamil Nadu.",
        "Description": "Vanchinathan was part of a secret society dedicated to ending British rule. In 1911, he assassinated the collector Robert Ashe, who was known for suppressing the Swadeshi shipping movement. Vanchinathan then took his own life to avoid capture, leaving a note stating that his action was to alert the world to the plight of India.",
        "Modern Edge": "A single act of conviction can pierce the veil of apathy. Sometimes, you must be the catalyst that forces the world to pay attention."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Madhava: The Father of Calculus",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The Kerala mathematician who found infinite series before Newton.",
        "Description": "Madhava of Sangamagrama founded the Kerala School of Astronomy and Mathematics in the 14th century. He discovered the infinite series for Pi, sine, and cosine—concepts that form the basis of modern Calculus. His work was centuries ahead of European mathematicians like Gregory, Leibniz, and Newton.",
        "Modern Edge": "Look inward for global breakthroughs. You don't need to be in Silicon Valley to innovate; deep focus and local tradition can birth world-class discoveries."
      },
      {
        "Title": "Nagarjuna: The Master of Metallurgy",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "The ancient chemist who transformed base metals into gold-like alloys.",
        "Description": "Nagarjuna was a brilliant chemist and alchemist who lived in the Satavahana era. In his work 'Rasaratnakara', he described processes for the extraction of metals like silver, gold, and copper. He was a pioneer in the use of minerals in medicine, creating 'Rasayana' to prolong life and heal chronic diseases.",
        "Modern Edge": "Transform raw data into wisdom. The modern alchemist turns information into actionable insights that improve the quality of life."
      },
      {
        "Title": "Brahmagupta and the Laws of Negative Numbers",
        "Category": "Ancient Science",
        "Region": "West",
        "Summary": "The mathematician who taught the world how to use 'Zero'.",
        "Description": "In the 7th century, Brahmagupta wrote 'Brahmasphutasiddhanta'. He was the first to give rules to compute with zero and negative numbers. He referred to positive numbers as 'property' and negative numbers as 'debt', creating the logical framework for modern algebra and accounting.",
        "Modern Edge": "Define the void. Understanding what is missing (the zero) and what is owed (the negative) is as crucial as counting what you have."
      },

      // --- RULERS ---
      {
        "Title": "Rani Rashmoni: The Rebel Queen of Bengal",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The widow who defied the British East India Company to protect the poor.",
        "Description": "Rani Rashmoni was a visionary leader who managed a vast estate in Bengal. When the British imposed a tax on poor fishermen, she blocked the shipping trade on the Hooghly river until the tax was repealed. She built the Dakshineswar Kali Temple and stood as a pillar of strength against social and colonial oppression.",
        "Modern Edge": "Leverage your assets to force fairness. When regulations are unjust, use your economic power as a choke point to negotiate better terms."
      },
      {
        "Title": "The Maritime Genius of Kanhoji Angre",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Admiral who was never defeated by European navies.",
        "Description": "Kanhoji Angre was the Chief of the Maratha Navy. For over 30 years, he defended the Konkan coast against the British, Dutch, and Portuguese. He developed a system of coastal forts and fast, maneuverable ships that utilized local currents to trap and defeat the heavy, slow-moving European vessels.",
        "Modern Edge": "Play to your home court advantage. Don't fight a giant on their terms; lure them into your niche where their size becomes a liability."
      },
      {
        "Title": "Kapilendra Deva and the Suryavamsa Empire",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The king who defended Odisha from three directions.",
        "Description": "Rising from a humble background to become the Emperor of Odisha, Kapilendra Deva expanded his kingdom from the Ganges to the Kaveri. He was a great patron of Odia literature and culture, ensuring that his people’s identity remained strong despite constant external threats.",
        "Modern Edge": "Meritocracy is the only aristocracy that matters. Judge people by their output and capability, not their background or pedigree."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Puvathur",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The unsung resistance against the Portuguese expansion.",
        "Description": "When the Portuguese tried to dominate the spice trade in Kerala, local chieftains and the Zamorin of Calicut fought back. In the Battle of Puvathur, the local forces used guerrilla naval tactics to destroy Portuguese supply lines, delaying European colonization of the interior for decades.",
        "Modern Edge": "Asymmetric warfare works. Small, agile teams can disrupt massive supply chains by attacking the weak links rather than the main force."
      },
      {
        "Title": "The Battle of Itakhuli",
        "Category": "Battles",
        "Region": "East",
        "Summary": "The final Ahom victory that expelled the Mughals forever.",
        "Description": "In 1682, the Ahom army led by Dihingia Alun Borbarua fought the Mughals at Itakhuli. This decisive victory pushed the Mughal border back to the Manas river. After this battle, the Mughals never attempted to invade the Brahmaputra valley again, securing the sovereignty of Assam.",
        "Modern Edge": "Finish the job. A victory is only real if it establishes a boundary that the competition dares not cross again."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "Khudiram Bose: The Youngest Martyr",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The 18-year-old who walked to the gallows with a smile.",
        "Description": "Khudiram Bose was a teenage revolutionary in Bengal. He attempted to assassinate a cruel British judge to protest colonial atrocities. When he was caught and sentenced to death, he went to the gallows holding the Bhagavad Gita, becoming a symbol of eternal youth and sacrifice for India's freedom.",
        "Modern Edge": "Youthful idealism is a potent fuel. Channel the fearless energy of your youngest team members to challenge the status quo."
      },
      {
        "Title": "U Tirot Sing: The Hero of Khasi Hills",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The tribal chief who fought the British for four years.",
        "Description": "U Tirot Sing, a Khasi chief, realized the British were using road construction as a pretext for colonization. He organized his tribesmen and fought a fierce guerrilla war in the dense jungles of Meghalaya. Despite being outgunned, his bravery earned him the respect of even his British captors.",
        "Modern Edge": "Defend your culture. When external forces try to pave over your identity under the guise of 'development,' resistance is a strategic necessity."
      },
      {
        "Title": "The Bravehearts of Tarapur",
        "Category": "Battles",
        "Region": "Central",
        "Summary": "The 1932 massacre that mirrored Jallianwala Bagh.",
        "Description": "In a small village in Bihar, 34 young freedom fighters were killed by British police while trying to hoist the Tricolor flag at a government building. This remains the largest collection of martyrs in a single incident during the freedom struggle after 1919, yet their story remains largely untold.",
        "Modern Edge": "The unsung heroes build the foundation. Recognize and honor the silent contributors in your organization, not just the public faces."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Kanada: The Father of Atomic Theory",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who conceptualized the 'Anu' (Atom) 2,600 years ago.",
        "Description": "Acharya Kanada founded the Vaisheshika school of philosophy. He proposed that every object in the universe is made of 'Paramanu' (atoms), which are indestructible and eternal. He explained that atoms combine in pairs (dwinuka) and triplets (trinuka) to form different types of matter, predating John Dalton's atomic theory by more than two millennia.",
        "Modern Edge": "Think granular. Big problems are solved by understanding the fundamental particles—the atoms—of your business model."
      },
      {
        "Title": "Baudhayana: The First Geometrician",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The mathematician who wrote the Pythagoras theorem before Pythagoras.",
        "Description": "In the 'Baudhayana Sulba Sutra', written around 800 BCE, Baudhayana gave the geometric proof for the relationship between the sides of a right-angled triangle. He also calculated the square root of 2 and the value of Pi with incredible precision, all to help in the construction of complex Vedic altars.",
        "Modern Edge": "Theory precedes application. Build a strong theoretical framework (your theorem) before you start construction, to ensure your structures stand tall."
      },
      {
        "Title": "Adi Shankara: The Unifier of India",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The philosopher who revitalized Advaita Vedanta at age 32.",
        "Description": "Adi Shankara traveled from Kerala to the Himalayas on foot four times. He established four 'Mathas' in the four corners of India (Puri, Dwaraka, Sringeri, Badrinath), weaving the spiritual fabric of the nation together. His philosophy of Non-dualism (Advaita) remains one of the most profound intellectual achievements of mankind.",
        "Modern Edge": "Institutionalize your vision. Don't just preach; build centers of excellence (Mathas) that can carry your philosophy forward without you."
      },
      {
        "Title": "Vachaspati Misra: The Intellectual Giant",
        "Category": "Scholars",
        "Region": "East",
        "Summary": "The 9th-century scholar who mastered every school of Indian philosophy.",
        "Description": "Living in Mithila, Vachaspati Misra wrote commentaries on almost every major branch of Indian thought—Yoga, Nyaya, Vedanta, and Samkhya. His work was so detailed that he is said to have forgotten his own wedding while writing, naming his masterpiece 'Bhamati' after his wife as a tribute to her patience.",
        "Modern Edge": "Deep work requires sacrifice. To master a domain, you must be willing to immerse yourself so fully that the trivialities of life fade away."
      },

      // --- RULERS ---
      {
        "Title": "Bappa Rawal: The Founder of Mewar",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who defeated the first major Arab invasion of India.",
        "Description": "Bappa Rawal consolidated the small clans of Rajasthan into a powerful force. In the 8th century, he didn't just stop the invading Umayyad Caliphate; he chased them back through the deserts into modern-day Afghanistan. His military prowess ensured that his dynasty, the Guhilots, would rule Mewar for 1,000 years.",
        "Modern Edge": "Offense is the best defense. Don't just stop a threat at your door; push it back so far that it cannot return for generations."
      },
      {
        "Title": "Rani Chennamma of Kittur",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The first female ruler to lead an armed rebellion against the British.",
        "Description": "In 1824, 33 years before the 1857 mutiny, Rani Chennamma stood against the British 'Doctrine of Lapse'. She defeated the British forces in the first battle at Kittur. Though she was eventually captured, her defiance became a rallying cry for the later freedom movement in Karnataka.",
        "Modern Edge": "Challenge the 'Doctrine of Lapse' in your industry. Just because a giant claims your space doesn't mean you have to yield; fight for your sovereignty."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Korgaon",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The Maratha victory that broke the myth of British invincibility.",
        "Description": "During the First Anglo-Maratha War in 1779, the Maratha forces led by Mahadji Scindia lured the British army deep into the Western Ghats. By cutting off their supplies and using the rugged terrain, the Marathas forced the British to sign the Treaty of Wadgaon, the only time the British army ever surrendered in India.",
        "Modern Edge": "Use the environment. When facing a superior force, drag them into a 'terrain' (market niche or technical complexity) where they get stuck and you thrive."
      },
      {
        "Title": "The Siege of Arcot",
        "Category": "Battles",
        "Region": "South",
        "Summary": "A turning point in the struggle for Southern India.",
        "Description": "In 1751, Robert Clive and Chanda Sahib fought a grueling 50-day siege. This battle changed the course of the Carnatic Wars and established British dominance over the French in India. It was a brutal conflict that showed how European rivalries played out on Indian soil.",
        "Modern Edge": "Endurance is a weapon. In a war of attrition, the side that can hold out one day longer than the opponent wins the psychological victory."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "Hemchandra Vikramaditya: The Last Hindu Emperor of Delhi",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The general who won 22 consecutive battles.",
        "Description": "Hemu started as a commoner and rose to become the Chief Minister. He won 22 battles against Afghan rebels and Mughal forces. In 1556, he captured Delhi and declared himself Emperor 'Vikramaditya'. He was on the verge of winning the Second Battle of Panipat until a stray arrow struck his eye, changing the fate of India.",
        "Modern Edge": "Momentum is fragile. You can win 22 battles and lose the war on the 23rd due to a random event. Always have a contingency for the 'stray arrow'."
      },
      {
        "Title": "The 13 Martyrs of Mahad",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The struggle for basic human dignity and water rights.",
        "Description": "Led by Dr. B.R. Ambedkar in 1927, thousands marched to the Chavdar Tank in Mahad to assert their right to drink water. This was not a battle of swords, but a battle for civil rights. It marked the beginning of a social revolution that eventually shaped the Constitution of India.",
        "Modern Edge": "Civil rights are non-negotiable. The fight for basic dignity (like water) is the most powerful motivator for mobilizing a community."
      },
      {
        "Title": "Komaram Bheem: Jal, Jangal, Zameen",
        "Category": "Freedom Fighters",
        "Region": "Central",
        "Summary": "The Gond leader who fought the Nizam's tyranny.",
        "Description": "Komaram Bheem led a rebellion against the Nizam of Hyderabad's forest taxes. He coined the slogan 'Jal, Jangal, Zameen' (Water, Forest, Land), asserting that those who live in the forest should own its resources. He fought using traditional weapons against modern guns until his martyrdom.",
        "Modern Edge": "Own your resources. 'Jal, Jangal, Zameen' isn't just a slogan; it's a mandate for stakeholders to control the assets they depend on."
      },
      {
        "Title": "Bhikaiji Cama: The Mother of the Indian Revolution",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The woman who unfurled the first Indian flag on foreign soil.",
        "Description": "In 1907, at the International Socialist Congress in Germany, Madam Cama hoisted the first version of the Indian National Flag. She spent her life in exile in Europe, organizing Indian revolutionaries and speaking out against British imperialism despite failing health and constant surveillance.",
        "Modern Edge": "Be the ambassador. You don't need to be on home soil to fight for your cause; use global platforms to amplify your local narrative."
      },
      // --- ANCIENT SCIENTISTS & SCHOLARS ---
      {
        "Title": "Sushruta: The Father of Surgery",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who performed plastic surgery 2,500 years ago.",
        "Description": "Long before modern medicine, Sushruta practiced in Kashi. He authored the Sushruta Samhita, describing over 300 surgical procedures and 120 surgical instruments. He is most famous for 'Rhinoplasty' (reconstructing a nose), using a flap of skin from the cheek or forehead—a technique essentially unchanged in modern surgery today.",
        "Modern Edge": "Document your craft. Innovation is lost without documentation; codify your techniques so they become the standard for the industry."
      },
      {
        "Title": "Aryabhata and the Concept of Zero",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The mathematician who calculated the Earth's circumference.",
        "Description": "In the 5th century, Aryabhata calculated the value of Pi to four decimal places and proposed that the Earth is spherical and rotates on its axis. By defining 'Zero' not just as a symbol but as a mathematical concept, he laid the foundation for modern computing and space exploration.",
        "Modern Edge": "Challenge the geocentric view. Be the first to propose a radical shift in perspective (like a rotating Earth) to change how the entire system is calculated."
      },

      // --- RULERS & DYNASTIES ---
      {
        "Title": "Chhatrapati Shivaji Maharaj: The Father of Indian Navy",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The strategic genius who built a naval force from scratch.",
        "Description": "Shivaji Maharaj realized early that 'He who rules the seas, rules the land.' He built strategic coastal forts like Sindhudurg and a powerful indigenous navy to defend against the Siddis, Portuguese, and British. His use of 'Ganimi Kava' (Guerrilla Warfare) and focus on 'Swarajya' (Self-rule) redefined Indian resistance.",
        "Modern Edge": "Build independent capabilities. Relying on foreign vendors for critical defense (or tech) is suicide; build your own 'Navy' to secure your coastline."
      },
      {
        "Title": "Rani Durgavati’s Defiance",
        "Category": "Freedom Fighters",
        "Region": "Central",
        "Summary": "The Gondwana Queen who chose death over surrender.",
        "Description": "Rani Durgavati ruled the Gondwana kingdom with great efficiency. When the Mughal army under Akbar attacked, she led her troops personally. Even when wounded by arrows in the eye and neck, she refused to surrender, choosing to take her own life with her dagger to maintain her dignity and honor.",
        "Modern Edge": "Exit on your own terms. If defeat is inevitable, control the narrative of your end rather than letting the competition dismantle you."
      },
      {
        "Title": "Raja Raja Chola I and the Great Living Temples",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who built the Brihadisvara Temple without a shadow.",
        "Description": "Raja Raja Chola I was a visionary who built the Brihadisvara Temple in Thanjavur. The temple's 'Kumbam' (top stone) weighs 80 tons and was moved to the top via a 6km long ramp. His administration was so advanced that it included an early form of local self-government and a massive land survey.",
        "Modern Edge": "Build for the millennium. Don't just meet quarterly targets; create infrastructure and systems (like the Big Temple) that will outlast your tenure."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Haldighati",
        "Category": "Battles",
        "Region": "North",
        "Summary": "Maharana Pratap's legendary stand for independence.",
        "Description": "In 1576, Maharana Pratap faced the massive Mughal army. Despite being outnumbered, Pratap and his loyal horse Chetak fought with legendary bravery. Pratap never surrendered his pride or his land, living in the Aravalli forests for years to continue his struggle for Mewar's freedom.",
        "Modern Edge": "Tactical retreat is not failure. If you can't win the open battle, move to the hills and fight a guerrilla war until you bleed the enemy dry."
      },
      {
        "Title": "The Naval Battle of Colachel",
        "Category": "Battles",
        "Region": "South",
        "Summary": "When an Indian Kingdom defeated a European superpower.",
        "Description": "In 1741, King Marthanda Varma of Travancore defeated the Dutch East India Company. This was the first time an Asian power had decisively defeated a European naval force in a organized war, effectively ending Dutch colonial ambitions in India.",
        "Modern Edge": "Disrupt the supply chain. You can defeat a technologically superior global player by cutting off their logistics and isolating them."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "Banda Singh Bahadur’s Justice",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The man who abolished the Zamindari system.",
        "Description": "An ascetic turned warrior, Banda Singh Bahadur was sent by Guru Gobind Singh to protect the people of Punjab. He established a state where the tillers owned the land, abolishing the oppressive Zamindari system, and issued coins in the name of the Gurus before his martyrdom.",
        "Modern Edge": "Empower the producer. Real economic reform happens when you remove the middlemen (Zamindars) and give ownership to the creators."
      },
      {
        "Title": "Ahilyabai Holkar: The Philosopher Queen",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "Rebuilding India's spiritual spine.",
        "Description": "After losing her family, she didn't retreat. She ruled Indore for 30 years, building temples from Somnath to Kashi. She was known for her accessibility to her subjects and her strict adherence to Dharma, earning the title 'Matoshree'.",
        "Modern Edge": "Spirituality is infrastructure. Investing in the cultural and spiritual well-being of your ecosystem creates a loyalty that money cannot buy."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Pingala: The Binary Code Pioneer",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The scholar who described binary numbers 2,000 years ago.",
        "Description": "In his work 'Chandaḥśāstra', Pingala analyzed Sanskrit poetry and prosody. To map out patterns of short and long syllables, he created a system that is functionally identical to modern binary code (0s and 1s). He also described the 'Meru Prastara', which is known today in the West as Pascal's Triangle.",
        "Modern Edge": "Find the pattern. Behind every complex art form (like poetry) lies a binary logic; decode it to master the structure of creativity."
      },
      {
        "Title": "Thiruvalluvar: The Divine Poet",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The author of Thirukkural, the guide to ethical living.",
        "Description": "Thiruvalluvar composed 1,330 couplets (Kurals) covering ethics, wealth, and love. His work is entirely secular and universal, translated into almost every major language in the world. He lived as a simple weaver, proving that the most profound philosophical insights can come from a life of humble labor.",
        "Modern Edge": "Ethics is universal currency. Write a code of conduct that applies to the king and the commoner alike to build a trust-based society."
      },
      {
        "Title": "Bhaskaracharya I: The Astronomer of Kerala",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The scientist who pioneered the study of planetary positions.",
        "Description": "Not to be confused with Bhaskara II, the first Bhaskara was a 7th-century astronomer who wrote the 'Mahabhaskariya'. He gave a unique rational approximation for the sine function, which was incredibly accurate for its time and was used by sailors and astronomers across the Indian Ocean for navigation.",
        "Modern Edge": "Approximation is useful. You don't always need the exact answer; a rational approximation that works in practice is better than a perfect theory that stays on paper."
      },

      // --- RULERS ---
      {
        "Title": "Gautamiputra Satakarni: The Destroyer of Shakas",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The king who restored the pride of the Satavahana Dynasty.",
        "Description": "Gautamiputra Satakarni inherited a weak kingdom but transformed it into an empire. He decisively defeated the Western Kshatrapas and foreign invaders like the Shakas and Yavanas. He was unique for using his mother's name as a prefix, showing the high status of women in his society and his deep devotion to his roots.",
        "Modern Edge": "Rebrand with your roots. When reviving a legacy, wear your identity (and your mother's name) proudly to signal a return to core values."
      },
      {
        "Title": "Martanda Varma: The Maker of Modern Travancore",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who dedicated his entire kingdom to the Divine.",
        "Description": "After defeating the Dutch, Martanda Varma did something unprecedented. He performed 'Thrippadidanam', surrendering his kingdom and sword to Lord Padmanabhaswamy and ruling thereafter as a 'Padmanabha Dasa' (servant of the Lord). This act of humility ensured that the royal family saw themselves as trustees, not owners, of the people's wealth.",
        "Modern Edge": "Servant Leadership. Dedicate your enterprise to a higher purpose (the Divine); acting as a trustee rather than an owner reduces ego and increases trust."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Sakharkherda",
        "Category": "Battles",
        "Region": "Central",
        "Summary": "The establishment of the Nizam's independence in the Deccan.",
        "Description": "In 1724, Nizam-ul-Mulk fought against the Mughal-backed Mubariz Khan. This battle marked the end of direct Mughal control over the Deccan and the birth of the Hyderabad State. It showed how the fragmentation of the central Mughal power led to the rise of powerful regional identities and military structures.",
        "Modern Edge": "Decentralization creates opportunity. When the central monolith cracks, be ready to carve out your own independent niche."
      },
      {
        "Title": "The Battle of Rakshas Tangadi (Talikota)",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The tragic end of the magnificent Vijayanagara Empire.",
        "Description": "In 1565, a coalition of Deccan Sultanates joined forces against Rama Raya of Vijayanagara. Despite the empire's wealth and military size, internal betrayals and superior gunpowder technology of the invaders led to a crushing defeat. The city of Hampi was looted for six months, leaving behind the ruins we see today.",
        "Modern Edge": "Diversify your risk. Putting all your wealth and prestige in one basket (one city) makes you a target; resilience requires distributed assets."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "Tantya Bhil: The Indian Robin Hood",
        "Category": "Forgotten Heroes",
        "Region": "Central",
        "Summary": "The tribal revolutionary who fed the hungry.",
        "Description": "Tantya Bhil was a legendary figure in Madhya Pradesh who fought British exploitation for 12 years. He would loot the British treasuries and distribute the grain and money among the poor tribes. He was so popular that the British had to use an army of spies to finally capture him, as no local person would betray him.",
        "Modern Edge": "Redistribute value. If the system hoards wealth, be the disruptor who unlocks it for the underserved to build a loyal user base."
      },
      {
        "Title": "Jhalkari Bai: The Shadow of the Rani",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The brave soldier who disguised herself as Rani Laxmibai.",
        "Description": "A member of the Durga Dal (women’s army), Jhalkari Bai looked remarkably like Rani Laxmibai. During the Siege of Jhansi, she took command of the army and rode out disguised as the Queen to draw the British fire away, allowing the real Rani Laxmibai to escape safely. She fought until her last breath to protect her leader.",
        "Modern Edge": "The power of the decoy. Use deception and body doubles to protect your core asset (the leader) while drawing enemy fire to expendable targets."
      },

      // --- FREEDOM FIGHTERS ---
      {
        "Title": "Sidhu and Kanhu Murmu: The Santhal Rebellion",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The brothers who led the first major peasant revolt.",
        "Description": "In 1855, two years before the Sepoy Mutiny, the Santhal brothers Sidhu and Kanhu mobilized 30,000 Santhals against the British and oppressive moneylenders. Armed only with bows and arrows, they took over large parts of Bengal and Bihar before the British deployed specialized forces to suppress the movement.",
        "Modern Edge": "Primitive weapons can still wound. Don't underestimate a low-tech competitor; their sheer numbers and desperation can overwhelm a professional force."
      },
      {
        "Title": "Pritilata Waddedar: The Revolutionary of Chittagong",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The teacher who led an attack on a 'Europeans Only' club.",
        "Description": "A student of Surya Sen, Pritilata led a group of revolutionaries to attack the Pahartali European Club, which had a sign saying 'Dogs and Indians not allowed.' After the successful raid, she was cornered by police. To avoid capture, she consumed cyanide, sacrificing her life at age 21 for the honor of her nation.",
        "Modern Edge": "Shatter the glass ceiling with force. When exclusion is systemic, polite requests don't work; you need a raid to break down the doors."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Vishwakarma: The Architect of the Gods",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The legendary engineer of ancient Indian cities.",
        "Description": "In Indian tradition, Vishwakarma is the divine engineer. Historically, the 'Vishwakarma' community developed the Vastu Shastra—a sophisticated system of civil engineering and architecture. They mastered the science of acoustics, town planning, and the 'Lost Wax' casting method used to create the world's most detailed bronze icons.",
        "Modern Edge": "Engineering is divine. Treat your product development not as a job, but as a sacred act of creation that shapes the world."
      },
      {
        "Title": "The Iron Pillar of Delhi: Ancient Metallurgy",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The 1,600-year-old pillar that refuses to rust.",
        "Description": "Built during the Gupta Empire, this 7-meter tall pillar is a metallurgical marvel. Despite standing in the open air for over 16 centuries, it has not rusted. Modern scientists discovered that ancient Indian smiths used a high-phosphorus content in the iron, creating a protective 'misawite' layer—a technology far ahead of its time.",
        "Modern Edge": "Material science matters. Invest in quality (like high-phosphorus iron) that prevents 'rust' (technical debt) and keeps your product standing for centuries."
      },
      {
        "Title": "Abhinavagupta: The Master of Aesthetics",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The philosopher who decoded the science of emotions.",
        "Description": "A polymath from Kashmir, Abhinavagupta wrote the 'Abhinavabharati'. He developed the 'Rasa' theory, explaining how art, music, and drama evoke specific emotional states in the human mind. His work is the foundation of Indian classical dance and music theory.",
        "Modern Edge": "Master the user experience. It's not just about the product; it's about the 'Rasa'—the emotional journey you take the user on."
      },

      {
        "Title": "Mahadji Scindia: The Regent of Delhi",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The statesman who restored Maratha influence over North India.",
        "Description": "After the disaster at Panipat, it was Mahadji Scindia who rebuilt the Maratha power. He professionalized his army with European-style infantry and artillery. For decades, he was the 'Vakil-ul-Mutlaq' (Regent) of the Mughal Emperor, effectively making the Marathas the true masters of the Indian heartland.",
        "Modern Edge": "Adapt or die. Even if you are a traditional power, you must adopt modern methods (French infantry) to remain relevant on the global stage."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Umberkhind",
        "Category": "Battles",
        "Region": "West",
        "Summary": "Shivaji Maharaj's masterclass in mountain warfare.",
        "Description": "In 1661, a massive Mughal army under Kartalab Khan tried to cross the Sahyadri mountains. Shivaji Maharaj lured them into the narrow, forested pass of Umberkhind. Hidden Maratha soldiers attacked from all sides using rocks and arrows. The Mughals were so trapped they had to surrender their entire treasury just to be allowed to retreat.",
        "Modern Edge": "Control the funnel. Lure your competition into a narrow channel where their size is a disadvantage and your agility allows you to strike from all sides."
      },
      {
        "Title": "The Battle of Pullalur",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The victory of the Pallavas over the Chalukyas.",
        "Description": "King Mahendravarman I of the Pallava dynasty faced a massive invasion by the Chalukya king Pulakeshin II. At Pullalur, the Pallavas fought a defensive masterpiece that saved their capital, Kanchipuram. This battle sparked a centuries-long rivalry that defined the culture and politics of Southern India.",
        "Modern Edge": "Defense defines the dynasty. A successful defense of your capital establishes your legitimacy more than any aggressive campaign."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "Sarkhel Kanhoji Angre’s Fortress",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The unconquerable island of Khanderi.",
        "Description": "Kanhoji Angre fortified the island of Khanderi just off the coast of Mumbai. The British and Portuguese tried multiple times to capture it with their superior warships, but Angre's small, fast 'Gallivats' used the shallow waters and rocky coast to wreck the enemy ships, maintaining Indian control over the waters.",
        "Modern Edge": "Fortify your island. Create a defensive moat (geography/IP) that makes it too costly for larger competitors to acquire you."
      },
      {
        "Title": "The Courage of Onake Obavva",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The woman who defended a fort with a pestle.",
        "Description": "When the forces of Hyder Ali tried to sneak into the Chitradurga Fort through a narrow hole, Obavva saw them. While her husband was at lunch, she took a wooden pestle (Onake) and killed the soldiers one by one as they emerged from the hole, saving the fort until the guards were alerted.",
        "Modern Edge": "Improvise. You don't need a sword to be a warrior; use the 'pestle' (the tool at hand) to solve the immediate crisis."
      },

      // --- FREEDOM FIGHTERS ---
      {
        "Title": "Vasudev Balwant Phadke: The Father of Armed Rebellion",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The clerk who left his job to start a revolution.",
        "Description": "Moved by the plight of farmers during the famine, Phadke formed a revolutionary group of Ramoshis and Dhangars. He led raids against British communications and treasuries in Maharashtra, aiming to establish an Indian Republic. He was the first to use organized guerrilla warfare against the British in the 19th century.",
        "Modern Edge": "Start the fire. You don't need a massive army to begin; a small, committed group can disrupt the state's machinery through targeted strikes."
      },
      {
        "Title": "Tirupur Kumaran: Kodi Kaatha Kumaran",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The man who died holding the flag aloft.",
        "Description": "During a protest against the British in 1932, Kumaran was brutally assaulted by the police. Even as he fell unconscious and eventually died from his injuries, he refused to let the Indian National Flag touch the ground. He is remembered in Tamil Nadu as the hero who 'protected the flag'.",
        "Modern Edge": "Protect the brand symbol. Even when you are down, never let the flag (your core values) touch the ground; it inspires others to pick it up."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Narayana Pandita: The Master of Combinatorics",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The 14th-century mathematician who explored 'Magic Squares'.",
        "Description": "Narayana Pandita's 'Ganita Kaumudi' contains the earliest known discussion of combinatorics and magic squares in India. He developed methods to calculate the number of permutations of a set and explored sequence patterns that predate modern Western mathematics, showing that Indian logic was deeply experimental and numerical.",
        "Modern Edge": "Explore the permutations. Innovation often comes from combinatorics—rearranging existing elements in new patterns to find magic."
      },
      {
        "Title": "Lagadha: The Father of Indian Astronomy",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The sage who authored the Vedanga Jyotisha.",
        "Description": "Lagadha was one of the first to systematize astronomy to determine the timing for Vedic rituals. He calculated the solstices and the lunar cycles with high accuracy around 1200 BCE. His work laid the foundation for the 'Panchang' system that Indians use to this day to understand the movements of celestial bodies.",
        "Modern Edge": "Sync with the cycle. Success is about timing; use data (astronomy) to align your actions with the natural cycles of the market."
      },

      // --- RULERS ---
      {
        "Title": "The Lion of Gondwana: Raja Bakht Buland Shah",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The ruler who founded the city of Nagpur.",
        "Description": "Bakht Buland Shah was a visionary Gond ruler who transformed a series of small villages into the thriving city of Nagpur. He invited craftsmen, merchants, and farmers from all over India to settle in his kingdom, creating a multicultural hub of trade and agriculture that remains one of India's most important cities today.",
        "Modern Edge": "Invite diversity. A city (or company) thrives when you actively recruit diverse talent—craftsmen, merchants, farmers—to build a self-sustaining ecosystem."
      },
      {
        "Title": "Rani Avantibai Lodhi of Ramgarh",
        "Category": "Freedom Fighters",
        "Region": "Central",
        "Summary": "The first female martyr of the 1857 revolution in MP.",
        "Description": "When the British took over Ramgarh using the Doctrine of Lapse, Rani Avantibai raised an army of 4,000. She personally led her troops into battle and defeated the British in the first encounter. When finally surrounded, she chose to die by her own sword rather than be captured, stating that she belonged to her land, not to the crown.",
        "Modern Edge": "Lead from the front. When the chips are down, the leader must be on the battlefield, not in the boardroom."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Bhadli",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The final stand of the Jethwa clan.",
        "Description": "This battle represents the fierce internal rivalries and external pressures of the Saurashtra region. It highlights the 'Paaliyas' (hero stones) culture of Gujarat, where warriors fought to protect their villages and cattle, proving that valor was not just for emperors but for every village chieftain.",
        "Modern Edge": "Local valor counts. You don't need to be an emperor to be a hero; defending your specific village/niche is a noble and necessary fight."
      },
      {
        "Title": "The Battle of Topra",
        "Category": "Battles",
        "Region": "North",
        "Summary": "Firoz Shah Tughlaq’s encounter with the Ashokan Pillars.",
        "Description": "While not a battle between armies, this was a battle of engineering. Tughlaq was so fascinated by the massive Ashokan pillars at Topra that he devised an elaborate system involving silk cotton and thousands of laborers to transport them to Delhi without a single crack, showing the enduring awe ancient Indian engineering inspired.",
        "Modern Edge": "Logistics is art. Moving a massive idea (or pillar) without cracking it requires as much genius as carving it in the first place."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The 1200 Architects of Konark",
        "Category": "Forgotten Heroes",
        "Region": "East",
        "Summary": "The anonymous masters who built the Sun Temple.",
        "Description": "The Sun Temple at Konark was built by 1,200 craftsmen over 12 years. The legend of Dharmapada tells of the chief architect's son who completed the temple's crown when the masters failed. To save the reputation of the 1,200 workers from the King's wrath, the boy jumped into the sea, sacrificing himself for his community.",
        "Modern Edge": "Protect the team. Sometimes, one person must take the fall to save the reputation and livelihood of the entire collective."
      },
      {
        "Title": "Matangini Hazra: The Old Lady Gandhi",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The 73-year-old who faced British bullets for the flag.",
        "Description": "In 1942, during the Quit India Movement, Matangini Hazra led a peaceful procession in Bengal. Even after being shot repeatedly by British police, she kept marching and chanting 'Vande Mataram,' holding the Tricolour high so it wouldn't fall until she collapsed. Her bravery shamed the armed soldiers who faced her.",
        "Modern Edge": "Non-violent persistence is terrifying. A leader who refuses to stop marching despite being hit commands a respect that brute force cannot."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Dharmapala and the Nalanda Renaissance",
        "Category": "Scholars",
        "Region": "East",
        "Summary": "The king who made India the global center of learning.",
        "Description": "Emperor Dharmapala of the Pala Dynasty revived Nalanda and founded Vikramshila University. Under his patronage, these centers housed 10,000 students and 2,000 teachers from across Asia. They taught everything from logic and grammar to medicine and star-mapping, preserving the world's knowledge in 'Dharmaganja', the massive nine-story library.",
        "Modern Edge": "Invest in the knowledge economy. Building universities (R&D centers) yields higher long-term returns than building palaces."
      },
      {
        "Title": "Atisa Dipamkara: The Light of Asia",
        "Category": "Scholars",
        "Region": "East",
        "Summary": "The Bengali scholar who traveled to Tibet to restore peace.",
        "Description": "Atisa was a high priest at Vikramshila. In the 11th century, at the age of 60, he crossed the treacherous Himalayas on foot to reach Tibet. He translated hundreds of Sanskrit texts and reformed the spiritual practices of the region, creating a cultural bridge between India and the roof of the world that exists to this day.",
        "Modern Edge": "Cross the mountains. Don't hoard your wisdom; travel to difficult markets (Tibet) to share it, and you will become a legend."
      },
      {
        "Title": "Hemachandracharya: The Omniscient",
        "Category": "Scholars",
        "Region": "West",
        "Summary": "The 12th-century polymath of Gujarat.",
        "Description": "A scholar in the court of Kumarapala, Hemachandracharya wrote the 'Siddha-Hema-Shabdanushasana', a comprehensive grammar. He was a master of logic, mathematics, and history. He is credited with describing the 'Fibonacci' sequence patterns in Sanskrit poetry long before Leonardo Fibonacci was born in Italy.",
        "Modern Edge": "Be a polymath. Don't specialize too early; cross-pollinate ideas from grammar to math to history to see patterns others miss."
      },

      // --- RULERS ---
      {
        "Title": "The Republics of the Licchavis",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The world's first successful experiments with democracy.",
        "Description": "Long before the Greeks, the Licchavis of Vaishali practiced a 'Gana-Sangha' (republican) form of government. Decisions were made in a central assembly (Santhagara) where members voted using wooden pieces called 'Salakas'. They proved that collective leadership and the rule of law could govern a prosperous and stable society.",
        "Modern Edge": "Democracy is ancient tech. Consensus-based decision making (voting) isn't a modern invention; it's a time-tested method for stability."
      },
      {
        "Title": "Rani Naiki Devi: The Vanquisher of Ghori",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Queen of Gujarat who defeated Muhammad Ghori.",
        "Description": "In 1178 CE, Muhammad Ghori invaded Gujarat. Rani Naiki Devi, the regent queen, took her young son on her lap and led the Solanki army into the rugged terrain of Kayadara. She utilized the geography to trap Ghori's forces, inflicting such a crushing defeat that he did not dare attack India for another 13 years.",
        "Modern Edge": "Leverage your vulnerability. Use the enemy's perception of your weakness (a woman with a child) to lure them into a trap they don't see coming."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Sammel",
        "Category": "Battles",
        "Region": "West",
        "Summary": "Sher Shah Suri’s narrow escape against the Rathores.",
        "Description": "In 1544, Sher Shah Suri faced the Marwar army led by Jaita and Kumpa. Despite having a massive army, Sher Shah was nearly defeated by the sheer ferocity of the 12,000 Rajput warriors. After the victory, he famously remarked: 'For a handful of bajra (millet), I had almost lost the empire of Hindustan.'",
        "Modern Edge": "Respect the underdog. Never assume a small competitor is easy prey; they can make you pay a price so high that victory feels like defeat."
      },
      {
        "Title": "The Siege of Janjira",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The unconquerable sea fort that resisted all powers.",
        "Description": "For centuries, the Marathas, British, and Portuguese tried to capture the sea fort of Janjira, held by the Siddis. Despite massive naval blockades and even attempts to build a stone bridge through the sea by Sambhaji Maharaj, the fort remained independent, highlighting the importance of naval architecture and defensive planning.",
        "Modern Edge": "Build on the rock. A foundation in the middle of the 'sea' (a unique market position) is harder to attack than a castle on the mainland."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Nameless Weavers of Muslin",
        "Category": "Forgotten Heroes",
        "Region": "East",
        "Summary": "The masters of 'Woven Air' that the world envied.",
        "Description": "The weavers of Dhaka and Bengal produced Muslin, a fabric so fine a 50-meter roll could pass through a thumb ring. When the British industrial revolution began, they couldn't compete with this quality. Legend says the British cut the thumbs of these master weavers to destroy the industry, a dark chapter in the history of Indian craftsmanship.",
        "Modern Edge": "Quality is a threat. If your product is too good, incumbents might try to 'cut your thumbs'; protect your trade secrets."
      },
      {
        "Title": "Vandevi: The Warrior of the Forests",
        "Category": "Forgotten Heroes",
        "Region": "Central",
        "Summary": "The tribal woman who protected the sacred groves.",
        "Description": "In the tribal belts of Central India, oral traditions tell of Vandevi, who organized forest dwellers to protect their sacred 'Sarnas' from being cut down for colonial timber. She taught her people that the forest was not a resource to be sold, but a parent to be protected, predating the modern Chipko movement by centuries.",
        "Modern Edge": "Conservation is self-preservation. Protect the resource base (the forest) that sustains you, or you will have nothing left to rule over."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Sawai Jai Singh II and Jantar Mantar",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The King who built the world's largest stone sundials.",
        "Description": "In the early 18th century, Maharaja Jai Singh II built five astronomical observatories called Jantar Mantars. Dissatisfied with small brass instruments, he built massive stone structures to measure time, track stars, and predict eclipses with an accuracy of within two seconds. The Samrat Yantra in Jaipur remains the largest stone sundial in the world.",
        "Modern Edge": "Scale up your tools. If existing instruments aren't accurate enough, build massive ones. Precision requires investment in infrastructure."
      },
      {
        "Title": "The Iron-Cased Rockets of Hyder Ali",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The invention that birthed modern rocket science.",
        "Description": "During the Anglo-Mysore Wars, Hyder Ali and Tipu Sultan developed the first iron-cased rockets. Unlike the bamboo rockets used in China, the iron casing allowed for higher internal pressure and longer ranges (up to 2km). After the wars, the British took these rockets to England to develop the Congreve rocket, directly influencing modern missile technology.",
        "Modern Edge": "Weaponize R&D. Developing a proprietary technology (iron casing) can give you a range advantage that forces the enemy to copy you."
      },
      {
        "Title": "The Sangam Scholars and the First Academy",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The 2,000-year-old literary tradition of Tamil Nadu.",
        "Description": "The Sangam periods were massive gatherings of poets and scholars in Madurai. They produced a body of work (Ettuthogai and Pattupattu) that is remarkable for its focus on secular life, ethics, and nature. They developed a unique classification of 'Thinai' (landscapes), mapping human emotions to the specific geography of the land.",
        "Modern Edge": "Map the emotional landscape. Understand your audience's 'Thinai' (context); content that resonates with their specific environment wins."
      },

      // --- RULERS ---
      {
        "Title": "The Magnanimity of Raja Paari",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who gave his chariot to a climbing jasmine plant.",
        "Description": "One of the 'Seven Great Patrons' (Kadai Ezhu Vallalgal) of the Sangam era, King Paari was famous for his empathy. Legend says that while traveling, he saw a weak jasmine creeper with no support. He left his royal chariot in the forest so the plant could climb on it, symbolizing that a ruler's duty extends to all living beings, not just humans.",
        "Modern Edge": "Empathy is power. Helping the helpless (even a plant) signals a surplus of strength and character that attracts loyal followers."
      },
      {
        "Title": "Amoghavarsha I: The Scholar Emperor",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Rashtrakuta king known as the 'Ashoka of the South'.",
        "Description": "Amoghavarsha I ruled for 64 years, one of the longest reigns in history. He was a deeply religious and scholarly man who wrote the 'Kavirajamarga', the earliest available work on Kannada poetics. He was known for his peace-loving nature, choosing to solve conflicts through diplomacy and culture rather than constant warfare.",
        "Modern Edge": "Soft power lasts longer. You can rule by the sword for a decade, or by culture and peace for 64 years. Choose stability."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Koppam",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The Chola victory led by a king crowned on the battlefield.",
        "Description": "In 1054 CE, the Chola and Chalukya armies met in a brutal conflict. The Chola King Rajadhiraja was killed while leading from the front on an elephant. His younger brother, Rajendra II, didn't retreat. He immediately took the command, was crowned king right there on the battlefield, and turned a certain defeat into a massive victory.",
        "Modern Edge": "Crisis succession. When the leader falls, the next in line must step up immediately—on the battlefield—to prevent panic and turn the tide."
      },
      {
        "Title": "The Battle of Merta",
        "Category": "Battles",
        "Region": "West",
        "Summary": "A display of unmatched cavalry bravery.",
        "Description": "In 1790, the Maratha forces under De Boigne faced the Rathore cavalry of Jodhpur. The Rathores performed a legendary 'death charge', riding straight into the mouth of modern artillery. Though they lost due to the technological gap, their bravery was so immense that the French generals in the Maratha camp saluted them in respect.",
        "Modern Edge": "Bravado isn't strategy. You can have the bravest charge in history, but if you ignore the technological gap (artillery), you will lose."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Nameless Sculptors of Ellora",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "Carving a cathedral from a single mountain top-down.",
        "Description": "The Kailasa Temple at Ellora was carved out of a single rock. Unlike most buildings, it was built from the top down. 200,000 tons of rock were removed with only hammers and chisels. The engineering was so precise that even the drainage systems and ventilation were planned before the first strike of the hammer.",
        "Modern Edge": "Reverse engineer the vision. Sometimes you have to build from the top down; visualize the final outcome and carve away everything that isn't it."
      },
      {
        "Title": "Gunda Dhur and the Bhumkal Rebellion",
        "Category": "Forgotten Heroes",
        "Region": "Central",
        "Summary": "The tribal hero of Bastar who fought the British.",
        "Description": "In 1910, Gunda Dhur led the tribes of Bastar against the British forest policies. He used 'Lali Mirchi' (Red chillies) and mango branches as secret signals to mobilize villages. He successfully cut off British communications for weeks, fighting for the 'Bhum' (land) and the rights of the indigenous people.",
        "Modern Edge": "Communicate in code. Use symbols (chillis and mangoes) that your community understands but the oppressor ignores to organize a revolt."
      },
      {
        "Title": "The Battle of the Hydaspes",
        "Category": "Battles",
        "Region": "North",
        "Summary": "How the Paurava resistance broke the morale of the Macedonian army.",
        "Description": "In 326 BCE, the invading forces of Alexander encountered King Porus. While Western accounts claim a Greek victory, the aftermath suggests a different story. The Macedonian army, having faced the ferocity of Indian war-elephants and the unparalleled valor of the Paurava infantry, suffered such heavy casualties that they mutinied. Alexander was forced to stop his campaign and retreat, never reaching the heart of India. Porus remained a powerful sovereign, proving that the Indian defense had successfully blunted the greatest military machine of the West.",
        "Modern Edge": "Make them bleed. You don't have to win the battle to win the war; if you inflict enough cost, the enemy will lose the will to continue."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "The Wootz Steel Revolution",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The world's first high-carbon steel developed in South India.",
        "Description": "Centuries before the industrial revolution, Indian smiths in the South developed 'Wootz Steel'. By heating iron with charcoal in closed crucibles, they created steel with a high carbon content and a beautiful wavy pattern. This steel was exported to Damascus to make the world-famous 'Damascus Swords', which could cut through a falling silk scarf and never lost their edge.",
        "Modern Edge": "Process is IP. The secret isn't just the material (iron), but the process (crucible heating); master the 'how' to create a superior product."
      },
      {
        "Title": "Sarangadhara: The Medieval Veterinarian",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The author of the world's first comprehensive book on plant and animal health.",
        "Description": "In the 13th century, Sarangadhara wrote the 'Upavana Vinoda', detailing the science of 'Vrikshayurveda' (Health of plants). He described how to treat plant diseases, create seed hybrids, and even how to make plants bloom out of season. His work proved that India had a deep ecological science that treated plants as living, feeling beings.",
        "Modern Edge": "Holistic health. Extend your care systems beyond just the core workforce to the entire ecosystem (plants and animals) for true sustainability."
      },

      // --- RULERS ---
      {
        "Title": "The Strategic Peace of Rani Abakka Chowta",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Queen of Ullal who defeated the Portuguese for 40 years.",
        "Description": "Rani Abakka was the last Tuluva Queen of Ullal. She was a master of diplomacy and naval warfare. For four decades, she repelled Portuguese attacks on her port. She utilized a diverse army of Hindus and Muslims, including the famous 'Mapilla' archers, proving that communal unity was the key to defending India's coastline.",
        "Modern Edge": "Unity is the best defense. A diverse team (Hindus and Muslims) united by a common cause is harder to crack than a homogenous one."
      },
      {
        "Title": "Zamorin of Calicut and the Kunjali Marakkars",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The legendary naval admirals of the Malabar coast.",
        "Description": "The Kunjali Marakkars were the hereditary admirals of the Hindu Zamorin of Calicut. They fought a relentless 100-year naval war against the Portuguese. They were the first to use heavy cannon on small, fast ships, successfully challenging the European monopoly over the Indian Ocean for generations.",
        "Modern Edge": "Delegate to experts. Trust the hereditary specialists (Marakkars) to run your defense; don't micromanage domains you don't understand."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Saragarhi",
        "Category": "Battles",
        "Region": "North",
        "Summary": "21 Sikh soldiers against 10,000 Afghan tribesmen.",
        "Description": "In 1897, 21 soldiers of the 36th Sikhs defended a signaling post at Saragarhi. Facing an onslaught of 10,000 Afghans, they refused to surrender or retreat. They fought for over seven hours, killing hundreds of the enemy, until the very last man fell. Their sacrifice gave the main fort enough time to prepare for the defense.",
        "Modern Edge": "Buy time with your life. Sometimes the role of a small team is to hold the line at all costs so the main organization can survive."
      },
      {
        "Title": "The Battle of Kamrup",
        "Category": "Battles",
        "Region": "East",
        "Summary": "The total annihilation of the Bakhtiyar Khalji's army.",
        "Description": "After destroying Nalanda, Bakhtiyar Khalji attempted to invade Tibet through Assam. The King of Kamrup, Prithu, used a 'scorched earth' policy, burning all crops and bridges. The invaders were trapped without food. Of the 10,000 horsemen who entered Assam, only a few dozen managed to return alive, ending the threat to the East.",
        "Modern Edge": "Scorched earth. If you can't fight them head-on, destroy the resources they need to survive until they are forced to retreat."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Sacrifice of Baba Deep Singh",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The warrior who fought with his head in his hand.",
        "Description": "At the age of 75, Baba Deep Singh vowed to liberate the Golden Temple from Afghan desecrators. During the battle, legend and historical accounts state that even after being fatally wounded in the neck, he supported his head with one hand and continued to wield his sword with the other, reaching the temple complex before finally breathing his last.",
        "Modern Edge": "Commitment beyond death. A vow is a binding contract with your soul; keep moving toward the goal even if you are 'dead' on your feet."
      },
      {
        "Title": "The Nameless Architects of the Tanjore Shadow",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The mystery of the shadow-less Brihadeeswarar Temple.",
        "Description": "The Chola architects designed the main tower (Vimana) of the Tanjore temple so perfectly that at noon during certain times of the year, the shadow of the massive structure never falls on the ground, but only on its own base. This required advanced knowledge of solar angles and architectural geometry that remains a mystery to this day.",
        "Modern Edge": "Eliminate the shadow. Design your structures so perfectly that they cast no doubt (shadow) on your competence."
      },

      // --- FREEDOM FIGHTERS ---
      {
        "Title": "The Uprising of the Poligars",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "Puli Thevar: The first to refuse tax to the British.",
        "Description": "In 1755, decades before the 1857 mutiny, Puli Thevar of Nellai refused to pay taxes to the British East India Company. He formed a coalition of local chieftains and defeated the British and Nawab forces in several encounters, marking the earliest organized armed resistance to colonial rule in India.",
        "Modern Edge": "Be the first to say No. The first person to refuse an unjust tax sets the precedent for the entire revolution."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "The Vastu Shastra of Maya Danava",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The ancient science of architecture and town planning.",
        "Description": "Maya Danava is the legendary author of the 'Mayamata'. This text describes the mathematical principles of town planning, temple architecture, and sculpture. It categorized soil types, directions, and wind flow to ensure that buildings were not just structures, but living spaces that resonated with the environment's energy.",
        "Modern Edge": "Design for energy. Architecture isn't just shelter; it's about aligning with the flow of energy (Vastu) to maximize productivity."
      },
      {
        "Title": "Nagarjuna: The Master of the Middle Way",
        "Category": "Scholars",
        "Region": "South",
        "Summary": "The philosopher who pioneered the concept of 'Shunyata' (Emptiness).",
        "Description": "Born in the Satavahana Empire, Nagarjuna is one of the most important Buddhist philosophers after the Buddha himself. His 'Mulamadhyamakakarika' used rigorous logic to prove that all things are interdependent. His philosophy later influenced the development of modern quantum logic and systemic thinking.",
        "Modern Edge": "Embrace the middle path. Extreme positions are fragile; the truth (and stability) is found in the balance between opposing forces."
      },
      {
        "Title": "The Metallurgy of the Dhar Iron Pillar",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "The massive medieval iron pillar of the Paramara Dynasty.",
        "Description": "While the Delhi pillar is famous, the Iron Pillar of Dhar (Mandu) was once the largest of its kind in the world, standing over 13 meters tall. Created during the reign of Raja Bhoja, it showcased the Paramara dynasty's mastery over forge-welding massive pieces of iron, a feat that European smiths could not replicate for centuries.",
        "Modern Edge": "Scale your mastery. It's one thing to make a small quality product; it's another to forge a 13-meter pillar that maintains that quality."
      },

      // --- RULERS ---
      {
        "Title": "Rani Rudrama Devi: The King-Queen",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Kakatiya ruler who dressed as a man to save her kingdom.",
        "Description": "One of the few female monarchs in Indian history, Rudrama Devi was formally designated as a son through a ritual. She led her armies into battle, completed the massive Warangal Fort, and repelled the Yadavas and Cholas. Marco Polo, the Italian traveler, visited her kingdom and praised her as a lady of high intelligence and justice.",
        "Modern Edge": "Gender is a construct. If the role requires a 'King,' be the King, regardless of your gender. Performance silences critics."
      },
      {
        "Title": "Prataparudra Deva and the Gajapati Might",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The Lords of the Elephants who ruled the Eastern Coast.",
        "Description": "The Gajapati Kings of Odisha were known as 'Lords of the Elephants' because of their massive elephantry. Prataparudra Deva defended the sovereignty of Odisha against the combined pressures of the Vijayanagara Empire and the Sultanates, while also being a great patron of Sri Chaitanya Mahaprabhu and the arts.",
        "Modern Edge": "Patronage pays. Supporting the arts and spirituality (Chaitanya) creates a cultural glue that holds the kingdom together during hard times."
      },
      {
        "Title": "Vikramaditya VI: The Chalukya-Vikrama Era",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The king who started his own calendar.",
        "Description": "A powerful ruler of the Western Chalukyas, Vikramaditya VI abolished the old Shaka era and started the 'Vikrama-Chalukya era'. His reign was a golden age for Kannada and Sanskrit literature. He was known for his massive temple-building projects and for maintaining a peaceful empire for over 50 years.",
        "Modern Edge": "Reset the calendar. Don't just follow someone else's timeline; start your own 'Era' to mark a new beginning for your organization."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Venni",
        "Category": "Battles",
        "Region": "South",
        "Summary": "Karikala Chola's decisive victory over a grand coalition.",
        "Description": "In this ancient battle, the young Karikala Chola faced a massive coalition of the Cheras, Pandyas, and eleven minor chieftains. Despite being outnumbered, his strategic use of his infantry and his personal valor led to a total victory, establishing the Cholas as the dominant power of the Sangam era.",
        "Modern Edge": "Focus beats numbers. A young, focused leader can defeat a coalition of veterans if they strike with precision and confidence."
      },
      {
        "Title": "The Battle of Bahraich",
        "Category": "Battles",
        "Region": "North",
        "Summary": "Raja Suheldev’s stand against the Ghaznavid invasion.",
        "Description": "When Salar Masud, nephew of Mahmud of Ghazni, invaded with a massive army, Raja Suheldev of Shravasti united the local chieftains. At the Battle of Bahraich in 1033 CE, the invading army was completely annihilated. This victory was so decisive that no major foreign invasion from the North-West occurred for the next 150 years.",
        "Modern Edge": "Unite the tribes. A coalition of local leaders fighting for their shared home is more powerful than a mercenary imperial army."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Sacrifice of 363 Bishnois",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "Amrita Devi and the first environmental protest.",
        "Description": "In 1730, when the King of Jodhpur sent soldiers to cut Khejri trees for a new palace, Amrita Devi Bishnoi hugged the trees to protect them. She said, 'A chopped head is cheaper than a felled tree.' She and 362 others sacrificed their lives, eventually forcing the King to pass a permanent decree protecting the trees and wildlife.",
        "Modern Edge": "Values over valuation. Some things (like nature) are priceless; be willing to put your body on the line to protect your core values."
      },
      {
        "Title": "The Architects of the Modhera Sun Temple",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "Designing a temple where the sun kisses the deity.",
        "Description": "Built by the Solanki dynasty, the Modhera Sun Temple is a mathematical marvel. Its design ensures that on the equinoxes, the first rays of the rising sun fall directly on the diamond-studded crown of the Sun God. The intricate 'Kund' (stepped tank) in front is a masterpiece of geometry and water conservation.",
        "Modern Edge": "Align with the cosmos. Build your brand so that the 'light' shines on it at the perfect moment; timing and geometry are everything."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Varahamihira: The Ancient Meteorologist",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "Predicting rainfall and earthquakes in the 6th century.",
        "Description": "Varahamihira was a polymath in the court of Ujjain. In his work 'Brihat Samhita', he outlined the 'Science of Clouds', explaining how to predict rainfall based on the shape of clouds and the behavior of animals. He was also the first to propose that earthquakes were caused by internal shifts in the earth’s elements, long before modern seismology was born.",
        "Modern Edge": "Read the signs. The environment gives you early warning signals (clouds, animals); a wise leader pays attention to these subtle cues."
      },
      {
        "Title": "The Architecture of the Vakatakas",
        "Category": "Scholars",
        "Region": "Central",
        "Summary": "The dynasty that patronized the Ajanta Caves.",
        "Description": "The Vakatakas were the contemporaries of the Guptas. Under Queen Prabhavatigupta (daughter of Chandragupta II), they created the world-famous rock-cut Buddhist viharas and chaityas at Ajanta. Their scholars preserved the techniques of 'fresco' painting, using natural minerals to create colors that remain vibrant even after 1,500 years.",
        "Modern Edge": "Color that lasts. Invest in 'pigments' (values/culture) that don't fade with time, creating a legacy that remains vibrant for centuries."
      },
      {
        "Title": "Dhanvantari: The God of Ayurveda",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The legendary surgeon of the early Vedic era.",
        "Description": "Dhanvantari is regarded as the father of Indian medicine. Historically, his lineage of scholars perfected the use of salt as an antiseptic and leeches for blood purification. He taught that surgery should only be performed when the body’s internal 'Doshic' balance could not be restored through herbs and diet.",
        "Modern Edge": "Prevention is better than cure. The best fix is the one you don't have to make; maintain the system's balance to avoid the need for 'surgery'."
      },

      // --- RULERS ---
      {
        "Title": "Suhungmung: The Architect of Greater Assam",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The Ahom king who modernized the administration.",
        "Description": "Suhungmung was one of the most important Ahom kings. He was the first to adopt a Hindu title (Swarganarayana) and expanded the kingdom to include various local tribes, creating a unified Assamese identity. He introduced the use of firearms in the Ahom army, which later became the backbone of their resistance against the Mughals.",
        "Modern Edge": "Assimilate to expand. Don't conquer and suppress; conquer and include. Adopting local titles and customs creates a unified identity."
      },
      {
        "Title": "The Jaintia Kings and the Living Root Bridges",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "Engineering with nature in the hills of Meghalaya.",
        "Description": "The Jaintia and Khasi kings encouraged a unique form of bio-engineering. Instead of building stone bridges that would wash away in heavy rain, they guided the roots of Ficus trees across rivers. Over decades, these grew into 'Living Root Bridges' that grow stronger with age and can hold the weight of 50 people at once.",
        "Modern Edge": "Grow your infrastructure. Don't just build dead structures; guide living systems (roots) to solve problems over generations."
      },
      {
        "Title": "Lakshmana Sena: The Last Great Sena King",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "A patron of literature and the defender of Bengal.",
        "Description": "Lakshmana Sena was a great conqueror who expanded the Sena Empire into Bihar and Odisha. He was a poet himself and his court was graced by Jayadeva, the author of 'Gita Govinda'. Despite his old age, he maintained a high standard of justice and cultural patronage that marked the final golden era of ancient Bengal.",
        "Modern Edge": "Culture is the final defense. Even in the twilight of your reign, maintaining high standards of justice and art preserves your dignity."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Koppam",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The Chola victory led by a king crowned on the field.",
        "Description": "During the war with the Chalukyas, the Chola King Rajadhiraja was killed on his elephant. His brother, Rajendra II, didn't panic. He was crowned king right there on the battlefield amidst the chaos. He rallied the troops and turned a devastating defeat into a total victory, showing incredible grit under fire.",
        "Modern Edge": "Crisis succession. When the leader falls, the next in line must step up immediately—on the battlefield—to prevent panic and turn the tide."
      },
      {
        "Title": "The Siege of Gingee Fort",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The 'Troy of the East' that stood for 8 years.",
        "Description": "Gingee Fort in Tamil Nadu was so well-fortified that the Mughal army had to siege it for eight years to capture it from the Marathas. Its unique three-hill structure and sophisticated water supply system allowed a small garrison to defy an empire, proving the superiority of Indian hill-fort engineering.",
        "Modern Edge": "Design for the long haul. Build your defenses (financial runway) to withstand an 8-year siege, not just a short skirmish."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Nameless Smiths of the Damascus Blade",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Gujarati and Rajasthani smiths of the Sirohi sword.",
        "Description": "The Sirohi region was world-famous for its swords. The local smiths (Lohars) perfected a specific curvature and tempering process that made the Sirohi sword the favorite of Rajput warriors. These swords were exported globally, but the names of the master craftsmen who perfected the carbon-tempering remain lost to history.",
        "Modern Edge": "Let the product speak. You don't need your name on the blade if the quality is so legendary that the world seeks you out."
      },
      {
        "Title": "Birsa Munda's 'Ulgulan' Rebellion",
        "Category": "Freedom Fighters",
        "Region": "Central",
        "Summary": "The young tribal leader who became 'Dharati Aba'.",
        "Description": "Birsa Munda organized the Munda tribe against the British and the Zamindari system. He worked to restore the 'Khuntkatti' system (joint land ownership). He taught his people to give up superstitions and return to their roots, creating a massive socio-religious movement that shook the British administration in the Chhotanagpur plateau.",
        "Modern Edge": "Disruption comes from the edge. Never underestimate the power of a grassroots movement organized around a shared identity and rights."
      },
      // --- RULERS ---
      {
        "Title": "Rana Sanga: The Warrior of Eighty Scars",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Rajput king who fought despite losing an eye, an arm, and a leg.",
        "Description": "Maharana Sangram Singh, or Rana Sanga, was the head of the Rajput confederacy. He was a veteran of countless battles and bore 80 scars from swords and lances on his body. He was the last ruler who successfully united the various Rajput clans under one banner to defend the heartland against foreign invasions from the North.",
        "Modern Edge": "Scars are credentials. A leader who bears the marks of battle commands more respect than one who leads from a safe distance."
      },
      {
        "Title": "The Strategic Foresight of Shahu Maharaj",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The Chhatrapati who empowered the Peshwas and expanded the Maratha Empire.",
        "Description": "Chhatrapati Shahu, grandson of Shivaji Maharaj, was instrumental in transforming the Maratha state into a pan-Indian empire. He had the vision to recognize the talent of Balaji Vishwanath and Bajirao I, delegating authority to capable leaders while maintaining the central pillar of the Maratha identity. Under his reign, the Maratha flag reached from Cuttack to Attock.",
        "Modern Edge": "Empower the CEO. A chairman (Chhatrapati) knows that his job is to find the best CEO (Peshwa) and let them run the operations."
      },
      {
        "Title": "Rao Jodha and the Creation of Mehrangarh",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The founder of Jodhpur and the invincible 'Citadel of the Sun'.",
        "Description": "Rao Jodha moved his capital to a 400-foot high cliff to ensure better defense. He built the Mehrangarh Fort, an engineering marvel with walls so thick that they remained unscathed by heavy cannon fire. His strategic shift ensured the survival and prosperity of the Rathore clan for centuries.",
        "Modern Edge": "Move to higher ground. If your current location is vulnerable, have the courage to relocate your capital to a 'cliff' where you are secure."
      },

      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "The Stepwells of Rajasthan: Geometric Engineering",
        "Category": "Ancient Science",
        "Region": "West",
        "Summary": "Chand Baori and the science of desert water conservation.",
        "Description": "In the arid deserts of Rajasthan, ancient engineers built stepwells (Baoris) like Chand Baori. With 3,500 narrow steps over 13 stories, these structures were designed to reach the groundwater while keeping the water cool through a unique microclimate created by the geometric architecture. It is a masterclass in combining aesthetics with survival science.",
        "Modern Edge": "Aesthetics meets utility. Don't just build a utility; build a masterpiece that solves the problem (water) with beauty and grace."
      },
      {
        "Title": "Savithribai Phule: The Pioneer of Education",
        "Category": "Scholars",
        "Region": "West",
        "Summary": "The first female teacher of India who fought social stigma.",
        "Description": "Savithribai, along with her husband Jyotirao Phule, opened the first school for girls in Pune in 1848. Despite people throwing mud and stones at her while she walked to school, she carried a second sari and continued teaching. She broke the monopoly of knowledge and paved the way for modern Indian women's education.",
        "Modern Edge": "Carry an extra sari. When you challenge social norms, expect mud to be thrown. Be prepared, clean up, and keep doing the work."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Palkhed",
        "Category": "Battles",
        "Region": "West",
        "Summary": "Bajirao I's masterclass in mobile warfare.",
        "Description": "In 1728, Peshwa Bajirao I faced the Nizam of Hyderabad. Instead of a direct clash, Bajirao used lightning-fast cavalry movements to cut off the Nizam's supplies and artillery. He forced the superior Mughal-style army into a waterless region, compelling the Nizam to surrender without a major bloodshed. It is studied globally as a masterpiece of strategic maneuvering.",
        "Modern Edge": "Outmaneuver, don't outmuscle. If you are lighter and faster, use that to run circles around a heavy, slow opponent."
      },
      {
        "Title": "The Battle of Dewair",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The 'Marathon of Mewar' where Maharana Pratap reclaimed his land.",
        "Description": "Often overshadowed by Haldighati, the Battle of Dewair in 1582 was a decisive victory for Maharana Pratap. Using the guerrilla tactics he perfected in the Aravallis, he decimated the Mughal garrisons. This battle forced the Mughals to abandon their outposts in Mewar, proving that Pratap's persistence had finally turned the tide.",
        "Modern Edge": "The long game wins. You can lose the capital and live in the woods for years, but if you keep striking back, you will eventually reclaim your home."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Courage of Rani Hadi",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Queen who sacrificed her life to send her husband to war.",
        "Description": "When the newlywed Rao Ratan Singh hesitated to go to battle because of his love for his wife, Rani Hadi. To remove his distraction and remind him of his duty to the land, she cut off her own head and sent it to him as a 'souvenir.' Heartbroken but inspired, the Rao fought like a lion, securing the victory for his people.",
        "Modern Edge": "Remove the distraction. If your team is hesitating because of attachment to you, cut the cord (metaphorically) to force them to focus on the mission."
      },
      {
        "Title": "Durgadas Rathore: The Unconquerable",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The man who protected the heir of Marwar for 30 years.",
        "Description": "Durgadas Rathore fought a relentless guerrilla war against the Mughal Emperor Aurangzeb to protect the infant Prince Ajit Singh. For three decades, he lived in the deserts and forests, refusing bribes and facing every hardship to ensure the Rathore bloodline survived. He is remembered as the 'Ulysses of Rajputana'.",
        "Modern Edge": "Be the guardian. Sometimes your job isn't to be the King, but to keep the King alive through the wilderness until he is ready to rule."
      },
      {
        "Title": "The Martyrs of the Mulshi Satyagraha",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The world's first anti-dam struggle led by Senapati Bapat.",
        "Description": "In the 1920s, the farmers of Mulshi, Maharashtra, fought against the forced acquisition of their land for a hydroelectric project. Led by Pandurang Mahadev 'Senapati' Bapat, this was one of the earliest environmental and land-rights movements in India, blending the spirit of Swaraj with the rights of the tiller.",
        "Modern Edge": "Land rights are human rights. Progress that displaces the poor without consent is not development; it's theft."
      },
      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Raja Bhoja: The Polymath King",
        "Category": "Scholars",
        "Region": "Central",
        "Summary": "The ruler who wrote 84 books on science, arts, and engineering.",
        "Description": "Raja Bhoja of the Paramara dynasty was a true 'Vidyapati'. His work 'Samarangana Sutradhara' is a detailed treatise on civil engineering, town planning, and even mechanical devices (Yantras). He established the Bhojshala, a university for Sanskrit studies, and built the Bhojeshwar Temple, which houses one of the largest monolithic Shivlingas in India.",
        "Modern Edge": "The Scholar-Builder. A leader should be able to write a treatise on engineering and then go out and build the temple. Theory and practice must meet."
      },
      {
        "Title": "Kamalakara and the Geometry of the Sphere",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The 17th-century scholar who bridged Indian and Islamic astronomy.",
        "Description": "Kamalakara wrote the 'Siddhanta Tattva Viveka', where he introduced trigonometric concepts to calculate planetary positions with incredible precision. He lived in Varanasi and was one of the few scholars who successfully integrated traditional Indian mathematical logic with the astronomical findings of the Persian and Arabic worlds.",
        "Modern Edge": "Bridge the gap. Be the interface between two distinct knowledge systems (Indian and Islamic) to create a superior synthesis."
      },

      // --- RULERS ---
      {
        "Title": "The Chandelas and the Fortress of Kalinjar",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The kings who built the world-famous Khajuraho temples.",
        "Description": "The Chandela Rajputs were masters of architecture and defense. While they are world-famous for the intricate temples of Khajuraho, their true strength lay in the Kalinjar Fort. This fort was considered 'Kala-jar' (one who has conquered time) because of its impregnable walls and strategic location, surviving dozens of sieges over 500 years.",
        "Modern Edge": "Build a 'Kala-jar'. Create a product or fortress that conquers time itself; durability is the ultimate proof of quality."
      },
      {
        "Title": "Nana Patil and the Patri Sarkar",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The parallel government that challenged British rule in Maharashtra.",
        "Description": "In 1943, Krantisimha Nana Patil established a parallel government (Prati Sarkar) in Satara. They set up their own courts, shadow administration, and supply lines, effectively ending British control in the region for nearly two years. It was the most successful and longest-running parallel government during the Quit India movement.",
        "Modern Edge": "Parallel governance. If the central authority fails, don't just complain; set up a parallel system that works better and renders the old one obsolete."
      },
      {
        "Title": "The Maritime Wisdom of the Kolis",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The traditional seafaring community that protected the Western coast.",
        "Description": "The Koli community of Maharashtra and Gujarat were the backbone of India's maritime strength. They possessed an ancestral understanding of tides, currents, and monsoon winds. They served as the primary sailors for the Maratha Navy, using their indigenous boats (Galivats and Sangameshwari) to outmaneuver the heavy warships of the European powers.",
        "Modern Edge": "Indigenous knowledge is IP. The local fisherman knows the tides better than the imperial admiral; listen to the person on the deck."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Rakshas Bhuvan",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The Maratha victory that checked the Nizam's expansion.",
        "Description": "In 1763, Madhavrao Peshwa, a young but brilliant leader, faced the Nizam of Hyderabad. Despite the Maratha army being in a state of recovery after Panipat, Madhavrao’s strategic brilliance on the banks of the Godavari river led to a decisive victory, proving that the Maratha spirit was still the dominant force in the Deccan.",
        "Modern Edge": "Youth is an asset. Don't dismiss a young leader; their energy and fresh perspective can turn a stalemate into a victory."
      },
      {
        "Title": "The Battle of Kumbher",
        "Category": "Battles",
        "Region": "North",
        "Summary": "The Jat resistance against the Maratha-Mughal siege.",
        "Description": "In 1754, the Jat King Suraj Mal defended the Kumbher Fort against a massive combined force. The Jats used their knowledge of the local terrain and fortifications to withstand a four-month siege. This battle eventually led to a peace treaty, establishing the Jats as a major sovereign power in North India.",
        "Modern Edge": "Home turf advantage. A well-prepared defense on your own land can bleed a much larger attacking force until they give up."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The 63 Martyrs of the Vedaranyam Salt March",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The Southern response to the Dandi March.",
        "Description": "Led by C. Rajagopalachari in 1930, hundreds marched from Trichy to Vedaranyam to break the salt law. Despite brutal police crackdowns and the British trying to hide all food and water along the route, local villagers risked their lives to feed the marchers, proving that the struggle for freedom was a truly pan-Indian heartbeat.",
        "Modern Edge": "Supply lines of love. A movement succeeds when the common people risk their safety to feed the marchers; build that level of community support."
      },
      {
        "Title": "The Architects of the Hampi Aqueducts",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "Bringing water to a city of a million people in a rocky desert.",
        "Description": "The engineers of the Vijayanagara Empire built a 40-km long system of stone aqueducts and canals. They used gravity and siphon logic to move water across uneven terrain, ensuring that even during summer, the city's tanks and temple ponds were full. Much of this system still functions today, centuries after the empire fell.",
        "Modern Edge": "Flow with gravity. Good engineering uses natural forces (gravity) to do the work, rather than fighting against them."
      },
      {
        "Title": "Usha Mehta and the Secret Congress Radio",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The woman who kept the voice of freedom alive underground.",
        "Description": "During the Quit India Movement, when the British banned all news of the struggle, 22-year-old Usha Mehta set up a secret radio station. She moved the transmitter every day to avoid detection, broadcasting news of protests and speeches across India for months until she was finally captured and imprisoned.",
        "Modern Edge": "Keep the signal alive. When the official channels are blocked, go underground and keep broadcasting the truth to keep hope alive."
      },
      // --- RULERS ---
      {
        "Title": "The Gond Queen Durgavati",
        "Category": "Rulers",
        "Region": "Central",
        "Summary": "The defender of Garha Katanga against the Mughal expansion.",
        "Description": "Rani Durgavati was a warrior queen who refused to surrender her kingdom to Akbar’s generals. She was a master of defensive warfare, using the hilly terrain of the Satpuras to trap larger armies. When she was finally cornered and wounded, she chose to end her own life with a dagger rather than face the dishonor of being a prisoner.",
        "Modern Edge": "Exit on your own terms. If defeat is inevitable, control the narrative of your end rather than letting the competition dismantle you."
      },
      {
        "Title": "Raja Martanda Varma and the Battle of Colachel",
        "Category": "Battles",
        "Region": "South",
        "Summary": "The first time an Asian power defeated a European naval force.",
        "Description": "In 1741, the Dutch East India Company attempted to invade Travancore. Martanda Varma's forces utilized a superior understanding of the coastline to trap the Dutch fleet. This victory was so total that it permanently ended Dutch colonial ambitions in the Indian subcontinent.",
        "Modern Edge": "Disrupt the supply chain. You can defeat a technologically superior global player by cutting off their logistics and isolating them."
      },

      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "The Iron-Smelting Tribes of Agaria",
        "Category": "Ancient Science",
        "Region": "Central",
        "Summary": "The traditional keepers of India's metallurgical secrets.",
        "Description": "The Agaria tribe in Central India practiced a form of small-scale iron smelting that produced rust-resistant iron for centuries. They understood the specific chemical properties of different clays used in their kilns, a tribal science that eventually contributed to the development of modern high-grade steel.",
        "Modern Edge": "Niche mastery. You don't need to be a giant steel plant; mastering a specific, high-quality niche (rust-resistant iron) keeps you relevant."
      },
      {
        "Title": "Acharya Lalla and the Gnomon",
        "Category": "Ancient Science",
        "Region": "North",
        "Summary": "The astronomer who perfected the measurement of time.",
        "Description": "In the 8th century, Lalla wrote the 'Shishyadhividdhida Tantra'. He perfected the use of the 'Gnomon' (Shanku)—a vertical rod used to track the sun's shadow. This allowed for the precise calculation of local latitude and the exact timing of the equinoxes, crucial for both agriculture and sea navigation.",
        "Modern Edge": "Simple tools, deep insights. You don't need a supercomputer to understand the universe; a simple stick (Gnomon) and a sharp mind can measure the heavens."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Bravehearts of the Vaikom Satyagraha",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The peaceful struggle for the right to walk on public roads.",
        "Description": "In 1924, people of all castes stood together in Vaikom, Kerala, to demand that the roads around the local temple be opened to everyone. Despite being arrested and standing in waist-deep water during the monsoon for months, they remained non-violent, forcing a change in the social fabric of India.",
        "Modern Edge": "Stand in the water. Passive resistance requires active suffering; standing in the flood for your rights makes your cause impossible to ignore."
      },
      {
        "Title": "Kanaklata Barua: The Girl with the Flag",
        "Category": "Freedom Fighters",
        "Region": "East",
        "Summary": "The 17-year-old martyr of the Quit India movement.",
        "Description": "During the 1942 movement in Assam, Kanaklata led a group of protesters to hoist the national flag at a police station. When the British police threatened to fire, she stepped forward, refusing to let the flag fall. She was shot and died holding the flag, becoming a symbol of youth defiance in the East.",
        "Modern Edge": "Fearless youth. When the youth are willing to die for the flag, the regime's days are numbered. Harness that fearless energy."
      },

      // --- SCHOLARS ---
      {
        "Title": "Bhartrihari: The Grammarian Philosopher",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The sage who linked language to consciousness.",
        "Description": "Bhartrihari's 'Vakyapadiya' explored the idea that thought and language are inseparable. He proposed the 'Sphota' theory—that meaning is grasped in a sudden flash of insight. His work remains a foundational text in both linguistics and the philosophy of the mind.",
        "Modern Edge": "Language is consciousness. The words you use shape the reality you perceive; master your vocabulary to master your strategy."
      },

      // --- FINAL ENTRIES TO HIT 200 ---
      {
        "Title": "The Kachari Kings and the Monolithic Pillars",
        "Category": "Rulers",
        "Region": "East",
        "Summary": "The unique mushroom-shaped architecture of Dimapur.",
        "Description": "The Kachari dynasty in Nagaland and Assam created massive monolithic sandstone pillars. These structures were not just ritualistic but served as markers of the kingdom's engineering capability. They developed unique stone-joining techniques that allowed these pillars to withstand the high seismic activity of the North-East.",
        "Modern Edge": "Seismic stability. Build your organization to withstand 'earthquakes' (market shocks) by using flexible, interlocking structures."
      },
      {
        "Title": "Velu Nachiyar: The First Queen to use a Suicide Bomber",
        "Category": "Freedom Fighters",
        "Region": "South",
        "Summary": "The Queen of Sivaganga who outsmarted the British.",
        "Description": "Rani Velu Nachiyar was the first Indian queen to fight the British. She discovered where the British stored their ammunition and organized a 'suicide attack' where her loyal commander, Kuyili, doused herself in ghee, set herself on fire, and jumped into the armory, destroying the enemy's gunpowder supply.",
        "Modern Edge": "Innovate in desperation. When outgunned, invent new tactics (like the human bomb) that the enemy's rulebook has no defense against."
      },
      // --- RULERS ---
      {
        "Title": "The Maritime Strength of the Marwaris",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The inland kings who dominated the Eastern trade routes.",
        "Description": "While based in the deserts of Rajasthan, the Marwar merchant-kings and chieftains established 'Kothis' (trading posts) across the world. They financed the navies of other Indian kingdoms and controlled the movement of silk and spices, proving that economic power is a form of sovereignty that can rule across oceans even from a desert.",
        "Modern Edge": "Capital has no borders. You can rule the seas from the desert if you control the finance. Money is the ultimate long-range weapon."
      },

      // --- ANCIENT SCIENCE & SCHOLARS ---
      {
        "Title": "Nilakantha Somayaji and the Planetary Model",
        "Category": "Ancient Science",
        "Region": "South",
        "Summary": "The 15th-century astronomer who refined the solar system model.",
        "Description": "A giant of the Kerala School, Nilakantha wrote the 'Tantrasamgraha'. He proposed a partially heliocentric model where the planets orbit the Sun, which in turn orbits the Earth. This was a significant mathematical advancement that preceded the Tychonic system of Europe by nearly a century.",
        "Modern Edge": "Refine the model. Don't be afraid to update the established model (geocentrism) with new data; continuous refinement leads to truth."
      },

      // --- BATTLES ---
      {
        "Title": "The Battle of Bagasra",
        "Category": "Battles",
        "Region": "West",
        "Summary": "The resistance of the Kathi Kshatriyas against expansionism.",
        "Description": "In the heart of Saurashtra, the Kathi chieftains fought a series of defensive battles to protect their nomadic heritage and lands. They utilized the 'Dharo' (local militia) system, where every household contributed a warrior, making it impossible for larger imperial forces to maintain a permanent occupation of their rugged terrain.",
        "Modern Edge": "Every home a fortress. Distributed defense (militia) is harder to conquer than a single standing army; make every user a defender of your brand."
      },

      // --- FORGOTTEN HEROES ---
      {
        "Title": "The Nameless Engineers of the Kallanai Dam",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The world's oldest functional water-regulator structure.",
        "Description": "Built by Karikala Chola in the 2nd century CE, the Grand Anicut (Kallanai) was constructed using unhewn stones laid across the Kaveri river. The engineers developed a 'scouring' method to prevent the dam from silting up. It is so perfectly built that it still diverts water to millions of acres of farmland today, 2,000 years later.",
        "Modern Edge": "Functional longevity. Build things that work for 2,000 years. Utility is the ultimate legacy."
      },
      {
        "Title": "Chanakya’s Vow and the Fall of Dhanananda",
        "Category": "Scholars",
        "Region": "North",
        "Summary": "The scholar who toppled an empire with a single vow.",
        "Description": "Dhanananda, the last Nanda king, publicly insulted the scholar Chanakya (Kautilya). In response, Chanakya untied his shikha (hair-lock), vowing not to tie it until the Nanda dynasty was uprooted. He found a young boy named Chandragupta, trained him in statecraft and warfare, and together they dismantled the massive Nanda army to establish the Mauryan Empire.",
        "Modern Edge": "Channel your anger. Don't just get mad; get strategic. Use your humiliation as fuel to build a new empire that replaces the old one."
      },
      {
        "Title": "Chandragupta Maurya: The Liberator",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The first Emperor to unite the Indian subcontinent.",
        "Description": "Chandragupta Maurya was the first ruler to unify disparate kingdoms into one empire. He defeated the Greek general Seleucus Nicator, securing the borders of North-West India. Later in life, he famously abdicated his throne to become a Jain monk, passing the empire to his son Bindusara and seeking spiritual peace at Shravanabelagola.",
        "Modern Edge": "Know when to walk away. Building an empire requires aggression; keeping your soul requires knowing when to hand it over and seek peace."
      },
      {
        "Title": "Peshwa Baji Rao I: The Unbeaten Cavalry",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The general who never lost a battle.",
        "Description": "Baji Rao I expanded the Maratha Empire into North India, moving the administrative seat to Pune. He is legendary for the Battle of Palkhed, where he outmaneuvered the Nizam of Hyderabad using only high-speed light cavalry. In 20 years of continuous warfare, he remained undefeated, establishing Maratha supremacy across the Deccan.",
        "Modern Edge": "Speed kills. In a market of giants, be the cavalry that strikes and vanishes before the enemy can load their cannons."
      },
      {
        "Title": "Ashoka and the Turn to Dharma",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The conqueror who realized that true victory is through peace.",
        "Description": "After the bloody Kalinga War, Emperor Ashoka was struck by remorse. He abandoned 'Digvijaya' (conquest by force) for 'Dharmavijaya' (conquest by righteousness). He erected pillars across the subcontinent inscribed with edicts on non-violence, medical care for animals, and respect for all faiths, spreading the message of Indian ethics as far as Greece and Egypt.",
        "Modern Edge": "Pivot to purpose. You can conquer the world with force, but you can only rule it with Dharma. The ultimate pivot is from profit to purpose."
      },
      {
        "Title": "Maharana Kumbha: The Architect King",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The invincible ruler of Mewar who built 32 forts.",
        "Description": "Rana Kumbha was a polymath who never lost a battle. He built the massive Kumbhalgarh Fort, which has the second-longest wall in the world after the Great Wall of China. He was also a scholar of music and grammar, proving that a king's strength lies in both his fortress and his library.",
        "Modern Edge": "Fortify and educate. A secure kingdom needs both thick walls (defense) and high culture (books). Neglect neither."
      },
      {
        "Title": "Prithviraj Chauhan: The Last Sun of Delhi",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The legendary archer-king of the Chahamana dynasty.",
        "Description": "Ruling from Ajmer and Delhi, Prithviraj was famous for his 'Shabd-Bhedi' (aiming by sound) skills. He defeated the invader Muhammad Ghori in the First Battle of Tarain and released him out of Rajput chivalry—a decision that changed Indian history. He remains the ultimate symbol of Rajput honor and gallantry.",
        "Modern Edge": "Chivalry has a cost. Being noble is a virtue, but not when it endangers the state. Know the difference between personal honor and political survival."
      },
      {
        "Title": "Chhatrapati Sambhaji: The Unyielding Martyr",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The second Chhatrapati who fought the Mughals for nine years.",
        "Description": "The son of Shivaji Maharaj, Sambhaji faced the full might of Aurangzeb's 500,000-strong army. He fought 120 battles and lost none. When captured, he was offered his life if he converted, but he refused to betray his faith or his motherland, facing a brutal end with a smile that inspired the entire Maratha nation to continue the fight.",
        "Modern Edge": "Defiance is a legacy. Sometimes your death is more powerful than your life. Dying without breaking inspires a resistance that lives forever."
      },
      {
        "Title": "Chhatrapati Rajaram and the War of 27 Years",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who ruled from the moving saddle.",
        "Description": "After Sambhaji, his brother Rajaram led the Marathas. He realized they couldn't fight a conventional war, so he moved the capital to Gingee in the South. He transformed the empire into a decentralized resistance, forcing the Mughals into a 27-year-long war of attrition that eventually broke the Mughal treasury.",
        "Modern Edge": "Decentralize the resistance. When the capital falls, move the headquarters and let every commander become a king. Distributed leadership survives."
      },
      {
        "Title": "Tarabai: The Queen Who Led the Resurgence",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The widow queen who defeated Aurangzeb's pride.",
        "Description": "Rani Tarabai, the widow of Rajaram, took command of the Maratha forces herself. She organized the counter-offensive that drove the Mughals out of the Deccan. It was under her leadership that the Marathas moved from defense to offense, crossing the Narmada river to take the fight to North India.",
        "Modern Edge": "The Queen's Gambit. When the men are gone, the woman takes the lead. Crisis removes gender barriers; competence is the only currency."
      },
      {
        "Title": "Maharana Pratap: The Unbending Pillar of Mewar",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who chose the forest over a puppet throne.",
        "Description": "Maharana Pratap stands as the ultimate symbol of Rajput resistance. In 1576, at the Battle of Haldighati, he faced a Mughal army that vastly outnumbered his own. Though he had to retreat, he never surrendered. For the next 20 years, he lived in the Aravalli hills, eating rotis made of grass seed, and perfected 'Guerilla Warfare.' He famously vowed never to sleep on a bed or eat from gold plates until Chittor was liberated. By the time of his death, he had won back almost all of Mewar except the fort of Chittor itself.",
        "Modern Edge": "The vow of austerity. Don't enjoy the trappings of success until the mission is complete. Living hard keeps the fire alive."
      },
      {
        "Title": "Chhatrapati Shahu and the Expansion of the Empire",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The visionary who transformed the Maratha state into a Pan-Indian power.",
        "Description": "Grandson of Shivaji Maharaj, Shahu spent years in Mughal captivity. Upon his release, he unified the warring Maratha factions. He had the genius to recognize the talent of the Peshwas, delegating military command while remaining the moral and sovereign head. Under his reign, the Marathas moved from defending the Deccan to collecting taxes from the gates of Delhi and Bengal.",
        "Modern Edge": "Empower the CEO. A chairman (Chhatrapati) knows that his job is to find the best CEO (Peshwa) and let them run the operations."
      },
      {
        "Title": "Maharana Amar Singh and the Treaty of Dignity",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who secured peace without surrendering honor.",
        "Description": "After decades of continuous war, Mewar was exhausted. In 1615, Amar Singh negotiated a peace treaty with Prince Khurram (Shah Jahan). Uniquely, the Maharana refused to attend the Mughal court personally (sending his son instead) and insisted that Mewar would never give a daughter in marriage to the Mughals—terms unheard of in that era. He ensured Mewar remained a 'Vatan' (sovereign home) while finally allowing his people to rebuild.",
        "Modern Edge": "Negotiate for dignity. Peace is necessary for rebuilding, but never sign a treaty that strips you of your core identity."
      },
      {
        "Title": "Bhagat Singh: The Intellectual Revolutionary",
        "Category": "Freedom Fighters",
        "Region": "North",
        "Summary": "The youth who used the court and the gallows as a stage for freedom.",
        "Description": "Bhagat Singh was a brilliant thinker who believed that 'the sword of revolution is sharpened on the whetting-stone of ideas.' After the death of Lala Lajpat Rai, he and his comrades took a stand against British tyranny. In 1929, he threw non-lethal smoke bombs in the Central Legislative Assembly to 'make the deaf hear.' He refused to escape, using his trial to spread the message of independence. At the age of 23, he went to the gallows with a smile, singing songs of patriotism, sparking a fire that eventually led to the end of colonial rule.",
        "Modern Edge": "The courtroom is a stage. If they put you on trial, use it as a megaphone. Turn their legal system into your marketing platform."
      },
      {
        "Title": "Hakim Khan Suri: The Loyal Vanguard",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Pathan warrior who stood by Pratap until the very end.",
        "Description": "Hakim Khan Suri was the chief of Maharana Pratap's artillery and led the frontal assault at Haldighati. He saw Pratap as the true leader of a sovereign India. Legend has it that he fought so fiercely that even after he fell, his grip on his sword was so tight that it had to be buried with him. He remains a symbol of the deep communal harmony and shared sacrifice of the Mewari resistance.",
        "Modern Edge": "Competence over creed. A true leader attracts talent based on shared values, not shared religion. Diversity in the vanguard is strength."
      },
      {
        "Title": "Jhala Maan: The Royal Double",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The chieftain who wore the royal crown to save his King.",
        "Description": "During the heat of the Battle of Haldighati, Maharana Pratap was surrounded and wounded. Seeing the danger, Jhala Maan snatched the Royal Insignia and Umbrella from the Maharana, placing them on himself. The Mughal forces, thinking he was the King, diverted their entire attack toward him. This gave Pratap the vital window to retreat and continue the guerrilla war, while Jhala Maan fell fighting heroically.",
        "Modern Edge": "The sacrificial double. A loyal lieutenant knows when to wear the target to save the visionary. Protect the 'King' piece at all costs."
      },
      {
        "Title": "Rana Punja Bhil: The Guardian of the Aravallis",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The tribal chief who mastered the art of guerrilla warfare.",
        "Description": "Rana Punja and his Bhil warriors were the masters of the rugged Aravalli terrain. At Haldighati, they rained boulders and arrows down from the cliffs, causing chaos in the Mughal ranks. Punja's unwavering support was why Pratap could survive in the forests for 20 years. To this day, the Mewar Royal Emblem features a Bhil warrior on one side, honoring Rana Punja's legacy.",
        "Modern Edge": "Allies in the hills. The indigenous people know the terrain better than you. Treat them with respect, and they will be your eyes and ears."
      },
      {
        "Title": "Jaimal and Kalla: The Four-Armed Warrior",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The uncle and nephew who became a single force of nature.",
        "Description": "During the Siege of Chittorgarh, the commander Rao Jaimal was wounded in the leg by a musket shot and could not walk. Determined to fight in the final 'Saka' (last stand), his nephew Kalla Ji took Jaimal on his shoulders. With Jaimal wielding two swords above and Kalla wielding two below, they appeared to the enemy as a single, four-armed deity. They decimated the opposition until their last breath, defending the gates of their motherland.",
        "Modern Edge": "Synergy in suffering. When one is crippled and the other is blind, combine forces to become a four-armed fighting machine."
      },
      {
        "Title": "Patta Chawat: The Young Defender",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The 16-year-old who led the defense of Chittor.",
        "Description": "Alongside Jaimal and Kalla, the young Rawat Patta Sisodia fought with legendary bravery. After his mother and wife donned saffron and committed Jauhar, Patta led the charge against the Mughal forces. His valor was so immense that Akbar later erected stone statues of Jaimal and Patta at the gates of Agra Fort to honor their indomitable spirit.",
        "Modern Edge": "Youthful sacrifice. When the 16-year-olds are leading the charge, the enemy knows they are fighting a nation, not just an army."
      },
      {
        "Title": "Isar Das Chauhan: The Lion of the Gate",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The warrior who charged an elephant with a dagger.",
        "Description": "During the final breach of Chittorgarh, a Mughal war elephant was crushing the Rajput ranks. Isar Das Chauhan, seeing the devastation, did the unthinkable. He charged the beast alone, grabbed its tusk, and used it to pull himself up. He stabbed the mahout (driver) and challenged the elephant's trunk with his bare hands. His suicidal bravery stalled the elephant line, giving the Rajputs time to regroup for their final charge.",
        "Modern Edge": "Man vs. Beast. When technology (the elephant) threatens to crush you, sometimes you have to grab it by the tusk and fight it hand-to-hand."
      },
      {
        "Title": "The Night Engineers of Mewar",
        "Category": "Ancient Science",
        "Region": "West",
        "Summary": "Repairing a fortress under the cover of darkness.",
        "Description": "The Siege of Chittor lasted months because of the Mewari engineers. Every day, Mughal cannons would blast holes in the limestone walls. Every night, under a rain of musket fire, the workers and soldiers (led by Jaimal) would use a specific mixture of stone, lime, and jaggery to rebuild the walls. This 'instant-setting' masonry kept the fort impregnable for months against the world’s most advanced artillery of that time.",
        "Modern Edge": "Repair while they sleep. Resilience is the ability to rebuild overnight what the enemy destroyed during the day."
      },
      {
        "Title": "Phool Kanwar: The Flame of Chittor",
        "Category": "Forgotten Heroes",
        "Region": "West",
        "Summary": "The Queen who led the final Jauhar.",
        "Description": "Phool Kanwar was the wife of Rawat Patta and the sister of Kalla Ji. When it became clear that the fort would fall, she did not wait in despair. She organized and led thousands of women into the 'Jauhar' (ceremonial fire) to protect their honor. Her leadership ensured that the men could walk out into the 'Saka' (final fight) without any worry for their families, focusing purely on their duty to the land.",
        "Modern Edge": "The final firewall. When all defenses fail, the 'Jauhar' (scorched earth) ensures that the enemy conquers only ashes, not honor."
      },
      {
        "Title": "Udai Singh II: The Founder of Udaipur",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The King who built a city that could never be conquered.",
        "Description": "Udai Singh II realized that the massive walls of Chittorgarh could not withstand the new age of Mughal artillery. He founded a new capital, Udaipur, nestled deep within the Aravalli hills and protected by the Girwa valley. He built Lake Pichola to ensure a permanent water supply, creating a strategic, green oasis that remained unconquered for centuries while other desert forts fell.",
        "Modern Edge": "Strategic relocation. Don't die for a pile of stones. If the fort is a trap, build a new city in the mountains where you can survive and thrive."
      },
      {
        "Title": "Maharaja Ranjit Singh: The Lion of Punjab",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The one-eyed King who built the most powerful army in Asia.",
        "Description": "Ranjit Singh survived smallpox as a child (which left him with one eye) and rose to unify the Sikh Misls at age 12. He captured Lahore in 1799 and established a kingdom that stretched from the Khyber Pass to Tibet. He modernized his army with European tactics, but maintained a deeply Indian soul, donating tons of gold to the Kashi Vishwanath temple and the Harmandir Sahib (Golden Temple). He was so respected that for 40 years, the British dared not cross the Sutlej River into his territory.",
        "Modern Edge": "Modernize without losing soul. Adopt the best Western tactics (French generals) but keep your heart deeply Indian. Hybrid models win."
      },
      {
        "Title": "Maharana Hammir Singh: The Liberator of Mewar",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The king who reclaimed Chittorgarh from the shadows.",
        "Description": "After the fall of Chittor in 1303, the land was under foreign occupation. Hammir Singh, a young scion of the Sisodia branch, stayed in the hills, building a grassroots army. In 1326, through brilliant strategy and local support, he recaptured the Chittorgarh Fort. He defeated the Tughlaq forces at the Battle of Singoli and took the Sultan as a prisoner. He replaced the title 'Rawal' with 'Rana' and 'Maharana,' marking the beginning of the Sisodia era that lasted for centuries.",
        "Modern Edge": "The comeback kid. You can lose everything, live in the woods, and still come back to reclaim your kingdom. Never accept defeat as final."
      },
      {
        "Title": "Sadashivrao Bhau: The Commander of the North",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The Maratha General who fought 1,000 miles from home.",
        "Description": "Sadashivrao Bhau led the Maratha forces to Panipat to defend the Indian subcontinent from foreign invasion. Despite being cut off from supply lines and facing a brutal winter, he refused to retreat. He launched a massive infantry charge that nearly broke the Afghan center. He died fighting in the thick of the battle, choosing a hero's death over a dishonorable surrender.",
        "Modern Edge": "The burden of command. Leading a massive army far from home requires nerves of steel. Even if you fail, the audacity of the attempt defines the era."
      },
      {
        "Title": "Ibrahim Khan Gardi: The Loyal Musketeer",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The General who proved loyalty knows no religion.",
        "Description": "Ibrahim Khan Gardi was the commander of the Maratha artillery. Using advanced French-trained tactics, his cannons decimated the Afghan ranks in the early hours of the battle. When the Maratha line began to crumble, he was offered safety to defect because of his faith, but he refused, stating his loyalty was to the Maratha State and Sadashivrao Bhau. He fought until he was captured and executed.",
        "Modern Edge": "Professional integrity. A mercenary fights for money; a professional fights for his contract and his honor. Be the latter."
      },
      {
        "Title": "Shamsher Bahadur: The Lion's Son",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The brave prince who fell defending the Maratha dream.",
        "Description": "Shamsher Bahadur was a key commander at Panipat. He led his cavalry into the heart of the Afghan ranks, sustaining multiple wounds. He managed to escape the battlefield but eventually succumbed to his injuries. His presence at Panipat showed the unity of the Maratha house in the face of a national threat.",
        "Modern Edge": "Blood of the lion. A mixed heritage is not a weakness; it's a double source of strength. Fight with the valor of both your lineages."
      },
      {
        "Title": "Rajendra Chola I: The Ocean King",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Emperor who turned the Bay of Bengal into a Chola Lake.",
        "Description": "Rajendra Chola I took the Chola Empire to its zenith. He led a daring expedition to North India, reaching the Ganges, and built a new capital, Gangaikondacholapuram, to celebrate. Most notably, he launched a massive naval invasion of Southeast Asia (Srivijaya/Indonesia), securing trade routes to China. His navy was the most advanced of its time, featuring ships capable of carrying war elephants across the ocean. He was a patron of arts and built the magnificent Brihadisvara Temple at Gangaikondacholapuram.",
        "Modern Edge": "Blue water strategy. Don't just look at the land; look at the ocean. Controlling the trade routes is the key to global dominance."
      },
      {
        "Title": "Hari Singh Nalwa: The Frontier Tiger",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The legendary Sikh Commander who terrified invaders.",
        "Description": "As the Commander-in-chief of the Sikh Empire, Hari Singh Nalwa secured the Khyber Pass—the gateway used by invaders for centuries. He built forts and established a presence so formidable that his name alone became a deterrent against potential invasions for generations.",
        "Modern Edge": "Build a reputation of excellence. A strong brand and a track record of consistency act as a 'fort' that prevents trouble before it even begins."
      },
      {
        "Title": "Rani Abbakka Chowta: The Fearless Queen",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The Tuluva Queen who fought the Portuguese for 40 years.",
        "Description": "Known as 'Abhaya Rani', she repeatedly defeated Portuguese attempts to capture the port of Ullal. She used fire-arrows and night-raid tactics to protect her trade freedom, refusing to pay tribute to foreign invaders for over four decades.",
        "Modern Edge": "Persistence is a strategy. If you stay in the game long enough and refuse to settle for unfair terms, the competition will eventually lose their will to fight you."
      },
      {
        "Title": "Raja Dahir: The Last Hindu King of Sindh",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The King who fought the first Arab invasion of the subcontinent.",
        "Description": "In 711 CE, Raja Dahir faced the Arab general Muhammad bin Qasim, who was invading from the West. Despite being outnumbered and facing a new kind of warfare, Dahir's forces fought fiercely to defend their land. He was eventually defeated and killed in battle, but his resistance delayed the Arab conquest of the subcontinent for decades.",
        "Modern Edge": "The first line of defense. When a new threat emerges, be the first to recognize it and stand your ground. Early resistance can buy you crucial time to adapt."
      },
      {
        "Title": "Zorawar Singh: The Himalayan Conqueror",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The General who fought at the roof of the world.",
        "Description": "General Zorawar Singh led expeditions into Ladakh and Tibet, regions where no army had ever dared to campaign due to the extreme altitude and cold. He expanded the borders of the Dogra Empire into the clouds through sheer physical and mental endurance.",
        "Modern Edge": "Expand into the 'Impossible'. The greatest rewards are often hidden in the most difficult environments where your competitors are too afraid to go."
      },
      {
        "Title": "Nagabhata I and the Great Resistance",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The King who saved India from the Umayyad invasion.",
        "Description": "In the 8th century, the Umayyad Caliphate was an unstoppable global force until they met Nagabhata I. He led a confederacy of Indian kings to decisively defeat the invaders in Rajasthan, protecting the heartland of India for centuries to come.",
        "Modern Edge": "Collective defense is the best strategy. When facing a massive external shift in your industry, stop competing with peers and start collaborating to survive."
      },
      {
        "Title": "Peer Ali Khan: The Rebel Bookseller",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The quiet intellectual who fueled a revolution.",
        "Description": "A bookshop owner in Patna who became a key organizer of the 1857 rebellion. He used his shop as a secret meeting point for revolutionaries, proving that the pen and the word are often as dangerous to tyrants as the sword.",
        "Modern Edge": "Information is power. In any struggle or market shift, the person who controls the flow of communication and ideas holds the hidden keys to the movement."
      },
      {
        "Title": "Mihira Bhoja: The Constant Defender",
        "Category": "Rulers",
        "Region": "North",
        "Summary": "The Gurjara-Pratihara king who held the line for 50 years.",
        "Description": "Mihira Bhoja maintained a massive standing army, including a legendary cavalry, to defend India's western borders. His reign was so stable and prosperous that travelers noted his kingdom was safe from even the smallest crimes, creating a golden age of security.",
        "Modern Edge": "Consistency is the ultimate competitive advantage. Being 'great' for a day is easy; maintaining a standard of absolute excellence for decades is what builds a legacy."
      },
      {
        "Title": "Kuyili: The First Human Bomb",
        "Category": "Forgotten Heroes",
        "Region": "South",
        "Summary": "The commander who sacrificed herself to destroy the enemy's armory.",
        "Description": "Kuyili was a trusted commander of Rani Velu Nachiyar, the first queen to fight the British in India. During a critical battle, when the British had taken over the fort's armory, Velu Nachiyar ordered Kuyili to destroy it. Kuyili doused herself in ghee, set herself on fire, and jumped into the armory, causing a massive explosion that turned the tide of the battle in favor of the queen.",
        "Modern Edge": "Innovate in desperation. When outgunned, invent new tactics (like the human bomb) that the enemy's rulebook has no defense against."
      },
      {
        "Title": "Bagha Jatin: The Tiger of Bengal",
        "Category": "Forgotten Heroes",
        "Region": "East",
        "Summary": "The revolutionary who believed in 'Amra morbo, jagbe desh'.",
        "Description": "Jatin Mukherjee was a key leader of the Jugantar movement. He famously fought a Royal Bengal Tiger with only a dagger. Later, he organized an international network to ship arms to India, dying in a heroic trench fight against the British police in Balasore.",
        "Modern Edge": "Build a global network. Even a 'local' struggle can be won by leveraging international connections and resources to put pressure on a dominant incumbent."
      },
      {
        "Title": "Tipu Sultan: The Tiger of Mysore",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "The pioneer of rocket artillery and the fiercest foe of the British.",
        "Description": "Tipu Sultan was the ruler of the Kingdom of Mysore who fought four Anglo-Mysore wars. He was a polymath who modernized his army with the 'Mysorean Rockets'—iron-cased rockets that terrified British troops and later influenced the development of modern rocketry. Despite immense pressure, he refused to become a subsidiary of the British Empire, dying on the battlefield defending his capital, Seringapatam.",
        "Modern Edge": "Innovation is the ultimate equalizer. When outmatched by a larger force's numbers, leverage cutting-edge technology to disrupt their strategy and force them to play by your rules."
      },
      {
        "Title": "Uda Devi: The Hidden Sniper of 1857",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The woman who took down 32 British soldiers from a single tree.",
        "Description": "During the Siege of Lucknow, Uda Devi, dressed in male attire, climbed a large pipal tree with a musket and a bag of ammunition. She single-handedly held off a British battalion, taking down 32 soldiers from her hidden vantage point before she was finally spotted. Her bravery remains a legendary symbol of the grassroots resistance in Awadh.",
        "Modern Edge": "Hidden Influence. You don't always need a loud presence to be effective; the most significant impact is often made by the person who operates strategically from an overlooked position."
      },
      {
        "Title": "The Battle of Takkolam",
        "Category": "Rulers",
        "Region": "South",
        "Summary": "A sudden shift in the Chola-Rashtrakuta rivalry.",
        "Description": "A decisive clash in 949 CE where the Rashtrakutas used a surprise elephant charge to kill the Chola prince Rajaditya. This battle temporarily halted Chola expansion, proving that a single, well-timed tactical strike can dismantle the momentum of a rising empire.",
        "Modern Edge": "Watch for the Pivot. Momentum can be lost in a single moment if you become predictable. Always have a contingency plan for a 'Black Swan' event in your market."
      },
      {
        "Title": "The Battle of Khanwa",
        "Category": "Battles",
        "Region": "North",
        "Summary": "The battle that established Mughal dominance in India.",
        "Description": "In 1527, Babur faced a coalition of Rajput kings led by Rana Sanga. Despite being outnumbered, Babur's use of field artillery and innovative tactics led to a decisive victory, paving the way for the Mughal Empire's establishment in India.",
        "Modern Edge": "Innovation beats numbers. In a competitive market, leveraging new technology or strategies can allow a smaller player to defeat larger incumbents."
      },
      {
        "Title": "The Battle of Plassey",
        "Category": "Battles",
        "Region": "North",
        "Summary": "The battle that marked the beginning of British colonial rule.",
        "Description": "In 1757, Robert Clive led the British East India Company against the Nawab of Bengal, Siraj ud-Daulah. Through a combination of military strategy and political intrigue (including bribing key allies), the British secured a decisive victory that allowed them to establish control over Bengal and eventually the entire subcontinent.",
        "Modern Edge": "The power of alliances. In business or politics, winning often depends on building the right partnerships and knowing when to leverage them for maximum impact."
      },
      {
        "Title": "Malharrao Holkar: The Shepherd King",
        "Category": "Rulers",
        "Region": "West",
        "Summary": "The founder of the Holkar dynasty who rose from humble roots.",
        "Description": "Starting as a soldier in the Peshwa's army, Malharrao's tactical brilliance in the battles of Amjhera and Delhi led to his rise as a frontline commander. He was granted the territory of Malwa, where he established Indore. He was a master of 'Ganimi Kava' (guerrilla tactics) and played a pivotal role in expanding Maratha influence into Northern India during the 18th century.",
        "Modern Edge": "Your starting point does not define your ceiling. Focus on mastering the 'technical' skills of your field (tactics) to make yourself indispensable to leadership, and the platform for your own empire will follow."
      },
      {
        "Title": "Sukhdev: The Mastermind of HRSA",
        "Category": "Freedom Fighters",
        "Region": "North",
        "Summary": "The chief strategist who organized the revolutionary network.",
        "Description": "Sukhdev Thapar was the brain behind the organizational structure of the HSRA. While others were the face of the movement, Sukhdev was the planner who established revolutionary cells across North India. He was instrumental in the Lahore Conspiracy Case and was the one who pushed the group toward intellectual growth, making sure every revolutionary was as well-read as they were brave.",
        "Modern Edge": "The 'Back-End' matters. Every successful public-facing mission needs a master strategist who builds the infrastructure, coordinates the team, and ensures the foundation is solid before the first move is made."
      },
      {
        "Title": "Rajguru: The Precision Marksman",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The fearless revolutionary from Maharashtra who provided the firepower.",
        "Description": "Shivaram Rajguru was a master of physical fitness and marksmanship. Hailing from Pune, he joined the HSRA with a single-minded goal: to free India from British rule through direct action. He was the one who fired the first shot in the assassination of J.P. Saunders to avenge Lala Lajpat Rai, executing a high-risk mission with deadly precision and calm.",
        "Modern Edge": "Specialization is key. In any high-stakes project, you need 'The Specialist'—someone who has mastered a single, critical skill to such a high degree that they can execute under extreme pressure when there is no room for error."
      },
      {
        "Title": "Rani Lakshmibai: The Rebel Queen",
        "Category": "Freedom Fighters",
        "Region": "North",
        "Summary": "The warrior queen who became the face of the 1857 resistance.",
        "Description": "After the British attempted to annex Jhansi under the 'Doctrine of Lapse,' Lakshmibai refused to cede her kingdom. She famously declared, 'Main apni Jhansi nahi doongi' (I will not give up my Jhansi). She transformed herself into a soldier, training a regiment of women and leading her troops on horseback. She died fighting in Gwalior, earning the respect of even her enemies, who called her 'the most dangerous of all rebel leaders.'",
        "Modern Edge": "Extreme Ownership. When your back is against the wall, don't look for a savior; become the leader you are waiting for. True authority is taken, not given, especially when the odds are stacked against you."
      },
      {
        "Title": "Mangal Pandey: The First Spark",
        "Category": "Forgotten Heroes",
        "Region": "North",
        "Summary": "The soldier whose single act of defiance ignited the 1857 Uprising.",
        "Description": "A sepoy in the 34th Bengal Native Infantry, Mangal Pandey revolted against the use of greased cartridges that offended his religious beliefs. On March 29, 1857, at Barrackpore, his open rebellion and call to his comrades to join him became the catalyst for the First War of Indian Independence. Though he was executed, his name became a rallying cry for thousands of soldiers across the subcontinent.",
        "Modern Edge": "The Catalyst Effect. You don't always need a massive army to start a movement; sometimes, a single, unwavering act of integrity is enough to break the inertia of an entire system and force a revolution."
      },
      {
        "Title": "Sardar Patel: The Iron Will",
        "Category": "Freedom Fighters",
        "Region": "West",
        "Summary": "The organizational genius who turned small protests into a national movement.",
        "Description": "Before becoming the architect of modern India, Vallabhbhai Patel led the Bardoli Satyagraha with such surgical precision that the title 'Sardar' (Chief) was given to him by the people. He excelled in the 'ground game'—organizing villages, managing logistics, and ensuring absolute non-violent discipline among thousands. His ability to bridge the gap between high-level political strategy and grassroots execution made the freedom struggle an unstoppable force.",
        "Modern Edge": "The Power of Logistics. Visionary ideas are useless without the 'Iron Will' to organize the details. To win at scale, you must master the boring, back-end logistics of your mission as thoroughly as the front-end strategy."
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