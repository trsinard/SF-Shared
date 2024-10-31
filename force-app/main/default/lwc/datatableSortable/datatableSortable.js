import {api, LightningElement, track} from 'lwc';

export default class DatatableSortable extends LightningElement {
    _entries = [];
    @api set entries(val) {
        this._entries = val;
        this.selectedRows = [];
        if(this.columns) {
            this._entries = this.sortData(this.entries, this.sortedBy, this.sortedDirection)
        }
        if (this.datatableInitialized) {
            this.dispatchEvent(new CustomEvent('init', {}));
        }
    }
    get entries() {
        return this._entries;
    }

    _columns;
    get columns() {
        return this._columns;
    }
    @api set columns(columns) {
        this._columns = columns;
        this.entries = this.sortData(this.entries, this.sortedBy, this.sortedDirection);
    }
    @api keyField = 'id';
    @api maxSelection = 1;
    @track selectedRows = [];
    sortedBy;
    sortedDirection = 'asc';
    /*
        Work-around to fix rendering issue with lightning-datatable in Mozilla, where the table expands beyond parent
        container. This is one of many issues with Lightning Datatable.
     */
    containerClass = 'datatable-container-init';

    datatableInitialized = false;

    handleSortEvent(event) {
        let fieldName = event.detail.fieldName;
        let sortDirection = event.detail.sortDirection;

        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        this.entries = this.sortData(this.entries, fieldName, sortDirection);
    }

    sortData(data, field, direction) {
        if(!data) {
            return null;
        }
        let columDefinition = null;
        if (this.columns) {
            columDefinition = this.columns.find(obj => {
                return (field == null && obj.sortable) || (field && obj.fieldName === field);
            });
        }
        let sortedData = JSON.parse(JSON.stringify(this.entries));
        if (columDefinition) {
            field = field || columDefinition.fieldName;
            let type = columDefinition?.type || 'text';

            let keyValue = (a) => {
                return a[field];
            };

            let isReverse = direction === 'asc' ? 1 : -1;
            sortedData.sort((xKey, yKey) => {
                let x = keyValue(xKey) || '';
                let y = keyValue(yKey) || '';
                if (type.toLowerCase() === 'date') {
                    x = new Date(x);
                    y = new Date(y);
                }
                return isReverse * ((x > y) - (y > x));
            });
        }
        return sortedData;
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedRows = JSON.parse(JSON.stringify(selectedRows));
        this.dispatchEvent(new CustomEvent('select', {
                    detail: {
                        selectedRows: this.selectedRows
                    }
                }
            )
        );
    }

    /*
        Work-around to fix rendering issue with lightning-datatable, where the elements do not load fast enough when
        the table technically exists. The resize-executes when all the elements have loaded. This is one of many issues
        with Lightning Datatable.
     */
    handleResize(event) {
        if (!this.datatableInitialized) {
            this.containerClass = 'datatable-container';
            this.dispatchEvent(new CustomEvent('init', {}));
            this.datatableInitialized = true;
        }
    }

}