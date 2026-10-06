import { LightningElement,wire } from 'lwc';
import showContact from '@salesforce/apex/ContactShow.showContact';
import createTask from '@salesforce/apex/ContactShow.addTask';
import updateTasks from '@salesforce/apex/ContactShow.updateTasks';
import { refreshApex } from '@salesforce/apex';

export default class ComponentAssignmentTwo extends LightningElement {
    contacts = [];
    filteredContacts =  [];
    row;
    wiredContactsData;
    selectedTaskId=[];
    
    trackChange = { Type: '', Description: '' };

    types = [
        { label: 'Call', value: 'Call' },
        { label: 'Email', value: 'Email' },
        { label: 'Meeting', value: 'Meeting' },
        { label: 'Other', value: 'Other' }
    ];

    // columns = [
    //     {label : 'Type', fieldName : 'Type', type : 'text'},
    //     {label : 'Date', fieldName : 'ActivityDate', type : 'date'},
    //     {label : 'Description', fieldName : 'Description', type : 'textarea'},
    //     {label : 'Status', fieldName : 'Status', type : 'text'}
    // ]

    @wire(showContact)
    wiredContacts(result){
        this.wiredContactsData = result;
        const {data, error} = result;
        if(data){
            this.contacts = data.map(con => {
                let tasksCompleted = con.Tasks ? con.Tasks.map(task => {const isDone = task.Status === 'Completed';return {...task,isCompleted: isDone,statusClass: isDone ? 'slds-show_inline-block slds-text-color_success slds-box slds-theme_success' : 'slds-show_inline-block slds-box slds-theme_error text-color_error'};}) : [];
                let totalTasks = con.Tasks ? con.Tasks.length : 0;
                let completedTasks = con.Tasks ? con.Tasks.filter(task => task.Status === 'Completed').length : 0;
                let progress = Math.round(totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0);
                return {...con, taskCount : totalTasks, progress: progress,Tasks : tasksCompleted};
            });

            this.filteredContacts = this.contacts;

            if(this.row){
                this.row = this.contacts.find(contact => contact.Id === this.row.Id);
            }
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
            //console.log('contactId',contactId);
            this.row = this.contacts.find(contact => contact.Id === contactId);
        }
    }

    handleChange(event){
        const fieldName = event.target.dataset.field;
        const fieldValue = event.target.value;
        this.trackChange = {...this.trackChange, [fieldName]: fieldValue};
    }

    async addTasks(){
      console.log(this.trackChange.Type);
      console.log(this.trackChange.Description);
        if(!this.trackChange.Type || !this.trackChange.Description){
        return;
      }        
      try{
        await createTask({contactId : this.row.Id, type : this.trackChange.Type, description : this.trackChange.Description});
        await refreshApex(this.wiredContactsData);
        this.trackChange = {Type: '', Description: '' };
      }
      catch(error){
        console.log('Error ', error.message);
      }
    }

   handleRowSelection(event){
        const taskId = event.target.dataset.id;
        const isChecked = event.target.checked;
        if(isChecked){
            this.selectedTaskId = [...this.selectedTaskId, taskId];
        }
        else{
            this.selectedTaskId = this.selectedTaskId.filter(id => id !== taskId);
        }

        this.row.Tasks = this.row.Tasks.map(task => {
            if(task.Id === taskId){ 
                return {...task , isChecked : isChecked};
            }
            return task;
        })
   }

   async handleSave(){
     try{
       await updateTasks({taskIds : this.selectedTaskId});
       await refreshApex(this.wiredContactsData);
     }
     catch(error){
       console.log('Error ',error.message);
     }
   }

   handleClose(event){
     this.selectedTaskId = [];
     if(this.row && this.row.Tasks){
        this.row = {...this.row, Tasks: this.row.Tasks = this.row.Tasks.map(task => {return{...task , isChecked : false}})};
     }
     //console.log('OUTPUT : ',this.row.Tasks[0].isChecked);
    }
}