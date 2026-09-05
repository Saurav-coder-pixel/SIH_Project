/**
 * Multilingual NLP / Rule-based hybrid Need Parser.
 * Converts raw user text into structured matching attributes (category, urgency, budget, keywords).
 *
 * CRITICAL RULE: NEVER invents provider IDs, credentials, or candidate records.
 * Only extracts intent attributes from input text.
 */

const CATEGORY_MAP = [
  { category: 'product photography', keywords: ['photography', 'photo', 'photographer', 'sku', 'photoshoot', 'studio', 'picture', 'product photo'] },
  { category: 'electrician', keywords: ['electrician', 'wiring', 'fuse', 'short circuit', 'power cut', 'electrical', 'socket', 'switchboard'] },
  { category: 'plumber', keywords: ['plumber', 'leak', 'pipe', 'tap', 'sink', 'drain', 'plumbing', 'toilet', 'flush'] },
  { category: 'tutor / educator', keywords: ['tutor', 'teacher', 'maths', 'science', 'tuition', 'coaching', 'exam', 'class'] },
  { category: 'event decorator', keywords: ['decorator', 'decoration', 'balloon', 'flower', 'stage', 'party', 'wedding', 'event'] },
  { category: 'doctor / medical', keywords: ['doctor', 'clinic', 'physician', 'health', 'fever', 'medical', 'consultation'] },
  { category: 'chartered accountant', keywords: ['ca', 'tax', 'audit', 'gst', 'accountant', 'income tax', 'filing', 'balance sheet'] },
  { category: 'mechanic', keywords: ['mechanic', 'car repair', 'bike repair', 'servicing', 'engine', 'tyre', 'puncture'] }
];

function parseNeedText(rawText) {
  if (!rawText || typeof rawText !== 'string') {
    return {
      category: 'general service',
      urgency: 'this_week',
      extracted_keywords: [],
      budget_range: null,
      preferred_availability: null
    };
  }

  const textLower = rawText.toLowerCase();

  // 1. Extract Category
  let matchedCategory = 'general service';
  let highestKeywordMatchCount = 0;

  for (const item of CATEGORY_MAP) {
    const matchCount = item.keywords.filter(kw => textLower.includes(kw)).length;
    if (matchCount > highestKeywordMatchCount) {
      highestKeywordMatchCount = matchCount;
      matchedCategory = item.category;
    }
  }

  // 2. Extract Urgency
  let urgency = 'this_week';
  if (textLower.includes('urgent') || textLower.includes('today') || textLower.includes('now') || textLower.includes('asap') || textLower.includes('emergency')) {
    urgency = 'immediate';
  } else if (textLower.includes('this week') || textLower.includes('few days') || textLower.includes('weekend')) {
    urgency = 'this_week';
  } else if (textLower.includes('next month') || textLower.includes('flexible') || textLower.includes('anytime')) {
    urgency = 'flexible';
  }

  // 3. Extract Keywords
  const words = textLower
    .replace(/[^\w\s]/gi, ' ')
    .split(/\s+/)
    .filter(w => w.length > 3 && !['need', 'want', 'looking', 'this', 'that', 'with', 'from', 'have', 'some', 'please'].includes(w));

  const extractedKeywords = Array.from(new Set(words));

  // 4. Extract Budget Range if present
  let budgetRange = null;
  const budgetMatch = textLower.match(/(\d+\s*k?|\$\d+|\b\d+\s*rupees\b|\b\d+\s*inr\b)/i);
  if (budgetMatch) {
    budgetRange = budgetMatch[0];
  }

  return {
    category: matchedCategory,
    urgency,
    extracted_keywords: extractedKeywords,
    budget_range: budgetRange,
    preferred_availability: urgency === 'immediate' ? 'Available Today' : 'Flexible'
  };
}

module.exports = {
  parseNeedText
};
