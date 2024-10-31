import {LightningElement, api, track} from 'lwc';
import {DateUtil} from "c/dateUtil";


const TODAY = (() => {
    let today = new Date();
    today.setHours(0, 0, 0, 0);
    return today;
})();

const WEEKS_PER_CALENDAR = 6;
export default class Calendar extends LightningElement {

    _whiteList;
    @api set whiteList(isoDates) {
        this._whiteList = isoDates;
        let whiteListSegments = {};
        isoDates.forEach(isoDate => {
            let asDate = new Date(isoDate);
            let segmentKey = this.getWhitelistSegmentKeyForDate(asDate);
            let entry = whiteListSegments[segmentKey];
            entry = entry ? entry : [];
            entry.push(isoDate);
            whiteListSegments[segmentKey] = entry;
        });
        this.whiteListSegments = whiteListSegments;
        let firstWhitelistDate = new Date(this.whiteList[0]);
        let firstWhitelistDateUTC = new Date(firstWhitelistDate.getUTCFullYear(), firstWhitelistDate.getUTCMonth(), firstWhitelistDate.getUTCDate());
        this.selectedDate = this.selectedDate ? (this.isDateWhitelisted(this.selectedDate) ? this.selectedDate : firstWhitelistDateUTC) : TODAY;

    }

    get whiteList() {
        return this._whiteList;
    }

    whiteListSegments;
    @api disablePast = false;
    @api minDate;
    @api maxDate;
    @api readOnly;
    @track calendarMonth;
    isLoading = false;
    _selectedDate;
    selectedMonth;
    _selectedYear;
    selectedYearComboValue;

    get selectedYear() {
        return this._selectedYear;
    }

    set selectedYear(year) {
        this._selectedYear = year;
        this.selectedYearComboValue = String(year);
    }


    get disableNextMonth() {
        let maximumDate = new Date(this.yearOptions.at(-1)?.value, 11, 31);
        let endOfMonth = new Date(this.selectedYear, this.selectedMonth, 0);
        return this.readOnly || (this.maxDate && endOfMonth > this.maxDate) || (endOfMonth >= maximumDate);
    }

    get disablePrevMonth() {
        let minimumDate = new Date(this.yearOptions.at(0)?.value, 0, 1);
        let endOfLastMonth = new Date(this.selectedYear, this.selectedMonth - 1, 0);
        return this.readOnly || (this.minDate && endOfLastMonth < this.minDate) || (endOfLastMonth < minimumDate);
    }

    nextMonth() {
        if (!this.readOnly) {
            if (!this.disableNextMonth) {
                if (this.selectedMonth === 12) {
                    this.selectedMonth = 1;
                    this.nextYear();
                } else {
                    this.selectedMonth++;
                }
            } else {
                this.selectedMonth = 12;
                this.selectedYear = this.yearOptions.at(-1)?.value;
            }
            this.generateCalendarMonth();
        }
    }

    prevMonth() {
        if (!this.readOnly) {
            if (!this.disablePrevMonth) {
                if (this.selectedMonth === 1) {
                    this.selectedMonth = 12;
                    this.prevYear();
                } else {
                    this.selectedMonth--;
                }

            } else {
                this.selectedMonth = 1;
                this.selectedYear = this.yearOptions.at(0)?.value;
            }

            this.generateCalendarMonth();
        }
    }

    nextYear() {
        this.selectedYear++;
    }

    prevYear() {
        this.selectedYear--;
    }

    connectedCallback() {
        if (!this.calendarMonth) {
            this.selectedDate = TODAY;
        }
    }

    set selectedDate(date) {
        let parsedDate = new Date(new Date(date).setHours(0, 0, 0, 0));
        this._selectedDate = parsedDate;
        this.selectedMonth = parsedDate.getMonth() + 1;
        this.selectedYear = parsedDate.getFullYear();
        this.dispatchEvent(new CustomEvent('select', {
                    detail: {
                        value: this.selectedDate
                    }
                }
            )
        );
        this.generateCalendarMonth();
    }

    get selectedDate() {
        return this._selectedDate;
    }

    handleTodaySelection() {
        if (!this.readOnly) {
            this.selectedDate = TODAY;
        }
    }

    generateCalendarMonth() {
        if (this.selectedMonth && this.selectedYear && this.selectedDate) {
            this.isLoading = true;
            this.calendarMonth = this.getCalendarMonth(this.selectedMonth, this.selectedYear);
            this.isLoading = false;
            this.dispatchEvent(new CustomEvent('viewchange', {
                    detail: {
                        value: {
                            year: this.selectedYear,
                            month: this.selectedMonth
                        }
                    }
                }
            ));
        }
    }

    getCalendarMonth(month, year) {

        let days = [];
        let weeks = [];
        let startDayOfWeek = DateUtil.getStartDayOfWeek(month, year);

        let prevMonth = month === 1 ? 12 : month - 1;
        let prevYear = month === 1 ? year - 1 : year;
        let startDay = DateUtil.getNumberOfDaysInMonth(prevMonth, prevYear) - startDayOfWeek + 1;
        let dayOfWeek = 0;
        for (dayOfWeek; dayOfWeek < startDayOfWeek; dayOfWeek++) {
            let prevDay = startDay + dayOfWeek;
            let asDate = new Date(prevYear, prevMonth - 1, prevDay);
            days[dayOfWeek] = this.buildCalendarDay(asDate, true)
        }
        let numberOfDaysInMonth = DateUtil.getNumberOfDaysInMonth(month, year);
        for (let day = 1; day <= numberOfDaysInMonth; day++) {
            let asDate = new Date(year, month - 1, day);
            days[dayOfWeek] = this.buildCalendarDay(asDate, false);
            dayOfWeek++;
            if ((day + startDayOfWeek) % 7 === 0) {
                weeks.push(this.buildCalendarWeek(days));
                dayOfWeek = 0;
                days = [];
            }
        }

        let nextMonth = month === 12 ? 1 : month + 1;
        let nextYear = month === 12 ? year + 1 : year;
        let nextDay = 1;
        for (dayOfWeek; dayOfWeek <= 7 && weeks.length < WEEKS_PER_CALENDAR; dayOfWeek++) {
            let asDate = new Date(nextYear, nextMonth - 1, nextDay)
            days[dayOfWeek] = this.buildCalendarDay(asDate, true)
            nextDay++;
            if (dayOfWeek === 6) {
                weeks.push(this.buildCalendarWeek(days));
                dayOfWeek = -1;
                days = [];
            }
        }
        // weeks.push(days);
        return this.buildCalendarMonth(month, year, weeks);


    }

    buildCalendarWeek(days) {
        return {
            key: days[0].key,
            days: days
        };
    }

    buildCalendarMonth(month, year, weeks) {
        return {
            key: year + '-' + month,
            weeks: weeks,
            month: {
                value: month,
                label: DateUtil.monthToString(month)
            }
        }
    }

    getWhitelistSegmentKeyForDate(theDate) {
        return theDate.getUTCFullYear() + '-' + theDate.getUTCMonth();
    }

    isDateWhitelisted(theDate) {

        let theDateUtc = new Date(theDate.getUTCFullYear(), theDate.getUTCMonth(), theDate.getUTCDate());
        let utcDateIso = theDateUtc.toISOString().split('T')[0];
        return theDate && (!this.whiteListSegments || this.whiteListSegments[this.getWhitelistSegmentKeyForDate(theDateUtc)]?.includes(utcDateIso));

    }

    buildCalendarDay(theDate, isFiller) {
        let isActive = (!this.disablePast || this.disablePast && theDate.getTime() >= TODAY.getTime()) && this.isDateWhitelisted(theDate);

        let isSelected = this.selectedDate.getTime() === theDate.getTime();

        let styleClasses = ['calendar_body-day'];
        styleClasses.push(isActive ? 'calendar_body-day-active' : 'calendar_body-day-inactive');
        if (isFiller && isActive) {
            styleClasses.push('calendar_body-day-filler');
        }
        if (isSelected) {
            styleClasses.push('calendar_body-day-selected');
        }
        if (theDate.getTime() === TODAY.getTime()) {
            styleClasses.push('calendar_body-day-today');
        }

        return {
            key: theDate.getTime(),
            isSelected: isSelected,
            isActive: isActive,
            isFiller: isFiller,
            isToday: theDate === TODAY,
            styleClass: styleClasses.join(' '),
            weekday: {
                label: DateUtil.dayOfWeekToString(theDate.getDay()),
                value: theDate.getDay(),
            },
            date: theDate,
            day: theDate.getDate()
        };

    }

    handleDaySelection(event) {
        if (!this.readOnly) {
            let date = new Date(event.currentTarget.dataset.date);
            let isActive = event.currentTarget.dataset.active === "true";
            if (isActive) {
                this.selectedDate = date;
            }
        }
    }

    get yearOptions() {
        let options = [];
        for (let i = (TODAY.getFullYear() - (this.disablePast ? 0 : 100)); i <= (TODAY.getFullYear() + 100); i++) {
            options.push({
                label: String(i),
                value: String(i)
            })
        }
        return options;
    }

    handleYearComboSelection(event) {
        if (!this.readOnly) {
            let selection = Number(event.detail.value);
            if (selection !== this.selectedYear) {
                this.selectedYear = selection;
                this.generateCalendarMonth();
            }
        }
    }

    get hostClass() {
        return this.readOnly ? 'calendar_host-readonly' : 'calendar_host';
    }
}