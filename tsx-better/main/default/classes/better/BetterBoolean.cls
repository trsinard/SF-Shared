global with sharing class BetterBoolean {

    global static Boolean valueOf(Object val) {
        List<String> trueOptions = new List<String>{
            '1',
            't',
            'true',
            'yes'
        };
        String asString = BetterString.valueOf(val, true).toLowerCase().trim();
        return Boolean.valueOf(asString) || trueOptions.contains(asString);
    }

    global static Boolean coalesce(Boolean initial, Boolean fallback) {
        return initial == null ? fallback : initial;
    }
}