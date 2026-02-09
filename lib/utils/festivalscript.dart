import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> populateEncylopeadicFestivals() async {
  final CollectionReference festivals = 
      FirebaseFirestore.instance.collection('Festivals');

  final List<Map<String, dynamic>> festivalList = [
    {
      "Name": "Diwali",
      "Regions": ["North", "South", "East", "West", "Central"], 
      "History": "Diwali, or Deepavali, marks the joyous return of Lord Rama to Ayodhya after 14 years of exile. In other traditions, it celebrates the victory of Lord Krishna over Narakasura or the birth of Goddess Lakshmi from the Samudra Manthan.",
      "Significance": "Known as the 'Festival of Lights,' it represents the victory of light over darkness and knowledge over ignorance. It is a time for renewal, prosperity, and the celebration of the inner light of the soul.",
      "RegionalRituals": {
        "North": "People perform Lakshmi Puja, decorate homes with elaborate Rangolis, and burst crackers. Businessmen traditionally start new account books on this auspicious day.",
        "South": "Known as Deepavali, the day begins before dawn with a ritual oil bath (Ganga Snaanam), symbolizing the cleansing of soul and body, followed by wearing new clothes.",
        "East": "In West Bengal and Odisha, the night is dedicated to the fierce Goddess Kali, who destroys ego and evil, marked by grand community pandals and intense midnight prayers.",
        "West": "Marks the start of the New Year. Rituals include 'Chopda Pujan' where business ledgers are blessed for a prosperous year ahead, and homes are illuminated with thousands of diyas.",
        "Central": "Celebrated with 'Govardhan Puja' and 'Gai Jagran.' In tribal areas, cattle are decorated with colors and flowers, and traditional folk dances are performed for community prosperity."
      },
    },
    {
      "Name": "Holi",
      "Regions": ["North", "West", "Central", "East", "South"],
      "History": "Rooted in the legend of Prahlad's victory over the demoness Holika through faith in Vishnu. It also celebrates the eternal and divine love of Radha and Krishna in the fields of Braj.",
      "Significance": "The 'Festival of Colors' signifies the arrival of spring. It is a day to let go of grudges, where social barriers are broken and everyone becomes equal under a coat of vibrant colors.",
      "RegionalRituals": {
        "North": "In Mathura and Vrindavan, celebrations last weeks. 'Lathmar Holi' features women playfully hitting men with sticks, recreating the legends of the Gopis and Krishna.",
        "West": "Huge bonfires called 'Holika Dahan' are lit on the eve to symbolize the burning of evil thoughts. The next day is celebrated with music and dry colors (Gulal).",
        "East": "Known as 'Dol Jatra', idols of Krishna and Radha are placed on decorated palanquins and taken through the streets with community singing and dancing.",
        "Central": "In the Malwa region, the fifth day (Rang Panchami) is the main event where huge crowds gather in public squares to be sprayed with colored water and herbal powders.",
        "South": "Celebrated as 'Kamadahana,' the day Shiva burnt Kama Deva with his third eye. In modern cities, it has evolved into massive community rain dances and music festivals."
      },     
    },   
    {
      "Name": "Navratri",
      "Regions": ["West", "North", "South", "East", "Central"],
      "History": "Dedicated to the nine forms of Goddess Durga, commemorating her fierce nine-night battle against the buffalo demon Mahishasura, ending in his defeat on the tenth day.",
      "Significance": "A celebration of 'Shakti'—primordial cosmic energy. It represents the soul's journey from darkness to light and the destruction of inner traits like greed, anger, and lust.",
      "RegionalRituals": {
        "West": "World-famous for Garba and Dandiya Raas. People dress in traditional 'Chaniya Cholis' and dance in rhythmic circles around a central lamp representing the cycle of life.",
        "North": "Devotees observe strict fasts and plant barley seeds (Khetri). On the eighth or ninth day, young girls are worshipped as living goddesses (Kanya Pujan).",
        "South": "Homes display 'Golu'—multi-tiered shelves of dolls representing deities and daily life. Women exchange betel leaves, nuts, and traditional sweets.",
        "East": "The final days merge into Durga Puja. Massive, artistic clay idols are worshipped in community pandals, accompanied by the sounding of the Dhak (drums).",
        "Central": "High-energy Garba events are held in public grounds. It also features 'Matki Phod' competitions and traditional folk music that blends Western and Central Indian styles."
      },      
    },   
    {
      "Name": "Dussehra",
      "Regions": ["North", "South", "West", "East", "Central"], 
      "History": "In the North, it celebrates Rama killing Ravana to rescue Sita. In the East and South, it marks the day Goddess Durga slew Mahishasura. It is the day of ultimate 'Vijay' (Victory).",
      "Significance": "The quintessential celebration of 'Victory of Good over Evil.' Burning the ten-headed Ravana symbolizes purging negative traits like ego and lust from our own lives.",
      "RegionalRituals": {
        "North": "Massive effigies of Ravana and his kin are filled with crackers and set on fire in Ramlila grounds amidst theatrical performances and cheering crowds.",
        "South": "In Mysuru, a grand elephant procession (Jumboo Savari) takes place. Across the region, 'Ayudha Puja' is performed to bless tools, books, and vehicles.",
        "West": "People exchange leaves of the Shami tree, symbolizing 'gold,' and seek blessings from elders. It is also a significant day for the worship of traditional weapons.",
        "East": "Known as Bijoya Dashami; idols of Durga are immersed in rivers. Adults exchange 'Subho Bijoya' greetings, and younger people seek blessings by touching elders' feet.",
        "Central": "The Bastar Dussehra in Chhattisgarh is unique; it lasts 75 days and honors the local goddess Danteshwari Mai with tribal rituals and massive wooden chariots."
      },     
    },
    {
      "Name": "Ganesh Chaturthi",
      "Regions": ["West", "South", "Central", "North", "East"],
      "History": "Celebrates the birth of the elephant-headed Lord Ganesha. It was popularized as a public event by Lokmanya Tilak to unite people during the independence movement.",
      "Significance": "Ganesha is the Remover of Obstacles and the Giver of Wisdom. The festival teaches the cycle of creation and dissolution as clay idols eventually return to the water.",
      "RegionalRituals": {
        "West": "In Maharashtra, gigantic idols are installed in 'Mandals.' After 10 days of worship, grand 'Visarjan' processions carry the idols to the sea for immersion.",
        "South": "Families prepare 'Modakam' (sweet dumplings). Small clay idols are worshipped at home with 21 varieties of leaves and traditional hymns.",
        "Central": "Focuses on community bonding through cultural programs, music concerts, and communal feasts organized in residential colonies.",
        "North": "Massive temporary Pandals are erected in cities like Delhi. The festival includes night-long bhajans and grand processions to the Yamuna river.",
        "East": "In Odisha and Bengal, theme-based Pandals house handcrafted idols. Students venerate Ganesha as the patron of learning with special offerings like 'Chuda Ghasa'."
      },     
    },    
    {
      "Name": "Maha Shivratri",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "The 'Great Night of Shiva.' Legends celebrate it as the night of Shiva's cosmic 'Tandava' dance or the night of his sacred marriage to Goddess Parvati.",
      "Significance": "A festival of internal stillness and meditation. Falling on the darkest night of the month, it signifies finding the light of consciousness within the darkness of ignorance.",
      "RegionalRituals": {
        "North": "Devotees perform 'Abhishekam' (ritual pouring of milk and honey) on the Shivling and offer Bael leaves. Thousands trek to mountain shrines.",
        "South": "Temples stay open all night for 'Jagaran' (vigil). Classical dancers perform 'Natyanjali' to honor Shiva as the Lord of Dance.",
        "East": "Devotees carry holy water from the Ganges in pots (Kanwar Yatra) over long distances to offer at ancient Shiva shrines and Jyotirlingas.",
        "West": "Massive fairs are held near Jyotirlinga temples like Somnath. Thousands gather for midnight prayers and the chanting of 'Om Namah Shivaya'.",
        "Central": "In Ujjain, the Mahakal temple features the 'Shiv Navratri.' A unique 'Bhasma Aarti' (ash offering) and the 'Shiv Barat' procession are the main highlights."
      },     
    },
    {
      "Name": "Raksha Bandhan",
      "Regions": ["North", "West", "Central", "East", "South"],
      "History": "Rooted in the Puranas and historical legends like Queen Karnavati sending a thread to Emperor Humayun. It celebrates the promise of protection and selfless love.",
      "Significance": "The 'Bond of Protection' celebrates the love between siblings. It also serves as a festival of social harmony where threads are tied to establish bonds of respect.",
      "RegionalRituals": {
        "North": "Sisters perform aarti, apply tilak, and tie decorative Rakhis. Brothers give gifts and a lifelong promise of protection and support.",
        "West": "Celebrated as 'Narali Purnima' in coastal areas. Coconuts are offered to the Sea God (Varuna) to mark the start of the new fishing season.",
        "Central": "Known as 'Kajari Purnima'; women and farmers worship the earth for a bountiful harvest and perform rituals for family well-being.",
        "East": "Known as 'Jhulan Purnima'; idols of Radha-Krishna are placed on swings. While sibling rituals occur, the day marks the end of the monsoon swing festival.",
        "South": "Brahmin communities observe 'Avani Avittam,' changing their sacred threads. In cities, the traditional sibling Rakhi ceremony is now widely popular."
      },
    },    
    {
      "Name": "Kumbh Mela",
      "Regions": ["North", "West","Central"],
      "History": "Commemorates the dropping of the nectar of immortality (Amrit) at four sites: Prayagraj, Haridwar, Nashik, and Ujjain during a cosmic battle between gods and demons.",
      "Significance": "The largest peaceful gathering of humanity. A holy dip in the sacred rivers during the Mela is believed to cleanse all sins and lead to Moksha (liberation).",
      "RegionalRituals": {
        "North": "At Prayagraj and Haridwar, different monastic orders (Akhadas) lead the 'Shahi Snan' (Royal Bath) processions into the Ganges.",
        "West": "In Nashik, on the banks of the Godavari, thousands of Naga Sadhus and pilgrims gather for ancient rituals and spiritual discourses.",
        "Central": "In Ujjain, the 'Simhastha Kumbh' is held on the Shipra river when Jupiter enters Leo. Millions participate in the sacred Panch-Koshi Yatra."
      },
    },
    {
      "Name": "Eid-ul-Fitr",
      "Regions": ["North", "West", "Central", "South", "East"], 
      "History": "Established by Prophet Muhammad in 624 CE, it marks the end of Ramadan, the holy month of fasting and prayer commemorating the revelation of the Quran.",
      "Significance": "A day of charity (Fitr) and celebration. It rewards a month of self-restraint and emphasizes community, family, and providing for the needy.",
      "RegionalRituals": {
        "North": "Communal prayers are held at historic Eidgahs. People enjoy 'Sewaiyan' (sweet vermicelli) and elders give 'Eidi' (cash gifts) to children.",
        "West": "Mumbai's Mohammad Ali Road becomes a food hub. Community events are organized to distribute clothes and food to the less fortunate.",
        "Central": "In Bhopal, grand processions and the sharing of 'Bhopali Pulao' with neighbors of all faiths symbolize deep communal harmony.",
        "South": "Hyderabad's Charminar area is brilliantly lit. The season concludes with grand lunches and 'Oppana' songs in the Kerala Mappila tradition.",
        "East": "Focuses on 'Lachha Sewaiyan' and grand prayers at Kolkata's Red Road, followed by family visits to share ancestral stories."
      },
    },
    {
      "Name": "Guru Nanak Jayanti",
      "Regions": ["North", "West", "Central", "South", "East"], 
      "History": "Marks the birth of Guru Nanak Dev Ji, founder of Sikhism, who spread the message of one God, social equality, and the rejection of caste hierarchies.",
      "Significance": "A celebration of humanity and peace. It emphasizes 'Vand Chakko' (sharing with the needy) and 'Kirat Karo' (honest living) as paths to the Divine.",
      "RegionalRituals": {
        "North": "Celebrations begin with 'Prabhat Pheris'. A 48-hour 'Akhand Path' occurs, and 'Langar' (community kitchen) is served to everyone.",
        "West": "Gurudwaras in Mumbai and Pune are beautifully illuminated. Grand 'Nagar Kirtans' feature martial arts (Gatka) and devotional singing.",
        "Central": "Sikh communities in Indore and Jabalpur organize blood donation camps and serve 'Chabeel' (sweet water) alongside traditional prayers.",
        "South": "Focus centers on the historic Nanak Jhira Sahib in Bidar. Large-scale Langars are served to the public in Bangalore and Hyderabad.",
        "East": "Celebrated with Kirtans in Odisha and Bengal. Local communities highlight Nanak's historic visit to Puri and his message of universal brotherhood."
      },
    },
    {
      "Name": "Makar Sankranti",
      "Regions": ["North", "West", "Central", "South", "East"],
      "History": "Makar Sankranti is one of the few ancient Indian festivals that follows the solar cycle rather than the lunar. It marks the transition of the Sun into the zodiac sign of Makara (Capricorn) on its celestial path.",
      "Significance": "It is a festival of harvest, health, and harmony. It celebrates the Sun God for providing the energy for life and crops. The use of 'Til' (sesame) and 'Gur' (jaggery) represents the sweetness of speech.",
      "RegionalRituals": {
        "West": "In Gujarat and Rajasthan, the sky is filled with millions of colorful kites. The competition to 'cut' other kites (Kai Po Che) is intense.",
        "North": "Known as Maghi, it is celebrated with a holy dip in rivers. In Punjab, the eve is celebrated as Lohri with huge bonfires.",
        "Central": "In Maharashtra, people exchange 'Til-Gul' sweets and say 'Til-gul ghya, god god bola' (Eat sesame-jaggery and speak sweet words).",
        "South": "In Karnataka, it is 'Suggi' where girls wear new clothes and visit neighbors with a tray of offerings called 'Ellu-Birodhu'.",
        "East": "Known as 'Poush Sankranti' in Bengal; families prepare 'Pitha' (rice cakes) and thousands take a holy dip at Ganga Sagar."
      },
    },   
    {
      "Name": "Onam",
      "Regions": ["South"],
      "History": "Onam is the state festival of Kerala and traces its roots to the legend of the mythical King Mahabali. It celebrates his annual homecoming from the underworld.",
      "Significance": "It is a festival of prosperity, equality, and secularism. It reminds people of a 'Golden Age' where everyone was equal and nature was in full bloom.",
      "RegionalRituals": {
        "South": "The celebration includes 'Pookalam' (flower carpets), 'Vallam Kali' (snake boat races), and the 'Onasadya' feast served on banana leaves."
      },
    },
    {
      "Name": "Pongal",
      "Regions": ["South"],
      "History": "Pongal is a four-day harvest festival celebrated mainly by Tamilians. Its name comes from the Tamil word 'Pongu,' which means to boil over.",
      "Significance": "It represents abundance and gratitude toward nature. The boiling over of milk and rice in a clay pot is a symbolic sign of prosperity.",
      "RegionalRituals": {
        "South": "The four days are: Bhogi, Surya Pongal, Maatu Pongal (worshipping cows), and Kaanum Pongal. 'Jallikattu' is a traditional part of festivities."
      },
    },    
    {
      "Name": "Bihu",
      "Regions": ["East"],
      "History": "Bihu is the soul of Assam, consisting of Rongali, Kongali, and Bhogali Bihu throughout the year, rooted in ancient agrarian practices.",
      "Significance": "Each Bihu marks a stage in the paddy cultivation cycle. It is a celebration of the Assamese New Year and the joy of a successful harvest.",
      "RegionalRituals": {
        "East": "Youth perform the 'Bihu Dance' in traditional Muga silk attire. During Bhogali Bihu, community feasts are held near 'Mejis' (bamboo bonfires)."
      },
    },
    {
      "Name": "Chhath Puja",
      "Regions": ["North", "East", "West", "Central"],
      "History": "An ancient Vedic festival dedicated to the Sun God (Surya). It is one of the few festivals that has remained unchanged since the Vedic period.",
      "Significance": "It involves worshipping both the setting and rising sun. It acknowledges the cycle of birth and death without any idol worship.",
      "RegionalRituals": {
        "North": "Devotees stand in knee-deep water to offer 'Arghya' to the sun. Offerings like 'Thekua' are carried in bamboo baskets.",
        "East": "Observed with extreme rigor in Bihar and Jharkhand; the entire community gathers at riverbanks for sunset and sunrise prayers.",
        "West": "In cities like Mumbai, beaches like Juhu become massive sites for Chhath prayers, attended by millions of devotees.",
        "Central": "Celebrated with great fervor in Madhya Pradesh and Chhattisgarh, where local ponds and rivers are cleaned and decorated for the rituals."
      },
    },
    {
      "Name": "Ugadi - Gudi Padwa",
      "Regions": ["South", "West", "Central"],
      "History": "Marks the first day of the Hindu lunisolar calendar. Mythology states Lord Brahma started the creation of the universe on this day.",
      "Significance": "Teaches equanimity—accepting life's sweet and bitter experiences. It is a day for new beginnings and listening to the yearly forecast.",
      "RegionalRituals": {
        "South": "A special 'Ugadi Pachadi' is made with six ingredients representing the six emotions (sweet, sour, bitter, etc.) of life.",
        "West": "In Maharashtra, a 'Gudi' (victory flag) is hoisted outside homes to symbolize the warding off of evil and the victory of Shalivahana.",
        "Central": "Observed in Central India with the cleaning of homes, wearing new clothes, and preparing traditional festive meals like Shrikhand Puri."
      },
    },
    {
      "Name": "Baisakhi",
      "Regions": ["North", "West", "Central"],
      "History": "Marks the establishment of the 'Khalsa Panth' in 1699 by Guru Gobind Singh Ji. It is also a massive harvest festival for Northern farmers.",
      "Significance": "A festival of bravery, identity, and abundance. It commemorates the spirit of standing up against oppression and spiritual gratitude.",
      "RegionalRituals": {
        "North": "Marked by 'Nagar Kirtans' and energetic Bhangra dances. Gurudwaras serve 'Langar' to all, and farmers perform the 'Awat Pauni' harvest ritual.",
        "West": "In Punjabi hubs like Mumbai, Gurudwaras are illuminated and grand processions are held, followed by community feasts.",
        "Central": "Sikh communities in MP and Chhattisgarh organize kirtans and massive community service (Seva) events in local Gurudwaras."
      },
    },
    {
      "Name": "Karwa Chauth",
      "Regions": ["North", "West", "Central"],
      "History": "Linked to the legends of Queen Veervati and Karwa. It has evolved into a major cultural event celebrating the sanctity of marriage.",
      "Significance": "Signifies the strength of a woman's resolve and the marital bond. It is a day of sisterhood where women support one another through the fast.",
      "RegionalRituals": {
        "North": "Women dress in bridal finery and fast without water. The fast is broken only after seeing the moon through a sieve.",
        "Central": "Women gather for 'Sargi' and group storytelling, exchanging 'Karwas' (clay pots) filled with sweets and bangles.",
        "West": "Observed with family gatherings and traditional dinners after the moonrise, emphasizing the bond between husband and wife."
      },
    },
    {
      "Name": "Durga Puja",
      "Regions": ["East", "North", "West", "South", "Central"],
      "History": "Commemorates the victory of Goddess Durga over Mahishasura. In the East, it is the annual visit of the Goddess to her paternal home.",
      "Significance": "A celebration of art, culture, and the victory of the soul over the ego. The complex 'Pandals' represent the peak of human creativity.",
      "RegionalRituals": {
        "East": "The sounding of the 'Dhak,' 'Dhunuchi Naach,' and 'Sandhi Puja' are highlights. Women play 'Sindoor Khela' on the final day.",
        "North": "Celebrated as Navratri with fasts, 'Kanya Pujan' (worshipping young girls), and grand Ramlila plays ending in Dussehra.",
        "West": "Focused on high-energy 'Garba' and 'Dandiya' dances in community grounds, celebrating the Goddess's power.",
        "South": "Observed as 'Golu' where households display artistic dolls on tiered planks and perform 'Ayudha Puja' for tools and books.",
        "Central": "Known for both traditional Durga Pandals and vibrant Garba events, blending the cultures of the East and West."
      },
    },
    {
      "Name": "Ram Navami",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Marks the birth of Lord Rama, the 'Maryada Purushottam'—the perfect man who lived by Dharma despite extreme personal suffering.",
      "Significance": "Celebrates the power of character and truth. Rama’s reign, 'Ram Rajya,' remains the gold standard for a just and peaceful society.",
      "RegionalRituals": {
        "North": "Ayodhya sees millions of devotees. People perform 'Akhand Path' of the Ramayana and take holy dips in the Sarayu river.",
        "South": "Celebrated as 'Sita Rama Kalyanam' (the wedding of Rama and Sita). A refreshing drink called 'Panakam' is served as a traditional offering.",
        "West": "Temples organize 'Bhajans' and 'Kirtans' that reach a peak at noon, the hour of Rama's birth, followed by grand Mahaprasad.",
        "East": "Processions are taken out with devotees carrying flags. In many households, traditional sweet dishes and fruits are offered to the deity.",
        "Central": "Marked by 'Shobha Yatras' (grand processions) and community feasts. Many devotees observe a fast and visit local Rama temples."
      },
    },
    {
      "Name": "Eid-ul-Adha",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Commonly known as Bakra-Eid, it commemorates the test of faith of Prophet Ibrahim. According to tradition, as he was about to sacrifice his son Ismail in obedience to God, a ram was provided to take his place.",
      "Significance": "A celebration of devotion and sharing. The sacrificed meat is divided into three parts: for family, for friends, and for the poor, emphasizing that true faith involves sacrifice for a higher purpose.",
      "RegionalRituals": {
        "North": "Large communal prayers are held at Eidgahs like Jama Masjid. Families prepare Mutton Korma and Biryani, sharing meat with the local community.",
        "South": "In Hyderabad and Kerala, the day involves grand feasts with special varieties of Biryani and Haleem. Charity (Zakat) is distributed heavily to the needy.",
        "West": "The streets of Mumbai and Gujarat are festive. Community kitchens are set up to feed the less fortunate, and families gather for traditional meat-based delicacies.",
        "East": "In Kolkata and Lucknow (East/Central influence), the focus is on the communal 'Qurbani' and the preparation of traditional sweets like Shahi Tukda after the feast.",
        "Central": "Marked by solemn prayers followed by joyful family reunions and the distribution of meat to tribal and rural communities to ensure everyone participates in the feast."
      },
    },
    {
      "Name": "Christmas",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Christmas celebrates the birth of Jesus Christ. In India, the tradition was strengthened during the colonial era and has since become a major cultural event celebrated by people of all faiths.",
      "Significance": "It represents hope, light, and the spirit of giving. The birth of Jesus in a humble stable is seen as a message of humility and divine love for all of humanity.",
      "RegionalRituals": {
        "West": "In Goa, the atmosphere features 'Crib' competitions, midnight mass in historic cathedrals, and grand dances. Houses are decorated with paper stars.",
        "South": "In Kerala and Tamil Nadu, traditional 'Christmas Appam' and meat stews are prepared. Churches are illuminated with massive displays of lights.",
        "East": "In the Northeast (Meghalaya/Mizoram) and Kolkata, it features community feasts, soul-stirring choir singing, and grand lighting of the Park Street area.",
        "North": "Major cities like Delhi and Shimla see grand decorations in malls and churches. Midnight services are followed by 'Cake and Coffee' gatherings in the cold winter air.",
        "Central": "Christian communities in cities like Jabalpur and Indore host community carol singing and distribute sweets and blankets to the poor as a gesture of goodwill."
      },
    },
    {
      "Name": "Mahavir Jayanti",
      "Regions": ["West", "North", "Central", "South", "East"],
      "History": "Marks the birth of Vardhamana Mahavira, the 24th Tirthankara, who renounced his kingdom to seek spiritual awakening and attained omniscience.",
      "Significance": "Centers on 'Ahimsa' (Non-violence) toward all living beings. It promotes truth, compassion, and the path of liberation through self-discipline.",
      "RegionalRituals": {
        "West": "In Gujarat and Rajasthan, home to large Jain populations, grand 'Rath Yatras' are held. Temples are decorated with flowers and lamps, and massive donations are made to animal shelters.",
        "North": "Processions are carried out through the streets of Delhi and UP. Devotees visit ancient temples like Hastinapur for prayers and meditation.",
        "Central": "In MP, the day is marked by the 'Abhishek' of the deity followed by lectures on Mahavira’s teachings of non-violence and equality.",
        "South": "Major Jain centers like Shravanabelagola in Karnataka see thousands of devotees participating in special prayers and ceremonial baths for the idol.",
        "East": "In Bihar (the birthplace of Mahavira), devotees gather at Pawapuri and Kundalpur for silent meditation and the distribution of food to the needy."
      },
    },
    {
      "Name": "Buddha Purnima",
      "Regions": ["North", "East", "Central", "South", "West"],
      "History": "Also known as Vesak, it marks the day Gautama Buddha was born, attained Enlightenment, and passed away, all on the same full moon day.",
      "Significance": "Celebrates the 'Middle Path' and the practice of 'Metta' (loving-kindness). It reminds followers of the Four Noble Truths and the Eightfold Path to end suffering.",
      "RegionalRituals": {
        "East": "Bodh Gaya becomes a global pilgrimage center. Devotees dress in white and offer 'Kheer' to remember Sujata's offering to Buddha.",
        "North": "Sarnath and Kushinagar see grand ceremonies. Monks chant ancient sutras, and devotees light lamps around the stupas to symbolize enlightenment.",
        "Central": "The Sanchi Stupa area is illuminated. Devotees participate in day-long meditation retreats and listen to sermons on the Dhamma.",
        "West": "In the Ajanta and Ellora regions and Mumbai, Buddhist communities organize peaceful processions and blood donation camps to honor Buddha's compassion.",
        "South": "Temples and meditation centers in Hyderabad and Bangalore organize 'Vipassana' sessions and community meals for seekers of all backgrounds."
      },
    },
    {
      "Name": "Rath Yatra",
      "Regions": ["East", "West", "North"],
      "History": "The Rath Yatra of Puri, Odisha, is the oldest chariot festival in the world, celebrating Lord Jagannath’s journey to the Gundicha Temple.",
      "Significance": "Symbolizes the Lord's love for all, as he leaves the temple to meet devotees of all castes. Pulling the chariot represents pulling the Divine into one's heart.",
      "RegionalRituals": {
        "East": "In Puri, three massive wooden chariots are pulled by millions. The King sweeps the chariot with a golden broom in the 'Chhera Pahara' ritual.",
        "West": "The Ahmedabad Rath Yatra is the second largest, featuring decorated elephants and massive chariots moving through the old city streets.",
        "North": "In many cities like Delhi and ISKCON centers, smaller versions of the chariot festival are organized with singing and distribution of 'Prasad'."
      },
    },
    {
      "Name": "Muharram",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "The first month of the Islamic calendar, commemorating the martyrdom of Imam Hussain at the Battle of Karbala while standing against tyranny.",
      "Significance": "A time of mourning and reflection on justice and courage. It serves as a reminder to stand for truth even in the face of overwhelming odds.",
      "RegionalRituals": {
        "North": "In Lucknow and Delhi, 'Majlis' are held to recite the story of Karbala. Grand 'Taziyas' (tombs) are carried in solemn processions.",
        "South": "In Hyderabad, the 'Bibi-ka-Alam' procession is iconic. Traditional 'Sherbet' is distributed to everyone in memory of the thirst of the martyrs.",
        "West": "In Mumbai, the community gathers for mourning rituals and charitable acts, distributing food and water to travelers and the poor.",
        "East": "Solemn processions are taken out with Taziyas, accompanied by rhythmic drumming and chants honoring the sacrifice of Imam Hussain.",
        "Central": "In Bhopal, the day is marked by deep reflection and the distribution of 'Sabeels' (water/juice) to the public as a gesture of service."
      },
    },
    {
      "Name": "Navroz",
      "Regions": ["West", "Central", "North"],
      "History": "The Parsi New Year, marking the Spring Equinox. Its origins go back 3,000 years to the legendary Persian King Jamshed.",
      "Significance": "Represents the victory of light over darkness and the renewal of nature. It emphasizes 'Good Thoughts, Good Words, and Good Deeds.'",
      "RegionalRituals": {
        "West": "In Mumbai and Gujarat, houses are decorated with flowers and 'Chalk'. Families visit the Fire Temple and set up a symbolic 'Haft-Seen' table.",
        "Central": "Parsi communities in Central India gather for communal feasts featuring 'Patra ni Machhi' and seek blessings for a prosperous year ahead.",
        "North": "Though a small community, Parsis in Delhi host cultural events and invite friends of all faiths to share traditional Iranian delicacies."
      },
    },
    {
      "Name": "Guru Gobind Singh Jayanti",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Celebrates the 10th Sikh Guru, a warrior-saint who established the Khalsa and declared the Guru Granth Sahib as the eternal Guru.",
      "Significance": "Honors the spirit of the 'Saint-Soldier.' It teaches that one must be spiritually grounded yet ready to fight against oppression.",
      "RegionalRituals": {
        "North": "Gurudwaras are illuminated with thousands of lights. 'Nagar Kirtans' feature Gatka martial arts performances and the recitation of the Guru's poetry.",
        "South": "In Nanded (Maharashtra/South border), the Takht Sachkhand Shri Hazur Sahib sees grand celebrations and massive community kitchens (Langar).",
        "West": "In Mumbai and Pune, the Sikh community organizes grand processions and charitable drives like mobile clinics and book distributions.",
        "East": "In Patna (the Guru's birthplace), the Takht Sri Patna Sahib becomes a hub of global pilgrims with day-long kirtans and langars.",
        "Central": "Gurudwaras in Gwalior and Indore host continuous reading of the scriptures and serve traditional meals to thousands of devotees."
      },
    },
    {
      "Name": "Akshaya Tritiya",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "One of the most auspicious days, believed to be the start of the Treta Yuga and the day the Ganges descended to Earth.",
      "Significance": "Means 'that which never diminishes.' While popular for buying gold, its true essence lies in 'Dana' (charity) which is believed to return manifold.",
      "RegionalRituals": {
        "North": "People perform special Lakshmi-Ganesh pujas and start new business ledgers. It is a day of massive weddings across the region.",
        "South": "Known as 'Akshaya Thiruthiyai', people visit temples and buy a small piece of gold or a new utensil to welcome prosperity.",
        "West": "In Maharashtra and Gujarat, it is a day for 'Muhurats'. People buy gold and donate water and grain to the poor to earn merit.",
        "East": "In Odisha, this day marks the beginning of the construction of the massive chariots for the Puri Rath Yatra.",
        "Central": "Farmers worship their plows and tools, praying for an inexhaustible harvest, and distribute cool drinks to travelers."
      },
    },
    {
      "Name": "Hanuman Jayanti",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Celebrates the birth of Lord Hanuman, the Vanara god of strength and devotion, who is believed to be an immortal (Chiranjeevi).",
      "Significance": "Represents the synthesis of 'Shakti' (strength) and 'Bhakti' (devotion). He is the protector of the weak and the symbol of self-control.",
      "RegionalRituals": {
        "North": "Devotees flock to temples at sunrise. The 'Hanuman Chalisa' is recited collectively, and 'Bhandaras' (feasts) are organized.",
        "South": "Known as 'Hanumath Jayanthi', devotees offer 'Vada Mala' (garlands of savories) and apply butter to the idol to cool the deity.",
        "West": "Temples in Maharashtra and Gujarat organize night-long 'Kirtans'. Idols are smeared with orange Sindoor to signify his devotion to Rama.",
        "East": "In Bengal and Odisha, the day is marked by the hoisting of saffron flags and the distribution of sweets like Boondi Laddu.",
        "Central": "Ancient Hanuman shrines in the Vindhya range see massive gatherings of devotees performing continuous chanting of Rama's name."
      },
    },
    {
      "Name": "Vaikunta Ekadashi",
      "Regions": ["South", "Central", "North"],
      "History": "Marks the victory of the female energy 'Ekadashi' over the demon Muran. It is believed the gates of Lord Vishnu's abode remain open today.",
      "Significance": "The most important Ekadashi, emphasizing the victory of spiritual consciousness. It represents the hope of liberation (Moksha).",
      "RegionalRituals": {
        "South": "In Srirangam and Tirupati, the 'Gate to Heaven' is opened. Thousands walk through the door to symbolize entry into Vaikunta.",
        "North": "Devotees visit Vishnu temples and observe a strict fast, spending the day reading the Bhagavad Gita and chanting hymns.",
        "Central": "Observed with great discipline in temples across Maharashtra and MP, featuring night-long bhajans and the avoidance of grains."
      },
    },
    {
      "Name": "Thaipusam",
      "Regions": ["South"],
      "History": "Commemorates Goddess Parvati giving a 'Vel' (spear) to Lord Murugan to vanquish the demon Soorapadman.",
      "Significance": "Represents the destruction of inner enemies like ego and greed. The spear (Vel) symbolizes sharp, focused wisdom.",
      "RegionalRituals": {
        "South": "Devotees carry 'Kavadi' and perform acts of penance, including skin and tongue piercing, as a mark of total surrender to Murugan."
      },
    },
    {
      "Name": "Thrissur Pooram",
      "Regions": ["South"],
      "History": "Conceptualized by Sakthan Thampuran in the 18th century, this festival broke the monopoly of older traditions by inviting ten temples to pay obeisance to Lord Vadakkunnathan.",
      "Significance": "Known as the 'Mother of all Poorams,' it is a grand display of Kerala’s cultural opulence and communal harmony, attracting people of all faiths.",
      "RegionalRituals": {
        "South": "Features the 'Kudamattom' (umbrella exchange) atop 30 caparisoned elephants, accompanied by 'Chenda Melam' drumming and a massive fireworks display."
      },
    },
    {
      "Name": "Lohri",
      "Regions": ["North", "West", "Central"],
      "History": "Associated with the winter solstice and the legend of Dulla Bhatti, a local hero who rescued and protected girls from slave markets during the Mughal era.",
      "Significance": "Marks the end of winter and the arrival of longer days. For farmers, it is a thanksgiving for the Rabi harvest and a celebration of new beginnings like births or weddings.",
      "RegionalRituals": {
        "North": "Huge bonfires are lit where people offer peanuts and 'Rewari' to the flames. The night includes 'Sarson da Saag' feasts and energetic Bhangra dances.",
        "West": "In Punjabi hubs like Mumbai, community bonfires are lit in housing societies where families gather for folk songs and traditional sweets.",
        "Central": "Celebrated by North Indian communities in MP and Chhattisgarh with bonfires and sharing of sesame-based sweets to mark the changing season."
      },
    },
    {
      "Name": "Teej",
      "Regions": ["North", "West", "Central"],
      "History": "Celebrates the reunion of Goddess Parvati with Lord Shiva after 108 births of penance. It falls during the monsoon season, marking the earth's rejuvenation.",
      "Significance": "Celebrates nature's bounty and the feminine spirit. Women pray for marital bliss and the longevity of their partners while enjoying the monsoon's greenery.",
      "RegionalRituals": {
        "North": "In Rajasthan and Haryana, women wear green 'Leheriya' sarees and use swings hung from trees. A grand 'Teej Mata' procession is held in Jaipur.",
        "West": "In Gujarat, it is a day of prayer and fasting for women. Intricate Mehendi is applied, and special monsoon delicacies like 'Ghevar' are shared.",
        "Central": "Known as 'Hariyali Teej' in MP; women gather to sing folk songs, worship the moon, and exchange gifts of clothes and jewelry."
      },
    },
    {
      "Name": "Nag Panchami",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "An ancient tradition commemorating Krishna's victory over the serpent Kaliya. It also honors Shesha, the serpent on whom Lord Vishnu rests.",
      "Significance": "Reflects the Vedic philosophy of coexistence with nature. Snakes are worshipped as protectors of the earth and represent the inner 'Kundalini' energy.",
      "RegionalRituals": {
        "North": "People offer milk at snake pits and draw snake images on doorways with flour to protect the home from calamities.",
        "South": "Known for the worship of 'Naga Devatas' in temples. Women offer milk and turmeric to stone idols (Nagakal) to seek family protection.",
        "West": "In Maharashtra, people visit 'Nagoba' temples. Farmers avoid plowing the fields on this day to ensure no snakes are accidentally harmed.",
        "East": "In Bengal and Odisha, Goddess Manasa (the Queen of Snakes) is worshipped with clay idols to protect the household from snakebites during the monsoon.",
        "Central": "Communities offer milk and flowers to live snakes handled by traditional charmers and visit ancient snake shrines in the forests."
      },
    },
    {
      "Name": "Kartik Purnima",
      "Regions": ["North", "West", "East", "Central", "South"],
      "History": "Known as the 'Full Moon of the Gods,' it marks Shiva's victory over Tripurasura and the day the Gods descend to the Ganges (Dev Deepavali).",
      "Significance": "A spiritually powerful day marking the end of Chaturmas. It symbolizes purification and the triumph of divine light over chaotic darkness.",
      "RegionalRituals": {
        "North": "Varanasi ghats are lit with millions of oil lamps for 'Dev Deepavali,' and thousands take a holy dip in the Ganges.",
        "East": "In Odisha, 'Boita Bandana' involves floating toy boats in water bodies to celebrate the state's ancient maritime trading history.",
        "West": "The Pushkar Camel Fair reaches its peak as pilgrims bathe in the holy lake and participate in grand temple aartis.",
        "Central": "Temples are decorated with 'Deepmalas' (towers of light), and devotees perform 'Tulsi Vivah' to conclude the wedding season start.",
        "South": "Known as 'Karthigai Deepam' in Tamil Nadu; houses and streets are illuminated with rows of oil lamps and a massive fire is lit atop hills."
      },
    },
    {
      "Name": "Basant Panchami",
      "Regions": ["North", "East", "Central", "West"],
      "History": "Dedicated to Saraswati, the Goddess of Knowledge. It marks the arrival of Spring and the start of the 40-day countdown to Holi.",
      "Significance": "Yellow is the sacred color, representing mustard crops and solar energy. It is the most auspicious day for 'Vidya-Arambha' (starting education).",
      "RegionalRituals": {
        "East": "In Bengal, Saraswati Puja involves students placing books at the feet of the Goddess. People wear yellow and eat yellow-colored sweets.",
        "North": "Yellow clothes are worn, and saffron rice is prepared. Kite flying is a major competitive tradition in Punjab and Haryana.",
        "Central": "Temples of learning are decorated with yellow flowers, and children are encouraged to write their first alphabets in a ritual called 'Akshar Abhyasam'.",
        "West": "In Rajasthan and Gujarat, the spring energy is celebrated with folk music and the worship of tools and instruments of art."
      },
    },
    {
      "Name": "Hornbill Festival",
      "Regions": ["East"],
      "History": "Organized by Nagaland to encourage inter-tribal interaction and promote heritage. Named after the bird central to Naga folklore.",
      "Significance": "Known as the 'Festival of Festivals,' it preserves the traditions of 16 major tribes and provides a platform for indigenous pride.",
      "RegionalRituals": {
        "East": "Held at Kisama Heritage Village, each tribe showcases 'Morungs' (huts), war dances, and the famous 'Chili Eating Competition'."
      },
    },
    {
      "Name": "Bathukamma",
      "Regions": ["South", "Central"],
      "History": "A floral festival where women pray for Goddess Gauri to 'wake up' after a battle, using medicinal flowers to purify water bodies.",
      "Significance": "Celebrates the relationship between earth and water. It is a symbol of Telangana’s cultural identity and women's empowerment.",
      "RegionalRituals": {
        "South": "Women arrange flowers in seven concentric layers. They dance in circles around the 'Bathukamma' before immersing it in lakes.",
        "Central": "In the border regions of Maharashtra and Chhattisgarh, Telugu-speaking communities celebrate with floral arrangements and folk singing."
      },
    },
    {
      "Name": "Puthandu",
      "Regions": ["South"],
      "History": "The Tamil New Year marking Brahma's creation of the universe. It often coincides with the marriage of Meenakshi and Sundareswarar.",
      "Significance": "Celebrates new beginnings. Viewing auspicious items (Mangala Kaatchi) first thing in the morning ensures a year of prosperity.",
      "RegionalRituals": {
        "South": "A tray of gold, fruits, and a mirror is seen upon waking. 'Mangai-pachadi' is eaten to represent life's mixed tastes (sweet, sour, bitter)."
      },
    },
    {
      "Name": "Vishu",
      "Regions": ["South"],
      "History": "The astronomical New Year in Kerala. Its origins are linked to the return of the Sun God after the defeat of the demon Ravana.",
      "Significance": "Signifies the spring equinox. The 'Vishukkani' (first sight) is believed to determine the luck and fortune of the entire year.",
      "RegionalRituals": {
        "South": "The 'Vishukkani' arrangement of gold, flowers, and lamps is viewed at dawn. Elders give 'Vishu Kaineetam' (money) as a blessing to children."
      },
    },
    {
      "Name": "Poila Baisakh",
      "Regions": ["East"],
      "History": "The Bengali New Year originating from Akbar's 'Bangabda' calendar, created to sync tax collection with the harvest cycle.",
      "Significance": "A day of 'Nobo Borsho' and cultural pride. Businesses perform 'Haal Khata'—opening new ledgers to signify a fresh financial start.",
      "RegionalRituals": {
        "East": "Grand 'Mangal Shobhajatra' processions feature colorful masks. Families enjoy 'Panta Ilish' and visit temples for blessings."
      },
    },
    {
      "Name": "Bhai Dooj",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Commemorates Lord Yama visiting his sister Yamuna. Yama declared that any brother receiving a tilak from his sister today would escape untimely death.",
      "Significance": "Reinforces the sibling bond. Unlike Rakhi, it focuses on the sister's prayers for her brother’s longevity and success in life.",
      "RegionalRituals": {
        "North": "Sisters apply a vermilion tilak and offer dry coconut. Brothers give gifts as a token of love and lifelong support.",
        "East": "Known as 'Bhai Phonta'; sisters apply sandalwood paste while chanting mantras to ward off the 'thorns' of the brother's life.",
        "West": "In Maharashtra, it is 'Bhau Beej'. Brothers sit on a square floor design (Aipan) while sisters perform an aarti and share sweets.",
        "Central": "Sisters perform a traditional ceremony involving the lighting of a lamp and applying a tilak made of yogurt and rice for prosperity.",
        "South": "Known as 'Yama Dwitiya'; families gather for a grand meal, and sisters perform rituals to pray for the well-being of their brothers."
      },
    },
    {
      "Name": "Good Friday and Easter",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Good Friday marks the crucifixion of Jesus Christ, while Easter Sunday celebrates his Resurrection three days later.",
      "Significance": "Good Friday is a day of solemnity and penance. Easter is a joyous celebration of hope and victory over death, representing salvation.",
      "RegionalRituals": {
        "North": "Churches in Delhi and Shimla hold the 'Way of the Cross' on Friday, followed by festive Easter sunrise services and community lunches.",
        "South": "In Kerala and Goa, solemn processions are held on Friday. Easter is celebrated with 'Easter Eggs' and grand feasts featuring traditional roasts.",
        "East": "Communities in the Northeast and Kolkata hold choir performances and candle-lit vigils, sharing traditional cakes and Easter buns.",
        "West": "Mumbai's historic churches host midnight mass. Families decorate homes with eggs and lilies to symbolize new life and purity.",
        "Central": "Solemn prayer meetings are held on Friday, while Sunday is marked by joyful church gatherings and distributing sweets to the community."
      },
    },
    {
      "Name": "Hola Mohalla",
      "Regions": ["North", "Central"],
      "History": "Started by Guru Gobind Singh Ji in 1701, it transformed the traditional Holi festival into a day for Sikhs to demonstrate martial skills and ensure spiritual and physical readiness.",
      "Significance": "Meaning 'Mock Fight,' it is a festival of valor and discipline. It reminds the community that a spiritual person (Sant) must also be a warrior (Sipahi) to defend the weak.",
      "RegionalRituals": {
        "North": "Features displays of 'Gatka' (martial arts), tent pegging, and horse riding at Anandpur Sahib. Nihang Sikhs lead grand processions in traditional blue attire.",
        "Central": "Sikh communities in Gwalior and Indore organize martial arts demonstrations and massive community kitchens (Langar) to celebrate the spirit of the Khalsa."
      },
    },
    
    {
      "Name": "Raja Parba",
      "Regions": ["East"],
      "History": "A unique three-day festival in Odisha celebrating Bhudevi (Mother Earth). It honors the fertility of the earth and the celebration of womanhood.",
      "Significance": "A rare traditional festival celebrating menstruation as a symbol of life. It is a rest period for the Earth where all agricultural work is suspended to show respect for nature's cycles.",
      "RegionalRituals": {
        "East": "Women play on decorated 'Raja Doli' (swings), wear new clothes, and apply 'Alata' to their feet. A special steamed cake called 'Poda Pitha' is prepared and shared."
      },
    },
    {
      "Name": "Hemis Festival",
      "Regions": ["North"],
      "History": "Held at Ladakh's largest monastery, it celebrates the birth of Guru Padmasambhava, the Indian master who brought Vajrayana Buddhism to the Himalayas.",
      "Significance": "Represents the victory of Buddhism over dark spirits. It is a vibrant display of Tibetan culture where locals receive spiritual merit and blessings for the year.",
      "RegionalRituals": {
        "North": "The highlight is the 'Cham Dance'—masked dances by monks in silk robes. Giant 'Thangka' paintings are unfurled, accompanied by the sound of cymbals and long horns."
      },
    },
    {
      "Name": "Karthigai Deepam",
      "Regions": ["South"],
      "History": "One of the oldest Tamil festivals, marking the occasion when Lord Shiva appeared as an infinite pillar of fire to settle a dispute between Brahma and Vishnu.",
      "Significance": "The festival of 'infinite light.' It signifies the removal of the ego's darkness through the light of wisdom. Lighting lamps welcomes the divine into the home and soul.",
      "RegionalRituals": {
        "South": "Homes are decorated with rows of 'Agal Vilakku' (oil lamps). A massive 'Mahadeepam' is lit atop the Tiruvannamalai hill, visible for miles across the region."
      },
    },
    {
      "Name": "Ambubachi Mela",
      "Regions": ["East"],
      "History": "Held at the Kamakhya Temple in Assam, it marks the annual menstruation cycle of the Goddess. It is a vital Tantric festival attracting thousands of practitioners.",
      "Significance": "Celebrates the creative power of the universe and breaks social taboos surrounding menstruation by treating it as a sacred event of divine energy and fertility.",
      "RegionalRituals": {
        "East": "The temple closes for three days while the Earth 'rests.' Upon reopening, devotees receive 'Raktabastra' (red cloth) as a highly auspicious blessing."
      },
    },
    {
      "Name": "Janmashtami",
      "Regions": ["North", "South", "East", "West", "Central"],
      "History": "Marks the birth of Lord Krishna in Mathura. Traditions are centered around the Bhagavata Purana, narrating his miraculous birth and his journey to Gokul.",
      "Significance": "Symbolizes the victory of Dharma over Adharma. It is a day of profound spiritual joy, representing the arrival of divine love and wisdom to guide humanity.",
      "RegionalRituals": {
        "North": "Vrindavan and Mathura host 'Rasa Lila' plays. Devotees fast until midnight and rock 'Ladoo Gopal' (infant Krishna) idols in decorated cradles.",
        "West": "The 'Dahi Handi' tradition in Maharashtra involves human pyramids breaking pots of curd suspended high in the air to mimic Krishna's childhood antics.",
        "South": "Tiny footprints (Kolam) are drawn with rice flour from the front door to the puja room, symbolically welcoming infant Krishna into the home.",
        "East": "Celebrated with Kirtans and offerings of milk-based sweets. In Manipur, classical 'Raas Leela' dance performances are a major spiritual highlight.",
        "Central": "Grand temple decorations in Gwalior and Indore. 'Matki Phod' competitions are held in public squares, accompanied by community singing and midnight aartis."
      },
    },
  ];

  // 2. OPTIMIZATION: Start all 'get' requests at the same time (Parallel)
  // This prevents the "One-by-One" waiting lag
  List<Future<DocumentSnapshot>> checkTasks = festivalList.map((f) {
    return festivals.doc(f['Name']).get();
  }).toList();

  // Wait for all checks to finish together
  List<DocumentSnapshot> snapshots = await Future.wait(checkTasks);

  WriteBatch batch = FirebaseFirestore.instance.batch();
  int count = 0;

  // 3. Loop through snapshots and only add missing ones to the batch
  for (int i = 0; i < festivalList.length; i++) {
    if (!snapshots[i].exists) {
      DocumentReference docRef = festivals.doc(festivalList[i]['Name']);
      batch.set(docRef, festivalList[i]);
      count++;
    }
  }

  // 4. Final Commit: Send all new data in one single network call
  if (count > 0)  await batch.commit();
}