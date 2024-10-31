import {api, LightningElement, track} from 'lwc';
import {DateUtil} from "c/dateUtil";
import {isEmpty} from "c/parsingUtil";

export default class InputDate extends LightningElement {

    @api label;
    @api variant;

    @api upperLimit;
    @api lowerLimit;

    @api required = false;

    /**
     * An object that contains one or more properties that specify comparison options.
     * @type Intl.DateTimeFormatOptions
     */
    @api format = {year: "numeric", month: "short", day: "numeric"};
    @track _value;
    @api set value(date) {
        if (isEmpty(date)) {
            this._value = null;
            this.displayedValue = "";
        } else {
            this._value = DateUtil.asUTC(new Date(date));
            this.displayedValue = this._value.toLocaleDateString('en-us', this.format)
            let inputCmp = this.template.querySelector('lightning-input');
            if(inputCmp) {
                inputCmp.value = this.displayedValue;
            }
        }
        this.dispatchEvent(
            new CustomEvent('input',
                {
                    detail: {
                        value: this.value ? this.value.toISOString().split('T')[0] : null,
                        date: this.value,
                        valid: this.checkValidity()
                    }
                }
            )
        );
        this.reportValidity();
    }

    get value() {
        return this._value;
    }

    displayedValue = "";

    handleInput(event) {
        let showCalender = true;
        if (!/[a-z]/i.test(event.detail.value)) {
            let input = event.detail.value?.replace(/\D/g, '');
            let sections = input.replace(/\D/g, '').match(/(\d{0,2})(\d{0,2})(\d{0,4})/);
            sections[1] = sections[1] != null && sections[1].length === 2 && sections[1] > 12 ? '12' : sections[1];
            let monthUpper = sections[1] != null && sections[1].length === 2 && (sections[1] === 9 || sections[1] === 4 || sections[1] === 6 || sections[1] === 11) ? 30 : (sections[1] === 2 ? 28 : 31);
            sections[2] = sections[2] != null && sections[2].length === 2 && sections[2] > monthUpper ? monthUpper : sections[2];
            sections[3] = sections[3] != null && sections[3].length === 4 && sections[3] > 4000 ? '4000' : sections[3];

            sections[1] = sections[1] != null && sections[1].length === 2 && sections[1] < 1 ? '01' : sections[1];
            sections[2] = sections[2] != null && sections[2].length === 2 && sections[2] < 1 ? '01' : sections[2];
            sections[3] = sections[3] != null && sections[3].length === 4 && sections[3] < 1700 ? '1700' : sections[3];

            this.displayedValue = !sections[2] ? sections[1] : sections[1] + '/' + sections[2] + (sections[3] ? '/' + sections[3] : '');
            if (this.displayedValue.length === 0 || this.displayedValue.length === 10) {
                this.value = this.displayedValue;
                showCalender = false;
            }
        }
        this.reportValidity();
        this.hasMouse = showCalender;
        this.hasFocus = showCalender;
    }

    hasFocus = false;
    hasMouse = false;

    handleMouseExit() {
        this.hasMouse = false;
    }

    get showCalendar() {
        return this.hasMouse || this.hasFocus;
    }

    handleFocus() {
        this.hasMouse = true;
        this.hasFocus = true;
    }

    handleBlur() {
        let input = this.template.querySelector('lightning-input');
        if (input && DateUtil.isValidDate(input.value)) {
            this.value = input.value;
        } else if (this.value != null && (!DateUtil.isValidDate(this.displayedValue) || !DateUtil.isValidDate(input.value))) {
            this.value = null;
            if (input) {
                input.value = "";
            }
        }
        this.reportValidity();
        this.hasFocus = false;

        let calendarCmp = this.template.querySelector('lightning-calendar');
        console.log(calendarCmp);
    }

    handleCalendarInput(event) {
        this.value = event.detail.value;
        this.hasMouse = false;
        this.hasFocus = false;
    }

    @api reportValidity() {
        this.validationMessage = '';
        if (!((this.required && !isEmpty(this.value)) || !this.required)) {
            this.validationMessage = "Complete this field."
        }
        if(!isEmpty(this.value)) {
            let upperLimit = Date.parse(this.upperLimit);
            let lowerLimit = Date.parse(this.lowerLimit);
            if(!isNaN(upperLimit) && this.value > upperLimit) {
                this.validationMessage = 'Date is above maximum value ' + this.upperLimit.toLocaleDateString('en-us', { year:"numeric", month:"short", day:"numeric"});
            } else if(!isNaN(lowerLimit) && this.value < lowerLimit) {
                this.validationMessage = 'Date is below minimum value ' + this.lowerLimit.toLocaleDateString('en-us', { year:"numeric", month:"short", day:"numeric"});
            }
        }
        let inputCmp = this.template.querySelector('lightning-input');
        inputCmp.setCustomValidity(this.validationMessage);
        inputCmp.reportValidity();
        this.template.host.style.setProperty('--calendar_offset', this.checkValidity() ? '0' : '-15px');
    }

    @api checkValidity() {
        return isEmpty(this.validationMessage);
    }

    get valueAsIsoString() {
        return this.value ? this.value.toISOString().split('T')[0] : null;
    }

}