public with sharing class BetterDatetime {

    public static Datetime max(Datetime d1, Datetime d2) {
        return (d1 != null && d2 == null) || d1 > d2 ? d1 : d2;
    }

    public static Datetime min(Datetime d1, Datetime d2) {
        return (d1 != null && d2 == null) || d1 < d2 ? d1 : d2;
    }

    public static Datetime valueOf(Object value) {
        String asString = BetterString.valueOf(value, true);
        try {
            asString = asString.replace('T', ' ');
            return !String.isEmpty(asString) ? (asString.contains('/') ? Datetime.parse(asString) : Datetime.valueOf(asString)) : null;
        } catch (System.TypeException e) {
            return null;
        }
    }
    public static Boolean isBetween(Datetime toCheck, Datetime lower, Datetime upper) {
        return isBetween(toCheck, lower, true, upper, false);
    }

    public static Boolean isBetween(Datetime toCheck, Datetime lower, Boolean isLowerInclusive, Datetime upper, Boolean isUpperInclusive) {
        return isBetween(toCheck, lower, isLowerInclusive, upper, isUpperInclusive, true);
    }

    public static Boolean isBetween(Datetime toCheck, Datetime lower, Boolean isLowerInclusive, Datetime upper, Boolean isUpperInclusive, Boolean nullIsBoundless) {
        Boolean lowerCheck = isLowerInclusive ? toCheck >= lower : toCheck > lower;
        Boolean upperCheck = isUpperInclusive ? toCheck <= upper : toCheck < upper;
        return (lowerCheck || (nullIsBoundless && lower == null)) && (upperCheck || (nullIsBoundless && upper == null));
    }

    public enum Interval {
        MILLISECONDS, SECONDS, MINUTES, HOURS, DAYS
    }
    public static Decimal difference(Datetime dt1, Datetime dt2, BetterDatetime.Interval interval) {
        Long dt1Long = dt1 == null ? 0 : dt1.getTime();
        Long dt2Long = dt2 == null ? 0 : dt2.getTime();
        Long milliseconds = dt2Long - dt1Long;

        if(interval == BetterDatetime.Interval.MILLISECONDS) {
            return milliseconds;
        }
        Decimal seconds = milliseconds / 1000;
        if(interval == BetterDatetime.Interval.SECONDS) {
            return seconds.setScale(2);
        }
        Decimal minutes = seconds / 60;
        if(interval == BetterDatetime.Interval.MINUTES) {
            return minutes.setScale(2);
        }
        Decimal hours = minutes / 60;
        if(interval == BetterDatetime.Interval.HOURS) {
            return hours.setScale(2);
        }
        Decimal days = hours / 24;
        if(interval == BetterDatetime.Interval.DAYS) {
            return days.setScale(2);
        }
        return milliseconds;
    }

    public static String format(Date d) {
        return Datetime.newInstance(d, Time.newInstance(0,0,0,0)).format('yyyy-MM-dd\'T\'HH:mm:ssXXX');
    }

}