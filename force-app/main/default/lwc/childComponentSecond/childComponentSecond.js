import { LightningElement,api,wire } from 'lwc';
import showContact from '@salesforce/apex/ContactShowNew.showContact'
const COLUMNS = [
    {label : 'Name', fieldName : 'Name'},
    {label : 'Email', fieldName : 'Email', type : 'email'}

]
export default class ChildComponentSecond extends LightningElement {
    @api recordLimit  = 0;
    columns = COLUMNS;
    contactData = [];
    error;

    @wire(showContact,{limits : '$recordLimit'})
    wireService({error,data}){
        // console.log('Enter the method');
        // console.log(this.recordLimit);
        if(data){
            // console.log('Data ', data);
            this.contactData = data ;
            this.error = '';
        }
        else if(error){
            this.error = (error.body) ? error.body.message : error.message;
            // console.log(this.recordLimit);
            // console.log('error',error);
            this.contactData = [];
        }
    }
}