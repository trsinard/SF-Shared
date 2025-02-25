global with sharing class BetterDate {
    global static Date max(Date d1, Date d2) {
        return (d1 != null && d2 == null) || d1 > d2 ? d1 : d2;
    }

    global static Date min(Date d1, Date d2) {
        return (d1 != null && d2 == null) || d1 < d2 ? d1 : d2;
    }

    global static Integer dayOfWeek(Date d1) {
        return Math.mod(Date.newInstance(1900, 1, 7).daysBetween(d1), 7);
    }

    global static String dayOfWeekName(Date d1) {
        return new Map<Integer, String>{
            0 => 'Sunday',
            1 => 'Monday',
            2 => 'Tuesday',
            3 => 'Wednesday',
            4 => 'Thursday',
            5 => 'Friday',
            6 => 'Saturday'
        }.get(dayOfWeek(d1));
    }

    global static Date getStartOfWeek(Date d1) {
        return BetterDate.dayOfWeek(d1) == 0 ? d1.addDays(-6) : d1.toStartOfWeek().addDays(1);
    }

    global static Date valueOf(Object value) {
        String asString = BetterString.valueOf(value, true);
        try {
            asString = asString.contains('T') ? asString.substring(0, asString.indexOf('T')) : asString;
            return !String.isEmpty(asString) ? (asString.contains('/') ? Date.parse(asString) : Date.valueOf(asString)) : null;
        } catch (System.TypeException e) {
            return null;
        }
    }
}