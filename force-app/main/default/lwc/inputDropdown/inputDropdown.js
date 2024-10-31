import {api, LightningElement, track} from "lwc";
import {clone, getDeepValue, isEmpty} from "c/parsingUtil";

const MAX_LISTED_ITEMS = 500;
const MIN_LISTED_ITEMS = 50;
const INCREMENT_LISTED_ITEMS = 50;
export default class InputDropdown extends LightningElement {
    @api label;
    @api placeholder = "Search...";
    @api loadMoreText = "Load More"
    @api disabled;
    _recordsList;
    /**
     * A list of objects with a label/value pair. Optional tags csv property.
     * Example:
     *  [
     *      {
     *          label : "foo",
     *          value : "bar"
     *          tags : "example,optional,tag,csv"
     *      }
     * ]
     * Optional "value_key_path" property
     * This is used when the "value" is an object instead of a primitive. This is the key path to a value can be used to identify a "match" since
     * an object may not be an equal match due to a property.
     * Example:
     *  [
     *      {
     *          label : "foo",
     *          value : {
     *              bar :'details',
     *              struct : {
     *                  Id: "key"
     *              }
     *          },
     *          value_key_path : 'struct.Id'
     *      }
     *  ]
     *  When provided, instead of doing an exact match on the object, it will find a match for the provided key
     * @param val
     */
    @api set recordsList(val) {
        if (val != null) {
            let uniqueVals = clone(val, true).filter((value, index, self) =>
                    index === self.findIndex((t) => (
                        t.label === value.label && t.value === value.value
                    ))
            );
            let processedList = [];
            for (let i = 0; i < uniqueVals?.length; i++) {
                let obj = uniqueVals[i];
                processedList.push({
                    ...obj,
                    _key: obj.value_key_path ? getDeepValue(obj.value, obj.value_key_path) : (typeof obj.value === "object" ? JSON.stringify(obj.value) : String(obj.value)),
                    index: String(i)
                });
            }
            this._recordsList = processedList;
        } else {
            this._recordsList = [];
        }
        this.search();
        if (this.defaultValue && this.filteredRecordList) {
            this.makeSelection(this.defaultValue, true);
        }

    }

    get recordsList() {
        return this._recordsList == null ? [] : this._recordsList;
    }

    @api selectedRecord;
    @api required;
    @api defaultFirstMatch = false;
    _defaultValue;

    hasFocus = false;
    hasHover = false;
    optionsToShow = MIN_LISTED_ITEMS;

    /**
     * Default value selection. This will use the value key on the entry by default. Use optional value_key_path to identify match on nested value.
     * @param val
     */
    @api set defaultValue(val) {
        this._defaultValue = clone(val);
        if (this.defaultValue && this.filteredRecordList) {
            this.makeSelection(this.defaultValue, true);
        } else if(!this.defaultValue) {
            this.clear();
        }
    }

    initialized = false;
    connectedCallback() {
        this.onBlur();

    }

    get defaultValue() {
        return this._defaultValue;
    }

    searchKeyWord = '';
    @track filteredRecordList;

    onFocus() {
        let wasChange = !this.hasFocus && !this.hasHover;
        this.hasFocus = true;
        this.hasHover = true;
        if (wasChange) {
            this.searchKeyWord = '';
            this.search()
        }
        this.handleOptionExpanse();
    }


    onBlur() {
        this.reportValidity();
        this.hasFocus = false;
        this.applyDefault();
        this.handleOptionExpanse();
        if (!this.checkValidity()) {
            this.searchKeyWord = '';
        }
    }

    applyDefault() {
        if (!this.hasFocus && !this.hasHover) {
            if (this.defaultFirstMatch && !this.selectedRecord  && this.searchKeyWord?.length > 0 && this.filteredRecordList?.length > 0) {
                this.makeSelection(this.filteredRecordList[0]._key);
            }
        }
    }

    onMouseExit() {
        this.hasHover = false
        this.handleOptionExpanse();
    }
    onMouseEnter() {
        this.hasHover = true;
    }

    handleOptionExpanse() {
        if (this.hasFocus || this.hasHover) {
            this.toggleContainerOpen('searchRes', true);
            let anchor = this.template.querySelector('[data-id="scroll_anchor"]');
            if(anchor) {
                anchor.scrollIntoView({ behavior: 'smooth', block: 'end' });
            }
        } else {
            this.toggleContainerOpen("searchRes", false);
        }
    }

    handleSearchChange(event) {
        this.optionsToShow = MIN_LISTED_ITEMS;
        this.searchKeyWord = event.detail.value;
        if (this.searchKeyWord.length > 0) {
            this.toggleContainerOpen("searchRes", true);
            this.search();
        } else {
            this.toggleContainerOpen("searchRes", false);
            this.clearFilter();
        }
    }

    handleLoadMore() {
        this.optionsToShow = Math.min(this.optionsToShow + INCREMENT_LISTED_ITEMS, MAX_LISTED_ITEMS);
        this.search();

    }

    get hasMore() {
        return (!isEmpty(this.searchKeyWord) && this.filteredRecordList?.length >= this.optionsToShow) || (isEmpty(this.searchKeyWord) && this.filteredRecordList?.length < this.recordsList?.length && this.optionsToShow < MAX_LISTED_ITEMS);
    }

    get hasMoreAtMax() {
        return this.filteredRecordList?.length < this.recordsList?.length && this.optionsToShow >= MAX_LISTED_ITEMS;
    }

    get noResultsMessage() {
        if (this.filteredRecordList.length === 0) {
            return 'No Results Found...';
        } else {
            return null;
        }
    }

    clear() {
        this.clearFilter();
        this.makeSelection(null);
    }

    toggleContainerOpen(id, shouldOpen) {
        let container = this.template.querySelector('[data-id="' + id + '"]');
        if (container) {
            container.classList.add(shouldOpen ? 'slds-is-open' : 'slds-is-close');
            container.classList.remove(!shouldOpen ? 'slds-is-open' : 'slds-is-close');
            this.dispatchEvent(new CustomEvent('togglecontainer', {
                detail: {
                    value: shouldOpen
                }
            }));
        }
    }

    clearFilter() {
        this.searchKeyWord = '';
        this.search();
    }

    selectRecord(event) {
        let key = event.currentTarget.dataset.key;
        this.makeSelection(key);
    }

    makeSelection(value, skipDispatch) {
        if (this.recordsList && value) {
            let match = this.recordsList.find(entry => entry.value_key_path ? (getDeepValue(entry.value, entry.value_key_path) === (typeof value === "object" ? getDeepValue(value, entry.value_key_path) : value)) : entry.value === value);
            if (match) {
                this.selectedRecord = {...match};
                this.onBlur()
                this.onMouseExit()
                if (!skipDispatch) {
                    this.dispatchChange();
                }
            }
        } else if (!value) {
            this.selectedRecord = null;
            this.checkValidity();
            if (!skipDispatch) {
                this.dispatchChange();
            }
        }
    }

    search() {
        let key = this.searchKeyWord;
        let results = !isEmpty(key) ? this.recordsList.filter(rec => {
            let tagsSplit = rec?.tags ? rec.tags.split(',') : [];
            let indexOf = (arr, q) => arr.findIndex(item => item.toLowerCase().trim().includes(q.toLowerCase().trim()));
            return rec.label.toLowerCase().includes(key.toLowerCase()) || indexOf(tagsSplit, key.toLowerCase()) > -1;
        }) : this.recordsList;
        results = results.slice(0, this.optionsToShow);
        this.filteredRecordList = [...results];
    }

    @api reportValidity() {

        let inputCmp = this.template.querySelector('lightning-input');
        if (!this.checkValidity() && inputCmp) {
            inputCmp.setCustomValidity('This field is required.');
            inputCmp.reportValidity();
        }
        this.template.host.style.setProperty('--dropdown_offset', this.checkValidity() ? 'unset' : (this.label ?'55px' : '32px'));
    }

    @api checkValidity() {
        return (this.required && this.selectedRecord)  || !this.required;
    }

    dispatchChange() {
        let value = this.selectedRecord ? this.selectedRecord.value : null;
        const dropdownChangeEvent = new CustomEvent('select', {
            detail: {
                value: value
            }
        });
        this.dispatchEvent(dropdownChangeEvent);
    }

}