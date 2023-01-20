import {api, LightningElement, track, wire} from 'lwc';
import {getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import {empty} from "c/commonUtils";

export default class InputPicklist extends LightningElement {
    @api objectApi;
    @api fieldApi;
    @api label;
    @api recordTypeId;
    @api value;
    @api required;
    @api helpText;
    @track options;
    fieldPath;

    @wire(getObjectInfo, {objectApiName: '$objectApi'})
    getObjectData({error, data}) {
        if (data) {
            if (this.recordTypeId == null) {
                this.recordTypeId = data.defaultRecordTypeId;
            }
            this.fieldPath = this.objectApi + '.' + this.fieldApi;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getPicklistValues, {recordTypeId: '$recordTypeId', fieldApiName: '$fieldPath'})
    getPicklistValues({error, data}) {
        if (data) {
            this.options = data.values.map(plValue => {
                return {
                    label: plValue.label,
                    value: plValue.value
                };
            });

        } else if (error) {
            console.log(error);
        }
    }

    handleChange(event) {
        this.value = event.detail.value;
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

    reportValidity() {
        let inputCmp = this.template.querySelector('lightning-combobox');
        inputCmp.reportValidity();
    }

    @api checkValidity() {
        let inputCmp = this.template.querySelector('lightning-combobox');
        return inputCmp.checkValidity();
    }
}