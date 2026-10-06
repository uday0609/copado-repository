import { LightningElement,wire } from 'lwc';
import showContact from '@salesforce/apex/ContactShow.showContact';

export default class ComponentAssignmentOne extends LightningElement {

    contacts = [];
    filteredContacts = [];
    row;

    @wire(showContact)
    wiredContacts({error, data}){
        if(data){
            this.contacts = data;
            this.filteredContacts = data;
        }
        else if(error){
            console.log('Error ', error.message);
        }
    }

    handleSearch(event){
        const searchTerm = event.target.value.toLowerCase();
        this.filteredContacts = this.contacts.filter(contact => contact.Name.toLowerCase().includes(searchTerm));
    }
    
    handleClick(event){
        const contactId = event.target.dataset.id;
        if(contactId){
            this.row = this.contacts.find(contact => contact.Id === contactId)
        }
    }
}