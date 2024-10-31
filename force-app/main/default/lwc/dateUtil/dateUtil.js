const TODAY = (() => {
    let today = new Date();
    today.setHours(0, 0, 0, 0);
    return today;
})();


class DateUtil {

    static addDays(d1, days) {
        let date = new Date(d1);
        date.setDate(date.getDate() + days);
        return date;
    }

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

    static MONTH_DICTIONARY = [
        {
            label: "January",
            abbreviation: "Jan",
            index: 1
        },{
            label: "February",
            abbreviation: "Feb",
            index: 2
        },{
            label: "March",
            abbreviation: "Mar",
            index: 3
        },{
            label: "April",
            abbreviation: "Apr",
            index: 4
        },{
            label: "May",
            abbreviation: "May",
            index: 5
        },{
            label: "June",
            abbreviation: "Jun",
            index: 6
        },{
            label: "July",
            abbreviation: "Jul",
            index: 7
        },{
            label: "August",
            abbreviation: "Aug",
            index: 8
        },{
            label: "September",
            abbreviation: "Sep",
            index: 9
        },{
            label: "October",
            abbreviation: "Oct",
            index: 10
        },{
            label: "November",
            abbreviation: "Nov",
            index: 11
        },{
            label: "December",
            abbreviation: "Dec",
            index: 12
        }
    ];

    static monthToString(num) {
        return DateUtil.MONTH_DICTIONARY.find(e => e.index === num)?.label ?? "";
    }

    static monthToAbbreviation(num) {
        return DateUtil.MONTH_DICTIONARY.find(e => e.index === num)?.abbreviation ?? "";
    }

    static asUTC(theDate) {
        if (!(typeof theDate?.getUTCFullYear === "function")) {
            theDate = new Date(Date.parse(theDate));
        }
        if (isNaN(theDate)) {
            return null;
        }
        return new Date(theDate.getUTCFullYear(), theDate.getUTCMonth(), theDate.getUTCDate());
    }

    static isValidDate(d) {
        return !isNaN(Date.parse(d));
    }

    // converts 2023-05-12T11:00:00.000Z into an ICS date
    static convertSFDateToICSDate(dateTimeStr) {
        const dateTime = new Date(dateTimeStr);
        const year = dateTime.getUTCFullYear().toString().padStart(4, '0');
        const month = padZero(dateTime.getUTCMonth() + 1);
        const day = padZero(dateTime.getUTCDate());
        const hours = padZero(dateTime.getUTCHours());
        const minutes = padZero(dateTime.getUTCMinutes());
        const seconds = padZero(dateTime.getUTCSeconds());
        return `${year}${month}${day}T${hours}${minutes}${seconds}Z`;
    }

   static calculateElapsedTime(start, end) {
        start = new Date(start);
        end = new Date(end);
        if(start && end) {
            let monthsStart = (start.getFullYear() - 1900) * 12;
            let monthsEnd = (end.getFullYear() - 1900) * 12;

            let monthsStartDate = new Date(0, monthsStart, 1);
            let monthsEndDate = new Date(0, monthsEnd, 1);
            let currentMonthOffset = new Date(end.getFullYear(), end.getMonth(), 1) - new Date(end.getFullYear(), 0, 1);
            let monthsOffset = (monthsEndDate - monthsStartDate) + currentMonthOffset;
            let monthDiff = (monthsEnd - monthsStart) + end.getMonth();
            let difference = end - start;
            let shouldCountMonths = difference - monthsOffset < 0;
            let milliseconds = shouldCountMonths ? difference : difference - monthsOffset;
            let total_seconds = Math.floor(milliseconds / 1000);
            let total_minutes = Math.floor(total_seconds / 60);
            let total_hours = Math.floor(total_minutes / 60);
            let total_months = shouldCountMonths ? 0 : Math.floor(monthDiff % 12);
            let total_years = Math.floor(monthDiff / 12)
            let days = Math.floor(total_hours / 24);
            let seconds = total_seconds % 60;
            let minutes = total_minutes % 60;
            let hours = total_hours % 24;
            return {
                years: total_years,
                months: total_months,
                days: days,
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                total: difference
            };
        }
        return {};

    }


    // converts Thu May 11 2023 00:00:00 GMT-0400 (Eastern Daylight Time) into an ICS date
    static formatENDateToICSFormat(date) {
        const year = date.getUTCFullYear().toString().padStart(4, '0');
        const month = padZero(date.getUTCMonth() + 1);
        const day = padZero(date.getUTCDate());
        return `${year}${month}${day}T000000Z`;
    }

    static differenceDays(d1, d2) {
        if (d1 && d2) {
            const endDate = new Date(d2);
            const startDate = new Date(d1);
            const timeDifference = endDate.getTime() - startDate.getTime();
            return timeDifference / (1000 * 3600 * 24);
        }
        return Number.MAX_SAFE_INTEGER;
    }

    static dateForTimeZone(timeZone, year, month, day, hour, minute, second) {
        let date = new Date(Date.UTC(year, month, day, hour, minute, second));

        let utcDate = new Date(date.toLocaleString('en-US', {timeZone: "UTC"}));
        let tzDate = new Date(date.toLocaleString('en-US', {timeZone: timeZone}));
        let offset = utcDate.getTime() - tzDate.getTime();

        date.setTime(date.getTime() + offset);

        return date;
    };

    static formatForPathName(d) {
        d = new Date(d);
        return (d.getFullYear() + "-" + padZero(d.getMonth()+1) + "-" + padZero(d.getDate()) + '_' + padZero(d.getHours()) + padZero(d.getMinutes()) + padZero(d.getSeconds()));
    }
}

const padZero = number => number.toString().padStart(2, '0');

export {DateUtil, TODAY}