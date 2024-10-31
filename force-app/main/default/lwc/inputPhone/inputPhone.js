import {api, LightningElement} from 'lwc';
import {clone, isEmpty} from "c/parsingUtil";

export default class InputPhone extends LightningElement {

    @api label;
    @api variant;
    @api required;
    @api enforceFormat;

    @api hideError = false;

    @api set value(val) {
        val = this.formatPhone(clone(val));
        if (this.value !== val) {
            this._value = val;
            this.reportValidity();
            this.dispatchEvent(
                new CustomEvent('input',
                    {
                        detail: {
                            value: this.value,
                            valid: this.checkValidity()
                        }
                    }
                )
            );
        }
    }

    get value() {
        return this._value
    }

    _value;
    isValid = true;
    fieldAcknowledged = false;


    connectedCallback() {
        this.value = this.value ? this.value : "";
    }

    formatPhone(inputPhone) {
        inputPhone = inputPhone == null ? "" : inputPhone.replace(/\D/g, '');
        let formattedPhone = inputPhone.match(/(\d{0,3})(\d{0,3})(\d{0,4})(x?\d*)/);
        if (this.enforceFormat) {
            inputPhone = !formattedPhone[2] ? formattedPhone[1] : '(' + formattedPhone[1] + ') ' + formattedPhone[2] + (formattedPhone[3] ? '-' + formattedPhone[3] : '');
        } else {
            inputPhone = formattedPhone[1] + formattedPhone[2] + formattedPhone[3];
        }
        inputPhone = formattedPhone[4] ? inputPhone + (' x' + formattedPhone[4]) : inputPhone;
        return inputPhone;
    }

    handleChange(event) {
        this.fieldAcknowledged = true;
        let originalValue = clone(event.detail.value);
        let formattedValue = this.formatPhone(originalValue);
        let theInput = this.template.querySelector('lightning-input');
        if (theInput) {
            let cursorPosition = theInput.selectionEnd;
            let offset = formattedValue.length - originalValue.length;
            theInput.value = formattedValue;
            theInput.selectionEnd = cursorPosition + offset;
            if (this.hideError) {
                theInput.style.setProperty('--lwc-fontSize2', '0');
            }
        }
        this.value = formattedValue;

    }

    _validationMessage;
    get validationMessage() {
        return this._validationMessage;
    }

    set validationMessage(str) {
        this._validationMessage = str;
        this.isValid = isEmpty(this.validationMessage);
    }

    @api reportValidity() {
        this.validationMessage = '';
        if (!((this.required && !isEmpty(this.value)) || !this.required)) {
            this.validationMessage = "Complete this field."
        } else if (this.value) {
            let isSameDigit = /^(.)\1*$/.test(this.value.replace(/\D/g,''));
            let lengthValidWithFormat = this.enforceFormat && !isSameDigit && ((this.value.length === 14 || this.value.length === 0) || (this.value.length > 16 && this.value.length <= 22));
            let lengthValidWithoutFormat = !this.enforceFormat && !isSameDigit && ((this.value.length === 10 || this.value.length === 0) || (this.value.length > 12 && this.value.length <= 18));
            
            if (!lengthValidWithFormat && !lengthValidWithoutFormat) {
                this.validationMessage = "Invalid phone value.";
            }
        }
        let inputCmp = this.template.querySelector('lightning-input');
        if (this.fieldAcknowledged) {
            inputCmp.setCustomValidity(this.validationMessage);
            inputCmp.reportValidity();
        }
    }

    @api checkValidity() {
        return this.isValid;
    }

    handleOnFocus(event) {
        this.fieldAcknowledged;
    }

    handleOnBlur(event) {
        this.fieldAcknowledged = true;
    }
}