import {api, LightningElement, track, wire} from 'lwc';
import search from '@salesforce/apex/LookupController.search';
import {isEmpty} from "c/parsingUtil";
export default class InputLookup extends LightningElement {

    @api label;
    @api objectApi;
    @api labelApi = 'Name';
    @api valueApi = 'Id';
    @api orderByApi;
    @api icon;
    @api required = false;
    @api filter = '';
    @api placeholder = 'Search';

    @api get value() {
        return this.selection?.value;
    }
    set value(a) {
        //Set Method required when Get Defined. Do nothing.
    }

    @track records;
    @track selection;

    error;
    inputFilter;
    hasInputFocus = false;
    hasMouseFocus = false;


    @wire(search, {
        baseFilter: '$filter',
        objectApi: '$objectApi',
        labelApi: '$labelApi',
        valueApi: '$valueApi',
        orderByApi: '$orderByApi',
        searchTerm: '$inputFilter'
    })
    wiredRecords({error, data}) {
        if (data) {
            this.error = undefined;
            let modifiedEntries = [];
            for (let i = 0; i < data.length; i++) {
                let entry = {...data[i]};
                entry.label = entry[this.labelApi];
                entry.value = entry[this.valueApi];
                modifiedEntries.push(entry);
            }
            this.records = modifiedEntries;
        } else if (error) {
            this.error = error;
            console.log(error);
            this.records = undefined;
        }
    }

    handleSelection(event) {
        this.selection = {...this.records.find(x => x.Id === event.currentTarget.dataset.id)};
        this.inputFilter = '';
        this.dispatchEvent(
            new CustomEvent('select',
                {
                    detail: this.selection
                }
            )
        );
    }

    handleClearing() {
        this.selection = null;
        this.inputFilter = '';
    }

    handleBlur() {
        this.hasInputFocus = false;
    }

    handleFocus() {
        this.hasInputFocus = true;
    }

    handleSearchChange(event) {
        this.inputFilter = event.target.value;
    }

    handleMouseLeave() {
        this.hasMouseFocus = false;
    }
    handleMouseEnter() {
        this.hasMouseFocus = true;
    }

    get showOptions() {
        return !this.selection && !isEmpty(this.inputFilter) && (this.hasMouseFocus || this.hasInputFocus);
    }

    get hasOptions() {
        console.log(!isEmpty(this.records));
        return this.records && !isEmpty(this.records);
    }
}