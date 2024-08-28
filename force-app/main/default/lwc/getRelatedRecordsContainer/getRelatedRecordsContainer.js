import { LightningElement, api, track } from 'lwc';
import getRelatedRecords from '@salesforce/apex/RelatedObjectRecordsController.getRelatedRecords';

export default class GetRelatedRecordsContainer extends LightningElement {
    @api recordId;
    @api parentRecordId;
    @api childObjectApiName;
    @api relationshipFieldName;
    @api fieldSetName;
    
    @track records=[];
    @track error;

    connectedCallback() {
        console.log('recordId=='+this.recordId);
        this.fetchRelatedRecords();
    }

    fetchRelatedRecords() {
        if(this.recordId && this.childObjectApiName && this.relationshipFieldName && this.fieldSetName){
            getRelatedRecords({
                parentRecordId: this.recordId,
                childObjectApiName: this.childObjectApiName,
                relationshipFieldName: this.relationshipFieldName,
                fieldSetName: this.fieldSetName
            })
            .then(result => {
                if(result && result.length > 0)  {
                    console.log('result=='+JSON.stringify(result));
                    this.records = this.processAllfieldsOfRecords(result);
                    this.error = undefined;
                }
                else{
                    this.error='No record found';
                }
                
            })
            .catch(error => {
                this.error = error;
                this.records = undefined;
            });
        }
        else{
            this.error = 'Missing required parameters.';
        }
    }

    processAllfieldsOfRecords(records) {
        return records.map(record => {
            const fields = [];
            for (const field in record) {
                    fields.push({
                        fieldName: field,
                        value: record[field]
                    });
               
            }
            console.log('In child22=='+JSON.stringify(fields));
            return { 
                fields: fields
            };
        });
    }
}