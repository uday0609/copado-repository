import { LightningElement,track,wire } from 'lwc';
import showContact from '@salesforce/apex/ContactShow.showContact';

const COLUMNS =[
    {label : 'Name', fieldName : 'Name'},
    {label : 'Email', fieldName : 'Email', type : 'email'}
];
export default class ParentComponentOne extends LightningElement {
    newName = 'Yash';
    newName1 = '';
    handleFilterChange(event){
        this.newName1 = event.target.value;
    }
    //parentUserName = this.template.querySelector('c-child-component-one').userName;

    callReset(){
        console.log('call reset called');
        this.template.querySelector('c-child-component-one').resetForm();
    }
    
      @track user = {
        Name : 'Uday',
        Age : 20 
    };

    handleChange(){
        console.log('method called');
        this.user={
            ...this.user,
            Age : this.template.querySelector('[data-id="age"]').value
        }
    }


    columns = COLUMNS;
    contactData = [];
    error;

    @wire(showContact)
    wiredContact({error,data}){
        //console.log('entry point');
        if(data){
            //console.log('data is: ',data);
            this.contactData = data;
            this.error = '';
        }
        else if(error){
            //console.log('error is : ',error);
            this.error = error;
            this.contactData = '';
        }
    }
}