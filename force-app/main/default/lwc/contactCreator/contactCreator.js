import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class ContactCreator extends LightningElement {
    fields=[
        FIRST_NAME_FIELD,
        LAST_NAME_FIELD,
        EMAIL_FIELD
    ];

    handleSuccess(event){
        const recordId = event.detail.id;
        this.dispatchEvent(new ShowToastEvent({title : 'Success', message: 'Contact Created. Record Id: '+recordId,variant:'success'}));
    }
}