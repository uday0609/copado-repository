import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import contactTab from '@salesforce/label/c.Contact';
import casesTab from '@salesforce/label/c.Cases';
import opportunityTab from '@salesforce/label/c.Opportunity';
import taskTab from '@salesforce/label/c.Task';
import getAccountHeaderFields from '@salesforce/apex/getAccountCustomMetadata.getAccountHeaderFields';
import getDynamicColumns from '@salesforce/apex/getAccountCustomMetadata.getDynamicColumns';

export default class ComponentAssignmentThree extends LightningElement {
    @api recordId;
    @api objectApiName = 'Account';
    accountRecordMode = '';
    currentTab = 'Contact';
    isRelatedModalOpen = false;
    relatedObjectApiName = '';
    @track dynamicColumns = [];
    @track dynamicData = [];

    labels = {
        contactTab,
        casesTab,
        opportunityTab,
        taskTab
    };

    headerFields = [];
    
    @wire(getRecord, {recordId: '$recordId',fields: [NAME_FIELD]})account;

    @wire(getAccountHeaderFields, {accountId: '$recordId'})
    wiredHeaderData({ error, data }) {
        if (data) {
            this.headerFields = data;
            console.log('HEADER DATA ---> ', data);
        }
        else if (error) {
            console.error('HEADER ERROR ---> ', error);
        }
    }

    get name() {
        return this.account.data ? getFieldValue(this.account.data, NAME_FIELD): '';
    }

    @wire(getDynamicColumns, {accountId: '$recordId',tabId: '$currentTab'})
    wiredColumns({ error, data }) {
        if (data) {
            this.dynamicColumns = data;
            console.log('COLUMNS ---> ', JSON.stringify(this.dynamicColumns));
        }
        else if (error) {
            console.error('COLUMN ERROR ---> ', error);
        }
    }

    @wire(getRelatedListRecords, {parentRecordId: '$recordId',relatedListId: '$relatedListName',fields: '$relatedFields'})
    wiredRelatedData({ error, data }) {
        if (data) {
            console.log('Related Data --------------------->', JSON.stringify(data));
            this.dynamicData = data.records.map(record => {
                let row = {Id: record.id};
                Object.keys(record.fields).forEach(key => {row[key] = record.fields[key].displayValue ||  record.fields[key].value || '';});
                return row;
            });
            console.log('FINAL TABLE DATA ---> ',JSON.stringify(this.dynamicData));
        }
        else if (error) {
            console.error('RELATED LIST ERROR ---> ',JSON.stringify(error))
            this.dynamicData = [];
        }
    }
    
    get relatedListName() {
        const map = {
            Contact: 'Contacts',
            Opportunity: 'Opportunities',
            Case: 'Cases',
            Task: 'Tasks'
        };
        return map[this.currentTab];
    }

    get relatedFields() {
        if (!this.dynamicColumns.length) {
            return [];
        }
        return this.dynamicColumns.map(col => {
            return `${this.currentTab}.${col.fieldName}`;
        });
    }

    get dynamicMode() {
        return this.accountRecordMode === 'view' ? 'view'  : 'edit';
    }

    get dynamicRecordId() {
        return this.accountRecordMode === 'new' ? null : this.recordId;
    }

    get isViewMode() {
        return this.accountRecordMode === 'view';
    }

    get totalRecords() {
        return this.dynamicData ? this.dynamicData.length : 0;
    }

    get modalTitle() {
        if (this.accountRecordMode === 'new') {
            return 'New Account';
        }
        if (this.accountRecordMode === 'edit') {
            return 'Edit Account';
        }
        return 'View Account';
    }

    get dynamicButtonLabel() {
        if (this.currentTab === 'Case') {
            return 'New Case';
        }
        if (this.currentTab === 'Opportunity') {
            return 'New Opportunity';
        }
        if (this.currentTab === 'Task') {
            return 'New Task';
        }
        return 'New Contact';
    }

    handleTabChange(event) {
        this.currentTab = event.target.dataset.id;

        console.log('CURRENT TAB ---> ',this.currentTab);
    }

    handleClick(event) {
        this.accountRecordMode = event.target.dataset.name;
    }

    handleCancel() {
        this.accountRecordMode = '';
    }

    handleSuccess() {
        this.accountRecordMode = '';
    }

    handleNewRecordClick() {
        const objectApiName = {
            Contact: 'Contact',
            Case: 'Case',
            Opportunity: 'Opportunity',
            Task: 'Task'
        };
        this.relatedObjectApiName = objectApiName[this.currentTab];
        this.isRelatedModalOpen = true;
    } 

    closeRelatedModal() {
        this.isRelatedModalOpen = false;
    }

    handleRelatedSuccess() {
        this.isRelatedModalOpen = false;
    }
}