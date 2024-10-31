/**
 * @author Timothy Sinard
 *
 */
public class BetterInteger {

    public static final Integer MAX = 2147483647;
    public static final Integer MIN = -2147483647;
    public static Integer valueOf(Object obj) {
        return valueOf(obj, false);
    }

    public static Integer parse(Object obj, Boolean zeroNull) {
        String str = BetterString.valueOf(obj);
        Integer result = null;
        if (str != null) {
            List<String> sections = str.split(' ');
            for (Integer i = 0; i < sections.size(); i++) {
                Integer asInt = BetterInteger.valueOf(sections[i], false);
                if (asInt != null) {
                    result = asInt;
                    break;
                }
            }
        }
        result = result == null ? textToNumber(str) : result;
        return result == null && zeroNull ? 0 : result;
    }

    public static Integer valueOf(Object obj, Boolean zeroNull) {
        Integer result = zeroNull ? 0 : null;
        if (obj != null) {
            String str = String.valueOf(obj);
            try {
                if (str.containsIgnoreCase('E')) {
                    str = Decimal.valueOf(str).toPlainString();
                }
                str = str
                    .replaceAll(',', '')
                    .replaceAll(' ', '')
                    .split('\\.')[0];

                result = Integer.valueOf(str);
            } catch (System.TypeException te) {
            }
        }
        return result;
    }

    private static final Map<String, Integer> WORD_TO_NUMBER_MAP = new Map<String, Integer>{
        'zero' => 0, 'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4,
        'five' => 5, 'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9,
        'ten' => 10, 'eleven' => 11, 'twelve' => 12, 'thirteen' => 13, 'fourteen' => 14,
        'fifteen' => 15, 'sixteen' => 16, 'seventeen' => 17, 'eighteen' => 18, 'nineteen' => 19,
        'twenty' => 20, 'thirty' => 30, 'forty' => 40, 'fifty' => 50,
        'sixty' => 60, 'seventy' => 70, 'eighty' => 80, 'ninety' => 90
    };

    private static final Map<String, Integer> MULTIPLIER_MAP = new Map<String, Integer>{
        'hundred' => 100, 'thousand' => 1000, 'million' => 1000000, 'billion' => 1000000000
    };

    public static Integer textToNumber(String words) {
        words = words == null ? null : words.trim().toLowerCase();
        if (words == null || words == '') {
            return null;
        }
        Integer result = null;
        Integer currentNumber = 0;

        List<String> wordList = words.split('\\s+');

        Boolean isNegative = false;
        for (String word : wordList) {
            if (word.equals('and')) {
                continue;
            }
            if (word.equals('negative')) {
                isNegative = true;
            } else if (WORD_TO_NUMBER_MAP.containsKey(word)) {
                currentNumber += WORD_TO_NUMBER_MAP.get(word);
                result = result == null ? 0 : result;
            } else if (MULTIPLIER_MAP.containsKey(word) && result != null) {
                currentNumber = currentNumber == null ? 0 : currentNumber;
                currentNumber *= MULTIPLIER_MAP.get(word);
                result += currentNumber;
                currentNumber = 0;
            }
        }
        if(result != null) {
            result += currentNumber;
            result = isNegative ? result * -1 : result;
        }
        return result;
    }
}