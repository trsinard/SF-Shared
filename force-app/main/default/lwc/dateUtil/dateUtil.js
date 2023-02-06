const TODAY = (() => {
    let today = new Date();
    today.setHours(0, 0, 0, 0);
    return today;
})();

class DateUtil {

    static daysBetween(d1, d2) {
        return Math.abs(Math.round((d2 - d1) / (1000 * 60 * 60 * 24))) - 1;
    }

    static getNumberOfDaysInMonth(month, year) {
        if (month === 1 || month === 3 || month === 5 || month === 7 || month === 8 || month === 10 || month === 12) {
            return 31;
        }
        if (month === 4 || month === 6 || month === 9 || month === 11) {
            return 30;
        }
        if (month === 2) {
            return DateUtil.isLeapYear(year) ? 29 : 28;
        }
    }

    static isLeapYear(year) {
        return (year % 400) === 0 || (year % 4 === 0 && year % 100 !== 0);
    }

    static getStartDayOfWeek(month, year) {
        let startDay1800 = 3;
        let totalNumberOfDays = DateUtil.getTotalNumberOfDaysSince1800(month, year);
        return (totalNumberOfDays + startDay1800) % 7;
    }

    static getTotalNumberOfDaysSince1800(month, year) {
        let total = 0;
        for (let i = 1800; i < year; i++) {
            total += 365;
            if (this.isLeapYear(i)) {
                total += 1;
            }
        }
        for (let i = 1; i < month; i++) {
            total += DateUtil.getNumberOfDaysInMonth(i, year);
        }
        return total;
    }

    static dayOfWeekToString(theDate) {
        let dayOfWeek;
        theDate = new Date(theDate);
        switch (theDate.getDay()) {
            case 0:
                dayOfWeek = 'Sun';
                break;
            case 1:
                dayOfWeek = 'Mon';
                break;
            case 2:
                dayOfWeek = 'Tue';
                break;
            case 3:
                dayOfWeek = 'Wed';
                break;
            case 4:
                dayOfWeek = 'Thu';
                break;
            case 5:
                dayOfWeek = 'Fri';
                break;
            case 6:
                dayOfWeek = 'Sat';
                break;
            case 7 :
                dayOfWeek = 'Sun';
                break;
        }
        return dayOfWeek;
    }

    static monthToString(num) {
        switch (num) {
            case 1:
                return "January";
            case 2:
                return "February";
            case 3:
                return "March";
            case 4:
                return "April";
            case 5:
                return "May";
            case 6:
                return "June";
            case 7:
                return "July";
            case 8:
                return "August";
            case 9:
                return "September";
            case 10:
                return "October";
            case 11:
                return "November";
            case 12:
                return "December";
            default:
                return '';
        }
    }
}

export {DateUtil, TODAY}