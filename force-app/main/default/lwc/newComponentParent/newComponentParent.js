import { LightningElement,api,wire } from 'lwc';
import {getRecord,getFieldValue} from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import Email_FIELD from '@salesforce/schema/Contact.Email';

export default class NewComponentParent extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD,PHONE_FIELD,Email_FIELD] })contact;

    get name(){
        return getFieldValue(this.contact.data,NAME_FIELD);
    }

    get phone(){
        return getFieldValue(this.contact.data,PHONE_FIELD);
    }

    get email(){
        return getFieldValue(this.contact.data,Email_FIELD);
    }
}