import { LightningElement, wire } from 'lwc';
import DetailModal from 'c/detailModal';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';


export default class AccountList extends LightningElement {
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    // accounts = [
    //     {id: 1, name: 'Acme Corporation', industry: 'Manufacturing', location: 'New York', revenue: '$10M', employees: 100000, phone: '123-456-7890', website: 'www.acme.com', description: 'A leading manufacturer of industrial products.'},
    //     {id: 2, name: 'Global Tech', industry: 'Technology', location: 'San Francisco', revenue: '$50M', employees: 50000, phone: '098-765-4321', website: 'www.globaltech.com', description: 'A innovative technology company.'},
    //     {id: 3, name: 'Health Solutions', industry: 'Healthcare', location: 'Chicago', revenue: '$25M', employees: 25000, phone: '111-222-3333', website: 'www.healthsolutions.com', description: 'A comprehensive healthcare provider.'},
    //     {id: 4, name: 'Finance Experts', industry: 'Financial Services', location: 'Los Angeles', revenue: '$75M', employees: 75000, phone: '444-555-6666', website: 'www.financeexperts.com', description: 'A trusted financial services firm.'},
    //     {id: 5, name: 'Retail Giants', industry: 'Retail', location: 'Houston', revenue: '$100M', employees: 100000, phone: '777-888-9999', website: 'www.retailgiants.com', description: 'A leading retail chain.'},
    //     {id: 6, name: 'Varun Experts', industry : 'Retail', location: 'Phoenix', revenue: '$30M', employees: 30000, phone: '222-333-4444', website: 'www.varunexperts.com', description: 'A specialized retail consulting firm.'}
    // ];

    accounts = [];

    @wire (getAccounts)
    wiredAccounts({error, data}) {
        if (data) {
            this.accounts = data;
        }
        else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text', sortable: true },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        {
            type: 'button',
            typeAttributes: {
                label: 'View Details',
                name: 'view_details',
                variant: 'base'
            }
        }
    ];

    async handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        //console.log('Row action triggred with action: ', action, ' and row: ', row);
        try{
            if(action.name === 'view_details'){
                await DetailModal.open({size : 'small', accountData : row});
            }
        }
        catch(error){
            console.log('Error opening modal:', error);
        }
    }

    handleSort(event) {
        console.log('Sorting data with field: ', event.detail.fieldName, ' and direction: ', event.detail.sortDirection);
        try{
            const {fieldName: sortedBy, sortDirection} = event.detail;
            const cloneData = JSON.parse(JSON.stringify(this.accounts));
            cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
            this.accounts = cloneData;
            this.sortDirection = sortDirection;
            this.sortedBy = sortedBy;
        }
        catch(error){
            console.log('Error sorting data:', error.message);
        }
    } 

    sortBy(field,reverse,primer){
        const key = primer ? function(x){return primer(x[field])} : function(x){return x[field]};
        return (a,b) => {
            let A = key(a) ? key(a) : '';
            let B = key(b) ? key(b) : '';
            if(typeof A === 'string') A = A.toLowerCase();
            if(typeof B === 'string') B = B.toLowerCase();
            
            if(A > B) return reverse * 1;
            if(A < B) return reverse * -1;
            return 0;
        }
    }
}