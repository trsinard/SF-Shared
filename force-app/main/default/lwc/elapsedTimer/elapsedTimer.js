import {api, LightningElement, track} from 'lwc';
import {DateUtil} from "c/dateUtil";
import templateDefault from "./elapsedTimerBadge.html";
import templateBare from "./elapsedTimerBare.html";

export default class ElapsedTimer extends LightningElement {

    _rootDateTime = new Date();
    get rootDateTime() {
        return this._rootDateTime;
    }
    @api set rootDateTime(dt) {
        this._rootDateTime = dt;
        this.updateTracker();
    }
    @api threshold;
    @api hideYears = false;
    @api hideMonths = false;
    @api hideDays = false;
    @api hideHours = false;
    @api hideMinutes = false;
    @api hideSeconds = false;
    @api countDown = false;
    /**
     * badge,bare
     * @type {string}
     */
    _variant = "badge";
    @api set variant(variant) {
        this._variant = variant;
        this.render();
    }
    get variant() {
        return this._variant;
    }

    @track tracker = {
        total: 0,
        seconds: 0,
        minutes: 0,
        hours: 0,
        days: 0,
        months: 0,
        years: 0
    };
    interval;
    delay = 1000

    render() {
        return this.determineTemplate();
    }

    determineTemplate() {
        switch (this.variant) {
            case "badge" :
                return templateDefault;
            case "bare" :
                return templateBare;
            default :
                return templateDefault;
        }
    }


    get dataExceedsTag() {
        return this.threshold && this.tracker && this.tracker.total > this.threshold ? "true" : "false";
    }

    connectedCallback() {
        if (!this.interval) {
            this.startTimer();
        }
    }

    disconnectedCallback() {
        clearInterval(this.interval);
    }

    startTimer() {
        this.interval = setInterval(() => {
            this.updateTracker();
        }, this.delay);
    }

    updateTracker() {
        if (this.countDown) {
            this.tracker = DateUtil.calculateElapsedTime(new Date(), this.rootDateTime);
        } else {
            this.tracker = DateUtil.calculateElapsedTime(this.rootDateTime, new Date());
        }
    }

    get showYears() {
        return (this.tracker.years) && !this.hideYears;
    }

    get showMonths() {
        return (this.showYears || this.tracker.months) && !this.hideMonths;
    }

    get showDays() {
        return (this.showMonths || this.tracker.days) && !this.hideDays;
    }

    get showHours() {
        return (this.showDays || this.tracker.hours) && !this.hideHours;
    }

    get showMinutes() {
        return (this.showHours || this.tracker.minutes) && !this.hideMinutes;
    }

    get showSeconds() {
        return (this.showMinutes || this.tracker.seconds) && !this.hideSeconds;
    }

}