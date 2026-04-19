import SwiftUI

enum CosmicElement: String, CaseIterable {
    case fire = "Fire"
    case earth = "Earth"
    case air = "Air"
    case water = "Water"

    var color: Color {
        switch self {
        case .fire:  return Color(hex: "C05050")
        case .earth: return Color.sajuTint
        case .air:   return Color.textSecondary
        case .water: return Color.astrologyTint
        }
    }

    var emoji: String {
        switch self {
        case .fire: return "🔥"
        case .earth: return "🌿"
        case .air: return "💨"
        case .water: return "💧"
        }
    }
}

struct ZodiacSign: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let emoji: String
    let dateRange: String
    let element: CosmicElement
    let rulingPlanet: String
    let traits: [String]
    let dailyFortunes: [String]
    let monthlyFortunes: [String]
    let yearlyFortunes: [String]
}

// MARK: - Zodiac Data
enum ZodiacData {
    static let allSigns: [ZodiacSign] = [
        aries, taurus, gemini, cancer, leo, virgo,
        libra, scorpio, sagittarius, capricorn, aquarius, pisces
    ]

    static let aries = ZodiacSign(
        name: "Aries", symbol: "♈", emoji: "🐏",
        dateRange: "Mar 21 – Apr 19",
        element: .fire, rulingPlanet: "Mars",
        traits: ["Courageous", "Pioneering", "Impulsive", "Passionate"],
        dailyFortunes: [
            "The axis of your world tilts slightly today — an old door closes with a resonance you will feel in your chest. Do not mourn the passage. What the cosmos removes, it removes with purpose. By evening, the silence where that chapter lived will feel less like emptiness and more like space.",
            "Mars fires its energy through you like a current today. Whatever has been stagnant will suddenly require your attention with urgent force. Do not hesitate — your instincts are calibrated precisely to the moment. Move now; reflect later. The window is open.",
            "A confrontation you have been circling for weeks may finally arrive today, and you will find it less terrible than your avoidance suggested. Aries does not fear the fire — Aries is the fire. Walk into the conversation and let your honesty do its work.",
            "Creative energy surges through your entire being before noon. The project you have been half-beginning and half-abandoning is ready now for your full commitment. The hesitation was preparation. The preparation is complete.",
            "Someone in your orbit is watching you more closely than you know, drawing courage from how you navigate difficulty. Your fearlessness today is not just for you — it is the light by which others are steering their own ships.",
            "The pace you set today will feel faster than everyone around you, and that is appropriate. You are operating in a different gear. Maintain your velocity, but pause once to ensure you have not left something important behind.",
            "An unexpected alliance forms today around a shared goal. The person you thought was your opposite turns out to share your deepest value. Collaboration with this one will accelerate what would have taken you months alone.",
            "Financial intuition is sharp today. A decision about resources that has felt paralysing suddenly clarifies. The number makes sense; the direction becomes obvious. Act on this clarity before the analytical mind has a chance to complicate it.",
            "Your body knows something your mind is still processing. Pay attention to physical sensations today — tension in the jaw, a flutter in the solar plexus, the quality of your breath. The somatic system is reading the situation accurately.",
            "The universe is asking you to be patient today, which, for Aries, is an act of genuine heroism. The outcome you want is forming. Pushing it now would only disturb the formation. Breathe. The arrival is close.",
            "A bold move you made in the past is paying dividends now in ways you did not predict. The courage to act without guarantee has compounded over time into something real and lasting. This is how Aries changes the world.",
            "Today asks you to be the first — to say the thing no one else will say, to start the thing no one else has started, to go where no one has gone yet. This is your natural gift. The trailhead is directly in front of you."
        ],
        monthlyFortunes: [
            "This month, Mars — your ruling planet — passes through a sector of your chart that governs long-range vision and distant horizons. A project that has been building in your imagination for longer than you care to admit is finally aligning with practical possibility. The energy available to you now is ferocious and clear. Use it to launch, not to prepare for launching. The preparation phase is over.",
            "Relationships come sharply into focus this month. A dynamic that has been out of balance is demanding honest renegotiation, and Aries' directness will be both the problem and the solution. Say what is true with warmth rather than force, and what needs to shift will shift. What cannot handle your honesty was not built to last.",
            "A financial opportunity arrives mid-month that may look small but carries the seed of something substantial. Aries often overlooks the slow-growing plant in favour of the fast-burning flame. This month, cultivate the slow plant.",
            "Professional recognition arrives — perhaps not in the form you expected, but in a form that proves your consistent effort has been noticed. The mountain is not yet climbed, but the base camp is established, and the path upward is finally visible.",
            "A crisis of confidence may visit you briefly in the first week, which is unusual for your sign. Treat it as data rather than verdict. The doubt is pointing at something that genuinely needs refining. Refine it, and then proceed with the full force of your native courage."
        ],
        yearlyFortunes: [
            "This is a year of genuine pioneering for Aries. The cycles of preparation that have preceded this moment have been unusually long, and the frustration you have felt at the slowness of your own growth has been proportional to the size of what is being readied. What launches this year carries the accumulated force of everything you have been building. The leap, when you finally take it, will be extraordinary.",
            "Saturn's long transit through your foundational sector is nearing completion, and this year you will begin to feel the solidity of what that difficult period was constructing. The structures are real. The foundations hold. Now the building rises.",
            "A year of deep personal transformation disguised as external activity. Every encounter, every project, every challenge this year is a mirror being held up to a specific aspect of your core self. What you build outwardly is secondary to what you are being shown within."
        ]
    )

    static let taurus = ZodiacSign(
        name: "Taurus", symbol: "♉", emoji: "🐂",
        dateRange: "Apr 20 – May 20",
        element: .earth, rulingPlanet: "Venus",
        traits: ["Patient", "Reliable", "Sensual", "Stubborn"],
        dailyFortunes: [
            "Venus illuminates your senses today with unusual precision — the quality of light through a window, the exact rightness of a particular piece of music, the way someone smells of home. Let beauty do its work on you. This receptivity is not indulgence but replenishment.",
            "A financial situation that has felt ambiguous begins to clarify today. The picture is not yet complete, but enough of it is visible to make a confident next move. Taurus at its best trusts the tangible. Trust what you can see and verify.",
            "Someone is about to change their mind about something they have been adamant about, and the shift will create an opportunity you were not expecting. Stay alert but unhurried. The right response will be obvious when the moment arrives.",
            "Your body is communicating something important today. A persistent tension, a craving for a specific kind of nourishment, an unusual desire for sleep — these are not inconveniences but instructions. The body knows the prescription.",
            "An old creative project asks to be reconsidered. Something you set aside out of frustration was actually closer to finished than it appeared. The fresh eyes of today's perspective will show you the one thing that was missing.",
            "The quality of your patience is being tested today, and it will not break. Taurus' steadiness is not the stillness of the unmoved but the groundedness of one who knows that good things take the time they take. You are right to hold.",
            "A connection from the past re-emerges — not to restart what ended, but to offer a piece of closure you did not know you needed. Receive this gracefully. The river does not flow backward, but it can bring things downstream.",
            "Material security is the focus today, and the anxiety about it is greater than the actual risk warrants. Count what you actually have rather than what you fear losing. The numbers are better than the fear says.",
            "You are being asked to be flexible about something you have decided is fixed. This discomfort is productive. The stubbornness that serves you so well in many contexts is, in this one instance, the obstacle. Release one position and see what moves.",
            "A simple act of beauty — cooking something from scratch, tending a plant, arranging a space — will restore more of your equilibrium today than any amount of planning or problem-solving. Taurus is healed by the tangible.",
            "Someone close is about to share something vulnerable and difficult. Your capacity to listen without trying to fix, to hold space without filling it with advice, is exactly what will be needed. Your steadiness is the gift.",
            "The long effort is paying off today in a small but unmistakable way. A result arrives that confirms the direction was correct all along. Take the quiet satisfaction of being proved right and let it sustain you for the next phase."
        ],
        monthlyFortunes: [
            "Venus moves into a favorable alignment with your chart this month, and the material world responds by becoming more cooperative. Financial decisions made in the first two weeks carry unusual clarity and favorable outcomes. Taurus does best when it trusts its own assessment of value over others' opinions. Trust it now.",
            "A creative project reaches a critical threshold this month. The work that has been accumulating without apparent form suddenly coheres into something recognisable. The patience of the past months was not wasted — it was the waiting required for the form to find itself.",
            "A relationship enters a deeper phase. What was pleasant and comfortable is becoming genuinely intimate, and the vulnerability required for this depth may feel uncomfortable to Taurus, who prefers to build slowly. The speed of this deepening is appropriate. Let it happen.",
            "A professional situation demands more flexibility than you prefer, and the discomfort is real. But the outcome of navigating this gracefully is the kind of long-term stability that Taurus values most. The temporary bending enables the permanent standing.",
            "Physical wellbeing requires attention this month. The body is asking for rhythm — regular sleep, consistent nourishment, more time outdoors. Taurus is at its most powerful when embodied and grounded. Return to the physical basics."
        ],
        yearlyFortunes: [
            "This year, Uranus continues its long occupation of your sign, and the disruptions to your carefully constructed stability are not finished. But you are learning something extraordinary: that your actual security comes not from external circumstances but from the unshakeable quality of your presence within yourself. What the upheavals are teaching is the one thing they can never take.",
            "A year of slow, deep, fundamental growth. The changes are happening at the root level, which means they are not visible yet — but by year's end, the tree that has been growing underground will push through the surface. Trust the invisible process.",
            "Venus, your ruler, forms a series of exceptional configurations this year that open the doors of abundance in several areas simultaneously. The key is to be genuinely present for what arrives rather than planning for what you think should arrive. The cosmos is more creative than your expectations."
        ]
    )

    static let gemini = ZodiacSign(
        name: "Gemini", symbol: "♊", emoji: "👥",
        dateRange: "May 21 – Jun 20",
        element: .air, rulingPlanet: "Mercury",
        traits: ["Curious", "Adaptable", "Witty", "Inconsistent"],
        dailyFortunes: [
            "Mercury sharpens your already keen mind to a remarkable edge today. A conversation you enter casually will reveal an idea that reshapes your understanding of something fundamental. Stay in the dialogue — the breakthrough is not in the first exchange but in the third.",
            "Two competing impulses are pulling in opposite directions, and rather than trying to resolve the tension, try inhabiting both simultaneously. Gemini's gift is the ability to hold apparent contradictions without needing to collapse them. The synthesis will arrive on its own.",
            "A message arrives that requires a response of genuine nuance — not a quick reply but a considered one. Take the time. The relationship on the other end deserves your full articulation, not your first draft.",
            "Information you receive today is only half the picture. Your instinct will tell you this. Follow up, ask the secondary question, look at the secondary source. The full picture changes the decision.",
            "Your social energy is electrifying today, and people will be drawn to your particular wavelength. Let the connections form without forcing them toward utility. Sometimes relationships are planted today to be harvested in a season you cannot currently see.",
            "A creative idea arrives with such force that it interrupts whatever you were doing. Note it immediately. Gemini's inspirations arrive and depart quickly; the ones that interrupt are the ones worth pursuing.",
            "The restlessness you are feeling is not a sign that something is wrong but that something is ready. You are outgrowing a phase. The discomfort of the old skin is the signal that the new one is already forming underneath.",
            "Someone underestimates your depth today, and you have the choice of correcting them or allowing the misperception to stand as a kind of protection. The most valuable parts of you are not on display for everyone.",
            "A practical matter — admin, logistics, something that has been in the background — comes to the front today and actually needs your attention. Deal with it now and free the mental space it has been occupying.",
            "Your intuition about a person is more accurate than the evidence currently supports. Trust it anyway. Gemini's antennae pick up frequencies that the analytical mind processes later.",
            "A piece of writing, a conversation, or a presentation has the potential to shift something significant today. The words are in you. The moment is now. Say the precise thing and watch the room reorganise around it.",
            "The twin nature of your sign is a gift today: you can hold the perspective of two entirely different people simultaneously, and this double vision allows you to navigate a complicated situation with unusual grace."
        ],
        monthlyFortunes: [
            "Mercury, your ruler, stations direct this month after a retrograde period, and the blocked communications, stalled negotiations, and tangled plans begin to move with sudden velocity. The breakthrough you have been waiting for arrives not as a dramatic moment but as a quiet clearing — you simply find that the obstacle is no longer there.",
            "A relationship enters an unexpectedly serious phase this month. The lightness that characterises your social style has deepened into genuine intimacy, and while this may feel unfamiliar, it is precisely what this connection was always meant to become. Let the depth happen.",
            "A professional opportunity arrives from an unexpected direction this month. The project, role, or collaboration does not look like what you imagined success would look like — but it carries the substance of everything you have been building toward. Recognise it.",
            "Mental restlessness reaches a peak mid-month and demands an outlet. Channel it into writing, learning, or a creative project rather than into scattered social activity. The intelligence needs a focused container to do its best work.",
            "Financial instability from the previous months begins to stabilise. A decision about resources you have been delaying can now be made with sufficient information. The picture is clear enough. Decide."
        ],
        yearlyFortunes: [
            "This is a year in which the breadth of Gemini's interests finally finds a unifying thread. You have been collecting experiences, skills, and connections across wildly different domains, and this year the pattern reveals itself. The synthesis is remarkable and will surprise even you with its coherence.",
            "A year of important communication — written and spoken, public and private. The words you put into the world this year carry unusual weight and reach further than you expect. Curate them. Not everything needs to be said, but what you say will matter.",
            "Jupiter's expansive influence opens the doors of learning and travel this year in ways that transform your understanding of your own life. The perspective gained from encountering the truly unfamiliar reorganises what you thought you already knew."
        ]
    )

    static let cancer = ZodiacSign(
        name: "Cancer", symbol: "♋", emoji: "🦀",
        dateRange: "Jun 21 – Jul 22",
        element: .water, rulingPlanet: "Moon",
        traits: ["Intuitive", "Nurturing", "Protective", "Moody"],
        dailyFortunes: [
            "The moon — your ruler — is speaking to you today through the medium of feeling, and what it is saying is precise even if not immediately translatable into words. Do not rush the decoding. Sit with the sensation. The meaning will arrive in its own time, and it will be worth waiting for.",
            "Home and family occupy the centre of your attention today, and what appears to be a minor domestic concern is actually a signal about a deeper need that has gone unaddressed. Tend to the small thing and you will find the larger thing simultaneously resolved.",
            "Your empathy is operating at unusual depth today, and you will feel others' emotional states with uncomfortable acuity. This is a gift and a vulnerability in equal measure. Choose your company carefully, and make sure you know which feelings are yours.",
            "A creative impulse that has been bubbling beneath the surface for weeks is ready to surface. The form is not yet clear — that is fine. Begin without knowing the shape. Cancer creates from feeling outward toward form, not from form inward toward feeling.",
            "An old wound is asking for acknowledgment today. Not reopening, not reliving — simply acknowledging. A short, honest conversation with yourself about what happened and what it cost you will free more energy than you expect.",
            "Someone you love is struggling in a way they have not yet found words for. Your emotional radar has already picked up the signal. Reach out simply — a message, a call, a question with no agenda. Your presence is the medicine.",
            "The desire to protect those you love may cause you to overextend today. Before giving more of yourself, check that what is inside the shell is not already depleted. You cannot pour from an empty vessel, and those you love need your wholeness more than your sacrifice.",
            "A financial matter that has been handled with too much emotion can now be approached with more clarity. The feelings about money are valid, but the decision must be made with both the heart and the practical mind working in concert.",
            "Intuition about a professional situation is extremely sharp today. Trust what you know without being able to say how you know it. Cancer's non-linear intelligence regularly outpaces the analytical approaches of colleagues. Act on what you sense.",
            "A memory surfaces today with unexpected poignancy — not to be dwelt in but to show you something about the thread that connects past and present. The reminder is a gift from an earlier version of yourself.",
            "The need for solitude is real today and should not be reframed as antisocial behaviour. Cancer needs quiet tidal pools as much as open ocean. Give yourself the withdrawal, and return replenished.",
            "A difficult conversation that has been postponed is actually ready to happen now. The timing is better than it has been, and the other person is more receptive than you believe. Cancer's timing instinct rarely lies."
        ],
        monthlyFortunes: [
            "The full moon illuminates your emotional landscape this month with unusual clarity, and what it reveals has been there for some time — simply unseen. A relationship pattern, a recurring feeling, a way of protecting yourself that is simultaneously the thing keeping the very connection you want at a distance. Seeing it is half the work.",
            "Career and public life come into focus this month, and Cancer may feel some discomfort stepping into a more visible role. But what you have built in the private domain — the depth of your emotional intelligence, the quality of your care — is precisely what is needed in the wider arena. Your gentleness is not weakness; it is leadership.",
            "Financial matters improve significantly this month, and a decision about home or property may become relevant. Tending to the physical home is deeply aligned with Cancer's wellbeing. If there is something practical you can do to make your living space more nourishing, do it now.",
            "A friendship reaches a new depth this month, crossing from pleasant familiarity into something that resembles genuine soul-kinship. These connections are rare. Receive this one with the full weight it deserves.",
            "Physical wellbeing is closely tied to emotional wellbeing this month — more so than usual. When the body feels off, look first at the emotional environment. What needs to be processed that is instead being stored in the body? Water, movement, and honest expression are the remedies."
        ],
        yearlyFortunes: [
            "This year, a long chapter of internal work reaches its completion, and what was being prepared in the quiet of your own depths is now ready to emerge into the world. The vulnerability of the past years was not weakness — it was the necessary dissolution that precedes a more authentic form. This year, you become more fully yourself.",
            "Home, family, and the question of where you truly belong take centre stage this year. Decisions made about living situations, family relationships, and domestic foundations this year will shape the next decade. Make them from your deepest knowing, not from fear or obligation.",
            "A year of profound emotional intelligence development. What you already know about the human heart is deepened by encounters that challenge your understanding in the most generous way. The wisdom you develop this year becomes a resource for many others."
        ]
    )

    static let leo = ZodiacSign(
        name: "Leo", symbol: "♌", emoji: "🦁",
        dateRange: "Jul 23 – Aug 22",
        element: .fire, rulingPlanet: "Sun",
        traits: ["Generous", "Creative", "Dramatic", "Proud"],
        dailyFortunes: [
            "The Sun — your ruler — illuminates everything it touches today with particular warmth, and you are a natural conductor of this energy. Whatever you direct your attention toward will be touched by your light. Choose the subject of your focus with this in mind.",
            "A creative project is ready for an audience. The perfectionist in you will always find one more thing to refine, but what exists now is already extraordinary. The act of sharing completes the cycle of creation. Show what you have made.",
            "Your generosity is called upon today, and when you give, give from the fullness of what you have rather than from the anxiety of what you might lose. Leo's most powerful gifts are not material but the quality of your full, radiant attention.",
            "Recognition arrives today in a form you did not expect — not the grand applause but a quiet acknowledgment from someone whose opinion you respect deeply. This smaller witness will sustain you longer than the crowd.",
            "A leadership moment arrives. Others are looking to you not because you have the most information but because you have the most coherent connection to what this particular moment requires. Step into the role without waiting for the invitation.",
            "The desire to be seen is healthy and human and entirely appropriate to your nature. Today, be seen not through performance but through genuine self-disclosure. The vulnerability is more radiant than the performance has ever been.",
            "A conflict with someone in your circle may tempt you to assert dominance rather than seek understanding. The lion who listens first will win more completely than the one who roars first. Ask the question before you state the position.",
            "Creative energy is so abundant today that you may not know which project deserves it first. Begin with the most personal one — the one that frightens you slightly because it reveals you most completely.",
            "Your warmth today is a literal resource for people in your life. Someone is quietly struggling and has not found a way to reach out. Your reaching toward them will be received as the relief it is.",
            "Pride may be asking you to maintain a position that has quietly become untenable. The courage to say 'I was wrong' is, for Leo, an act of genuine regality. True kings correct their errors publicly.",
            "A physical vitality is coursing through you today that wants expression. Movement, dance, sport, physical work — give the body what it is asking for and the mind will be sharper for the exchange.",
            "The love you have been offering without visible return is not lost — it has been taking root in ways that are not yet visible. Patient love is the deepest kind, and its harvest is only more extraordinary for being slow."
        ],
        monthlyFortunes: [
            "The Sun's passage through your chart this month illuminates your creative potential with extraordinary clarity. A project that has been building in the private theatre of your imagination is ready to step into the public spotlight. The world is not waiting for you to be ready — it is waiting for what you have been preparing. Now is the moment.",
            "Relationships of all kinds are energised this month by your particular brand of warmth and directness. The connections you invest in now will prove unusually durable. Lead with your heart rather than your expectations, and what forms will exceed what you could have planned.",
            "Professional ambitions receive a significant boost mid-month from an unexpected source of support. Someone with influence in your field has noticed what you have been building. Receive the acknowledgment without diminishing it in false modesty.",
            "A financial decision requires your Leo courage — the courage to claim what you are worth without apology. The undervaluing has gone on long enough. State the number. Hold the position.",
            "Physical health and vitality peak this month, and the energy available is extraordinary. Channel it into creative work and physical expression equally. Leo's wellbeing is inseparable from the act of creating."
        ],
        yearlyFortunes: [
            "This is a year of genuine self-authorship for Leo. The roles you have played for others — the performer, the protector, the generous one — are being examined and, where appropriate, consciously chosen rather than reflexively enacted. What you discover about your authentic motivation will reorganise how you shine.",
            "Jupiter's expansive influence on your creative sector this year opens doors of artistic and professional recognition that have been building toward for years. The key is to lead with what is most personal and most true. The work that comes from the deepest place in you will reach the furthest.",
            "A year of the heart. Love in all its forms — romantic, familial, creative, spiritual — becomes the central theme and the primary teacher. What you learn about your own capacity to love and be loved this year will be the foundation of everything that follows."
        ]
    )

    static let virgo = ZodiacSign(
        name: "Virgo", symbol: "♍", emoji: "🌾",
        dateRange: "Aug 23 – Sep 22",
        element: .earth, rulingPlanet: "Mercury",
        traits: ["Analytical", "Practical", "Modest", "Perfectionist"],
        dailyFortunes: [
            "The discerning eye that is your gift can today be directed toward a system or process that has been running inefficiently. What you notice will be exactly what needs adjusting, and the adjustment is smaller than you feared. Your precision is the solution.",
            "An act of service you perform today — something quiet, practical, and done without expectation of recognition — will have consequences that exceed its apparent size. The small careful thing done with full attention is Virgo's highest form.",
            "The inner critic may be especially vocal today. It has useful information — notice what it points to — but its tone is not the truth of you. Discern the signal from the volume. The critique is often correct; the severity is never warranted.",
            "A health intuition has been forming for several days. Today it becomes clear enough to act on. Make the appointment, adjust the practice, try the remedy. Your body has been sending a precise message; you have received it.",
            "A conversation with a practical focus — logistics, plans, details of execution — reveals an unexpected alignment of values with someone you had considered mainly a functional ally. The connection has more depth than the professional surface showed.",
            "Something you have been overthinking is actually ready to be done. Virgo's analytical capacity is extraordinary, but it can circle a decision until the moment for it has passed. The analysis is complete. The decision is obvious. Act.",
            "Your attention to detail saves something significant today — a mistake averted, an oversight caught, a discrepancy identified before it compounded into a real problem. The careful mind is the right mind for today.",
            "A creative project is calling for your Virgoan precision. Not the perfectionism that delays, but the precision that elevates — the finding of the exactly right word, note, brushstroke, or line. This refinement is the art.",
            "The desire to be of use is strong today. Channel it wisely — toward people and projects that genuinely benefit from your contribution, rather than toward anything that offers the busyness of helping as a substitute for your own unanswered needs.",
            "Financial matters benefit from your natural aptitude for analysis today. A budget reviewed, an expense examined, a contract read carefully — the small practical act of tending to the material details creates real security.",
            "Someone in your life needs not your advice but your presence. Virgo offers help so naturally that it can sometimes miss the moment when all that is needed is a quiet, attentive, non-analytical witness. Be still with them today.",
            "A pattern you have been too close to see suddenly becomes visible today with the clarity of standing back. The perspective shift was necessary. The adjustment it implies is real but manageable. You know what to do."
        ],
        monthlyFortunes: [
            "Mercury, your ruler, casts its sharpest analytical light across your professional sector this month. Systems, processes, and methods that have been running below their potential are suddenly improvable. Your ability to identify what needs refining and then actually refine it is the superpower that will distinguish you this month.",
            "Health and daily practice come into sharp focus this month. The body is communicating through subtle channels — patterns of energy, quality of sleep, the specific hunger for certain kinds of nourishment. Virgo knows better than any other sign how to listen to these signals. Listen now and adjust accordingly.",
            "A relationship that has been characterised by practical utility deepens this month into something warmer and more reciprocal. Virgo often forms its most enduring bonds through the shared work of making things better. This is one of those bonds.",
            "A financial analysis you undertake mid-month reveals something unexpected — either an inefficiency costing more than it appeared, or a small income stream that could be substantially increased with modest effort. Your eye for the overlooked is the asset.",
            "Creative expression asks for your attention this month, and your particular form of it — the meticulous, precise, deeply intentional kind — is exactly what a project in your life has been waiting for. The analytical mind and the creative spirit are not opposites; in Virgo they are partners."
        ],
        yearlyFortunes: [
            "This year, Virgo is being asked to expand its definition of what it means to be useful. The service that has been directed outward — toward others' needs, others' systems, others' wellbeing — is now being directed inward toward your own deepest work. What you build for yourself this year will ultimately be of more service to more people than the careful tending of everything around you.",
            "Saturn's influence on your relationship sector this year is asking for serious evaluation of what your connections are truly built on. The relationships that deepen this year will be those built on genuine respect for each other's intelligence. The ones that do not survive the scrutiny were never adequately rooted.",
            "A year of accumulation and harvest. The careful, consistent work of previous years is beginning to yield returns that even your cautious assessment could not fully anticipate. Trust what is arriving. It was built by your own hands."
        ]
    )

    static let libra = ZodiacSign(
        name: "Libra", symbol: "♎", emoji: "⚖️",
        dateRange: "Sep 23 – Oct 22",
        element: .air, rulingPlanet: "Venus",
        traits: ["Diplomatic", "Charming", "Idealistic", "Indecisive"],
        dailyFortunes: [
            "Venus graces your interactions today with a particular luminosity. The quality of your presence — the way you listen, the care with which you speak, the beauty you bring into every exchange — is operating at its highest frequency. Let people feel it.",
            "A decision that has been suspended in the balance is ready to be made. The scales have been weighing long enough; the evidence will not become more complete. Choose from your deepest values and commit with the full force of your considerable charm.",
            "An aesthetic impulse today — to beautify a space, to create something graceful, to find the more elegant solution — is worth following. Libra's beauty-sense is not superficial but a form of intelligence that recognises the harmony underlying the apparent.",
            "A conflict between two people you care about puts you in the uncomfortable position of the unwilling mediator. Your diplomatic gift makes you uniquely equipped for this, but ensure you are not erasing your own position to keep everyone else comfortable.",
            "The relationship you have been considering in abstract terms — what it is, what it might be, what it requires — is asking for a concrete expression today. A gesture, a conversation, a clear and honest declaration. Beauty without commitment is only decoration.",
            "An injustice you have observed — or experienced — is asking for your voice today. Libra's idealism is not naivety but a refusal to normalise what should not be normal. Your clear articulation of what is unfair is a form of activism.",
            "Intellectual pleasure is high today. A book, a film, a long conversation about ideas — give yourself the luxury of extended engagement with something that stimulates without demanding immediate utility. The replenishment is necessary.",
            "Partnership energy is exceptional today. Decisions made with others rather than for others or by yourself will carry the most creative force. The collaborative idea that emerges in the space between two minds is the one worth pursuing.",
            "Indecision is not a personality flaw but information. Today, examine what the difficulty deciding is pointing to. Often the inability to choose between two options is the signal that neither option is quite right and that a third, better option needs to be created.",
            "Your sense of fairness is extremely sharp today, and it is seeing accurately. What is not right will be visible to you with uncomfortable precision. The question is not whether you see it but whether you will say it.",
            "Beauty arrives today in a form you did not expect — in a conversation, a piece of music heard unexpectedly, a moment of light through a window at the exact right angle. Let it enter. These small arrivals of grace are not coincidences.",
            "A professional collaboration reaches a productive turning point today. The shared vision has become clear enough to act on, and the right person to act on it with has made themselves known. The partnership is ready."
        ],
        monthlyFortunes: [
            "Venus moves through your sign this month, amplifying everything that Libra does naturally — creating beauty, building bridges, finding the harmonious middle path. Relationships of all kinds benefit from this transit, and a connection you have been hoping to deepen becomes ready to receive more of your authentic self.",
            "A professional decision requires the courage to choose rather than to mediate between options. Libra's gift for seeing all sides can, in this instance, become an obstacle. The decision is yours to make, not a committee's. Make it.",
            "Financial partnerships or shared resources come into focus this month. The terms of a joint arrangement may need renegotiation, and Libra's natural diplomacy is the perfect instrument — as long as it includes honest advocacy for your own position.",
            "Creative work flourishes this month under Venus' influence. The aesthetic vision that has been forming in your imagination is ready for execution. The refinement instinct and the action impulse are in rare alignment. Make the beautiful thing.",
            "Social life expands in ways that feel both energising and, at moments, slightly overwhelming. Libra needs one-on-one depth as much as social breadth. Ensure that the quality of connection is not being sacrificed to the quantity."
        ],
        yearlyFortunes: [
            "This is a year in which Libra's deepest challenge — the gap between your vision of harmony and the reality of conflict — is met with the maturity that has been building for years. You will learn this year that true peace is not the absence of disagreement but the presence of respect for what is real on all sides. This is a profound and liberating discovery.",
            "Jupiter's influence on your partnership sector this year brings the kind of collaboration that changes the direction of your professional life. The partner who arrives — or deepens — this year is not a supplement to your efforts but an amplification of them. Receive this fully.",
            "A year of beautiful becoming. The aesthetic, relational, and spiritual dimensions of your life converge this year into something that even your idealistic imagination did not fully anticipate. The harmony you have been working toward is not a destination but a way of being that this year helps you inhabit."
        ]
    )

    static let scorpio = ZodiacSign(
        name: "Scorpio", symbol: "♏", emoji: "🦂",
        dateRange: "Oct 23 – Nov 21",
        element: .water, rulingPlanet: "Pluto",
        traits: ["Intense", "Perceptive", "Secretive", "Determined"],
        dailyFortunes: [
            "Pluto's transformative energy moves through your chart today with particular depth. Something beneath the surface of an ordinary interaction is asking to be acknowledged — a power dynamic, an unspoken truth, a feeling that has been assigned no language. See it clearly.",
            "Your perception today is so acute that you will sense the truth of a situation long before the facts confirm it. This is not paranoia but precision. Trust what your deep sight shows you, and give the evidence time to catch up.",
            "A moment of real intimacy is possible today — the kind where the surface falls away and what remains is the actual truth of two people. You have the courage for this depth. The question is whether the other person does.",
            "The transformation that has been happening underneath your conscious awareness surfaces today as a decision, a feeling, or an encounter. What you are becoming cannot be separated from what you are releasing. They are the same process.",
            "Power dynamics in your professional environment are visible to you today with extraordinary clarity. You see who holds what and why, and you see precisely where you sit within that map. Knowledge is leverage. Use it wisely.",
            "Something must be released today for the next chapter to begin. Scorpio is the sign of radical renewal, but the renewal requires the dying first. What you are being asked to let go of is smaller than the liberation it enables.",
            "A relationship secret — held by you or another — is close to the surface today. The timing of its revelation matters. Today may be the moment, or today may be the moment before the moment. Your instinct will know the difference.",
            "The desire for revenge, justified as it may feel, is a secondary desire. The primary one — to be fully seen, genuinely acknowledged, or simply respected — is the one worth attending to. Address the primary need directly.",
            "Financial instincts are very strong today. The sense that a particular investment, expense, or financial decision is right or wrong is based on information you have absorbed subliminally. Act on this instinct after examining its basis.",
            "A creative work with dark or transformative themes is asking for your full, unflinching attention. Scorpio's art does not shy from the difficult. The willingness to look at what others look away from is what gives your work its extraordinary resonance.",
            "Someone close is not who they have presented themselves to be. The disillusionment is real and painful. But the clarity is also a gift — you can only deal with what is actually there, not with the performance of it.",
            "Deep healing is available today for a wound you thought was closed. The reopening is not regression — it is the body and psyche returning to a place of incomplete work to finally complete it. Let the process complete."
        ],
        monthlyFortunes: [
            "Pluto continues its slow deep work in your chart, and this month a specific transformation reaches a pivotal moment. What has been churning in the depths surfaces as a clarity that reorganises your understanding of a fundamental aspect of your life. This is not comfortable, but it is exactly right.",
            "An intimate relationship reaches a moment of genuine reckoning. The depth you have been seeking requires a disclosure — of need, of wound, of truth — that feels frighteningly vulnerable. Make it anyway. Scorpio's power is not in its armour but in its willingness to be unmade and remade.",
            "Financial transformation is the theme this month. A situation involving shared resources, debt, or investment requires a thorough examination without the distortion of either fear or wishful thinking. The truth of the numbers will set the next phase in motion.",
            "Professional power is at a peak this month. The strategic intelligence that is your particular gift is operating with unusual precision. An opportunity to reposition yourself in your field requires boldness and timing. Both are available to you now.",
            "The past re-emerges this month in a form that demands a final accounting. An old relationship, an unfinished piece of work, an unresolved feeling — something from the archive of your life is asking to be looked at one more time, completely, and then put to rest."
        ],
        yearlyFortunes: [
            "This is a year of profound regeneration for Scorpio. The death-and-rebirth cycle that is your deepest nature is operating at its full power, and what is being shed this year — old identities, old wounds, old power structures — is making room for something that is genuinely new. You will not recognise yourself at year's end, and you will be grateful.",
            "Pluto's long transit through a sector of your chart governing identity reaches a critical completion point this year. The question of who you truly are, beneath every role you have played and every mask you have worn, has never been clearer. Live from that answer.",
            "A year of profound intimacy and the transformation that intimacy catalyses. The connections that deepen this year go all the way down to where you are most fundamentally yourself. What you discover in the mirror of genuine closeness will be the most important thing you learn this year."
        ]
    )

    static let sagittarius = ZodiacSign(
        name: "Sagittarius", symbol: "♐", emoji: "🏹",
        dateRange: "Nov 22 – Dec 21",
        element: .fire, rulingPlanet: "Jupiter",
        traits: ["Optimistic", "Adventurous", "Philosophical", "Impatient"],
        dailyFortunes: [
            "Jupiter's expansive energy opens a door today that has been closed for longer than seemed reasonable. Walk through it immediately, before the analytical mind has a chance to catalogue all the reasons not to. Sagittarius was born for this exact moment of joyful, reckless arrival.",
            "A philosophical question that has been forming at the back of your mind for weeks crystallises today into something you can articulate and share. The idea is good and its time has arrived. Say it to someone who can receive its implications.",
            "An adventure presents itself in miniature form today — a detour, an unexpected meeting, a conversation that goes somewhere neither party anticipated. Follow the unexpected path. The scheduled one will keep.",
            "Your honesty — characteristically more direct than the situation called for — will today be exactly what someone needed to hear, even if their immediate reaction is surprise. Stand by what you said. It was true.",
            "A journey — literal or figurative — is being planned in the background of your life, and today a crucial detail of the plan becomes clear. The destination is correct. The route is still being discovered.",
            "The restlessness that is your constant companion today indicates not dissatisfaction but readiness. Something in you is prepared for the next level that the current container cannot hold. This is information, not discontent.",
            "Intellectual exploration pulls your attention today toward a subject entirely outside your usual domain. Follow it without needing to justify the relevance. Sagittarius discovers the most important things in the least expected places.",
            "An optimism that might seem unrealistic to others is, in this particular case, actually correct. The situation is better than the cautious assessment suggests. Your positive read of the room is the accurate one.",
            "Freedom is the deep need today, and the form it takes is the willingness to release a commitment that has been kept past its natural end. The loyalty was real. The relationship has evolved beyond its original form. Release it with love.",
            "Teaching energy is high today. Whether formally or in conversation, your capacity to transmit what you understand with energy and enthusiasm is at its peak. Share what you know with someone younger or newer to the path.",
            "A distant connection — geographically, culturally, or philosophically — reaches toward you today with a message or an invitation. Say yes to the unfamiliar. The familiar will always be there when you return.",
            "Your faith in the eventual rightness of things is being tested today by evidence that appears to contradict it. Hold the faith anyway. Sagittarius is the sign that knows, at its core, that the universe is fundamentally benevolent."
        ],
        monthlyFortunes: [
            "Jupiter, your ruling planet, forms an exceptional aspect this month that opens the doors of opportunity with unusual generosity. The challenge for Sagittarius is not to seize every opportunity but to correctly identify which one is the one worth pursuing. Your instinct is the best guide you have. Trust it over the analysis.",
            "A journey — actual or philosophical — opens your world this month in ways that permanently alter your understanding of your own life. The encounter with the genuinely different is Sagittarius' most powerful teacher. Be changed by what you meet.",
            "A relationship requires more honesty than you have been offering, not because you have been deceptive but because you have been tactful beyond what the relationship can afford. Say the full truth with warmth. The relationship can bear it.",
            "Professional ambitions receive an important signal this month about their actual alignment with your deepest values. The success you have been pursuing may look slightly different than what would truly satisfy. The adjustment is not failure — it is refinement.",
            "Financial optimism needs a grounding in practical reality this month. An exciting opportunity deserves genuine scrutiny before commitment. The expansive Jupiter energy that governs your sign can occasionally confuse the large and exciting with the wise and sustainable."
        ],
        yearlyFortunes: [
            "This is a year of Jupiter's homecoming — your ruling planet returns to a sector of your chart it has not occupied for twelve years, and the expansion it catalyses is extraordinary. The vision you have been holding for your life — the one that seemed slightly too large for your current circumstances — is suddenly not too large at all. Live into it.",
            "A year of profound philosophical development. The worldview you have been constructing from experience, reading, travel, and relationship is reaching a synthesis that will be the foundation of everything you do in the next decade. Commit to the understanding that this year makes available.",
            "Adventure calls this year in a form that is genuinely transformative. Not the pleasant adventure of tourism but the deep adventure of encountering the truly other and finding that it changes who you are. Say yes to this call."
        ]
    )

    static let capricorn = ZodiacSign(
        name: "Capricorn", symbol: "♑", emoji: "🐐",
        dateRange: "Dec 22 – Jan 19",
        element: .earth, rulingPlanet: "Saturn",
        traits: ["Ambitious", "Disciplined", "Patient", "Reserved"],
        dailyFortunes: [
            "Saturn's steady discipline is your birthright, and today it is exactly the quality the situation requires. While others look for shortcuts, your willingness to do the work correctly and completely will produce a result that they cannot replicate. The long way is the lasting way.",
            "An ambitious goal that has felt impossibly distant suddenly shows itself to be only three careful steps away. You have been looking at the summit and missing the immediate foothold. Take the next step that is directly in front of you.",
            "The authority you have built through consistent competence is being recognised today in a way that opens a door to a new level of responsibility. Accept it. Capricorn was built for this. The weight of leadership suits you.",
            "A practical problem has a practical solution, and you have known what it is for longer than you have been willing to admit. The hesitation is not about not knowing — it is about the cost of implementing what you know. The cost is real but manageable. Begin.",
            "A relationship benefits today from your rare and underappreciated gift for loyalty. Your steadiness — the quality of being absolutely dependable when everything else is in flux — is someone's entire solid ground today. Let your consistency be felt.",
            "The desire to be respected is as deep and legitimate as any other human need. Today, examine whether you are seeking it from the right sources and in the right ways. The respect you seek from others is built upon the respect you consistently demonstrate for your own values.",
            "An old ambition that you had quietly set aside out of practicality is calling to be reconsidered. The circumstances have changed more than you have updated your assessment. What seemed impossible is less so now.",
            "Financial discipline pays dividends today in a manner that confirms the value of the approach you have maintained during periods when it required real sacrifice. The account reflects the choices. The choices were correct.",
            "A mentor or elder figure has something important to offer today — not just advice but a perspective that comes from having taken the same long road further than you have yet traveled. Ask the question you have been holding. The answer will save you years.",
            "The private ambition — the one you barely admit even to yourself — is closer to achievable than the official, public, more modest goal. Dare to aim at what you actually want rather than the acceptable approximation of it.",
            "Physical endurance is high today. The body that you have been disciplining and maintaining is capable today of more than you will ask of it. Push slightly beyond the comfortable limit and note what is possible.",
            "A reputation built slowly and carefully over years functions today as a form of capital that opens a door that would be closed to someone less established. The investment in doing things correctly was never wasted. The return is arriving."
        ],
        monthlyFortunes: [
            "Saturn, your ruling planet, makes a significant aspect this month to the part of your chart governing long-term goals and public achievement. An ambition you have been working toward for years reaches a milestone that is real and earned. Allow yourself to recognise this arrival without immediately rushing toward the next peak.",
            "A professional relationship deepens this month into something that functions as genuine partnership — the meeting of two complementary forms of competence that produce results neither could alone. Capricorn rarely finds its equal, but this month it may.",
            "Financial strategy benefits from a review this month. The structures that have been serving you are ready for an upgrade. What was appropriate for the previous phase of your life may need refinement for the current one. The practical intelligence you bring to this review is extraordinary.",
            "A private aspiration — the creative or personal project that lives in the drawer beside the practical life — asks for more of your attention this month. The practical and the personal need not be in opposition. Give the internal life its due.",
            "Health and wellbeing ask for attention this month through the medium of chronic tension or low-level depletion. Capricorn's extraordinary endurance can delay the body's call for rest until the call becomes a demand. Respond before the demand arrives."
        ],
        yearlyFortunes: [
            "This is a year in which the patient investment of previous years reaches its full return. The mountain Capricorn has been climbing — steadily, without complaint, with the long view always in sight — reveals its summit as closer than even your disciplined optimism allowed you to believe. The arrival is this year. Prepare for it.",
            "Saturn's final passages through a challenging sector of your chart complete this year, and what emerges from the discipline and constraint of that period is a self that is more genuinely capable, more deeply grounded, and more authentically powerful than what entered it. The hard years produced the extraordinary person.",
            "A year of legacy and lasting contribution. What you build this year — the project completed, the relationship deepened, the institution shaped — will outlast the year itself. Build accordingly. The work done with this intention has a different quality than the work done for immediate reward."
        ]
    )

    static let aquarius = ZodiacSign(
        name: "Aquarius", symbol: "♒", emoji: "🏺",
        dateRange: "Jan 20 – Feb 18",
        element: .air, rulingPlanet: "Uranus",
        traits: ["Innovative", "Humanitarian", "Independent", "Eccentric"],
        dailyFortunes: [
            "Uranus fires an insight through your mind today that is several years ahead of its time. Note it carefully, because the immediate reaction from others will be skepticism, and that skepticism will be wrong. Your relationship with the future is one of your most profound gifts.",
            "A group or community is looking to you today for a vision of what might be possible rather than a defence of what already is. Aquarius sees the potential in the gap between the actual and the ideal. Articulate what you see. The room needs the horizon you can perceive.",
            "The need for independence is at its peak today, and any attempt — by others or by circumstance — to constrain your autonomy will be felt with unusual acuity. This is information: something in your current structure has become a cage. Identify exactly which bar is pressing.",
            "An unexpected act of generosity from someone outside your usual circle reminds you that the world is larger and stranger and kinder than the news would suggest. Receive it. And let it recalibrate your working theory of what people are capable of.",
            "A technological or systems problem has been nagging at the edges of your attention for days. Today, the solution arrives with the sudden completeness that Aquarian intelligence specialises in. The answer was already in you — you were simply loading the algorithm.",
            "The friendship you value most today is the one that challenges your thinking rather than confirms it. Seek out the person who disagrees with you in the most interesting way. The friction is the point.",
            "Humanitarian impulse is strong today. A cause, a situation, a person who is being systematically overlooked is calling for your particular form of advocacy — intelligent, structural, and directed at the system rather than merely the symptom.",
            "A romantic or intimate situation is complicated by your need for space. The need is real and non-negotiable, but its expression can be artful rather than blunt. Communicate what you need without making the other person feel like less.",
            "An original idea deserves originality in its execution. The conventional form for what you want to say will not carry the unconventional content. Find the form that is as unusual as the vision it contains.",
            "The long view is your natural habitat. When everyone around you is panicking about the immediate situation, your ability to see the arc of a longer story is invaluable. Offer this perspective generously today.",
            "A collaboration with someone from a radically different background than your own produces, today, something that neither of you could have reached alone. This is Aquarius at its finest: the synthesis of the genuinely different.",
            "The systems and structures of your daily life are either serving the life you are trying to build or they are not. Today is a good day to assess them with fresh eyes. What worked for a previous version of you may need redesigning for the current one."
        ],
        monthlyFortunes: [
            "Uranus activates a sudden, unexpected shift in your professional landscape this month. What appeared fixed and permanent reveals its underlying instability, and what seemed improbable becomes suddenly possible. Aquarius is built for exactly this kind of disruption — embrace the reorganisation.",
            "A friendship or group affiliation reaches a significant moment of either deepening or conclusion. The relationship that has been surviving on history and habit rather than genuine present resonance is asking the honest question: is this still us? Answer honestly.",
            "An innovative project or idea receives the external validation that moves it from personal vision to shared reality. The reception is more enthusiastic than your characteristic skepticism of others' enthusiasm had prepared you for. Let the response be information.",
            "Financial independence — Aquarius' deep goal — takes a concrete step forward this month through a decision about how you earn and where you direct your resources. The structural shift is practical but has significant implications for freedom.",
            "The tension between your commitment to ideals and the compromises required by actual human situations reaches an important reckoning this month. The lesson is that ideals held rigidly become oppressive. The flexible application of your deepest values is the mature form of Aquarian integrity."
        ],
        yearlyFortunes: [
            "This is a year in which your vision for a better future encounters the practical means of its realisation. Aquarius has always known what should be — this year, the how becomes available. The project, the movement, the structure that brings your most important idea into contact with the world is ready to be built.",
            "Uranus, your ruling planet, makes significant new alignments this year that open entirely unexpected avenues of development. What disrupts this year is disrupting toward something better. Trust the process even when — especially when — it looks like disorder.",
            "A year of profound community and collective impact. The individual work you have been doing in relative isolation connects this year with others who share your deepest commitments, and the resulting collaboration produces something that belongs to the future rather than the present."
        ]
    )

    static let pisces = ZodiacSign(
        name: "Pisces", symbol: "♓", emoji: "🐟",
        dateRange: "Feb 19 – Mar 20",
        element: .water, rulingPlanet: "Neptune",
        traits: ["Empathetic", "Artistic", "Intuitive", "Dreamy"],
        dailyFortunes: [
            "Neptune dissolves the boundaries between your inner world and the outer one today, and what you feel about a situation will be as accurate as any rational analysis. The imagination is not escaping from reality today — it is reading reality in a language that bypasses ordinary comprehension.",
            "A creative impulse arrives today with the character of something received rather than invented. The dream, the image, the musical phrase, the line of a poem — it is already complete; you are simply the conduit. Give it form before it dissolves back into the formless.",
            "The boundary between yourself and others is thinner today than usual. This extraordinary empathy is both your gift and your vulnerability. Choose your environment and company with care, and know that feelings that do not seem to belong to you almost certainly belong to someone near you.",
            "A long-standing confusion about a personal situation resolves today — not through analysis but through a sudden, total knowing that arrives from somewhere beneath the thinking mind. Trust this knowing even if you cannot explain its basis.",
            "The practical and the mystical are not in opposition today — they are working together toward the same end. The most spiritual thing you can do is the most practical: show up, do the work, tend the relationship, keep the commitment.",
            "A spiritual or creative practice that you have been neglecting is asking to be returned to. The absence has left a specific kind of hollow that can only be filled by re-engaging with what connects you to the larger. Go back.",
            "Someone around you is suffering in a way they have not disclosed, and your empathic radar has been picking up the signal for days. You do not need to have the words or the solution. Simply being present — fully, without an agenda — is the gift.",
            "The dream you had last night or the images that have been recurring in your waking mind are not random. The unconscious is communicating through symbol and metaphor what the conscious mind is not yet ready to receive directly. What are the images?",
            "A financial matter requires more practical attention than Pisces naturally enjoys giving it. Today, however, the fog lifts enough for the numbers to become readable. Deal with the practical reality while the clarity is available.",
            "Your art — whatever form it takes — is being called upon today to deal with something true and difficult rather than something beautiful and comfortable. The willingness to make art from the wound is Pisces' most extraordinary and valuable act.",
            "A romantic encounter or connection carries an almost otherworldly quality today — as if the meeting was arranged by something larger than either party. Pisces knows this experience. Let the meeting be what it is, completely.",
            "The compassion you carry for others today is extraordinary, and someone will be transformed by it in a way they may never be able to articulate. The healing that happens in the presence of someone who truly sees you is one of the rarest gifts in the human experience."
        ],
        monthlyFortunes: [
            "Neptune, your ruling planet, deepens its influence on your imagination and spiritual life this month, and the creative or healing work that emerges from this deepening carries unusual power. A piece of work done this month has the quality of something channeled rather than constructed. Allow it to be what it needs to be.",
            "A relationship that exists on the level of soul-recognition — the kind of meeting that feels pre-arranged — arrives or deepens this month. Pisces experiences these connections as sacred, and they are. Honour it as such.",
            "A confusion that has been clouding a practical decision lifts mid-month, and the way forward becomes clear in its simplicity. The solution has been there all along; what was obscuring it was the emotional complexity surrounding it, not the problem itself.",
            "Financial matters benefit from the addition of a practical advisor this month — someone whose clarity and directness can supplement the intuitive approach that comes naturally to Pisces. The combination of your sense of what feels right and their knowledge of what is practically sound is more powerful than either alone.",
            "The spiritual dimension of your life asks for explicit cultivation this month. The busyness and demands of the practical world have been crowding out the practices that replenish Pisces at the deepest level. Make the space. The practical life will not suffer for it — it will improve."
        ],
        yearlyFortunes: [
            "This is a year in which the interior life that is Pisces' deepest home finds expression in the external world in a form that others can receive and be nourished by. The art, the healing, the spiritual work that you have been developing in relative privacy is ready to meet the world that has been waiting for it.",
            "Neptune's long residence in your sign continues to dissolve the boundaries between who you were and who you are becoming. What is being lost is the false self — the accumulated masks of adaptation. What remains is something more luminous and more fundamentally yours than anything you have ever presented to the world.",
            "A year of profound compassion and its fruit: the discovery that genuine love — the kind that asks nothing and gives everything — is not a depletion but a source. What you give from this place returns transformed into something you did not know you needed."
        ]
    )
}
