/**
 * Description: A controller to control the functionality of dynamically adding the child records to
 * the parent object .Based on the Parent object, child object that are  been fetched from the
 * Setting__c object which contains this information .
 *
 * Initial Draft                Author               Date           Comment 
 * Version 1.0                Dhirendra             08/27/2014     Initial Draft
 * Version 1.1                Geeta Kushwaha        03/29/2016     Add the clone link functionality
 *                                                                 which creates duplicate row      
 *
 */
public with sharing class Addmultiplechildrecordscontroller {


        // Static final variables
        private static final String PARAM_APP_SETTING_ID = 'po';
        private static final String PARAM_PARENT_ID = 'pid';
        private static final String PARAM_RETURNURL = 'pretURL';
        private static final String PARAM_ROW_NUMBER = 'pAddrowNumber';
        private static final String PARAM_INDEX = 'pIndex';
        private static final String PARAM_DELETEDERRORMSG = 'pErrorMessage';
        private static final String STR_SELECT = 'SELECT';
        private static final String STR_FROM = 'FROM';
        private static final String STR_WHERE = 'WHERE';
        private static final String WHITESPACE = ' ';
        private static final String COMMA = ',';
        private static final String STR_AND = 'AND';
        private static final String STR_ID = 'ID';
        private static final String STR_IN = 'IN';
        private static final String STR_COLON = ':';

        // Variables
        public List<sObject> sObjectList {get; set; }
        public List<String> sObjectChildfieldList {get; set; }
        public List<sObject> sobjectExistingChildList {get; set; }
        public List<sObject> sobjectInsertedChildList {get; set; }
        public List<Schema.FieldSetMember> listparentFieldSetMember {get; set; }
        public List<Schema.FieldSetMember> listChildFieldSetMember {get; set; }
        public List<childSobjectWrapper> createNewSobjectList {get; set; }
        public String strChildRecId { get; set { strChildRecId = value; } }
        public String strAddNoRecords {get; set; }
        public String strHeaderRowValue {get; set; }
        public string render {get; set; }
        public Blob csvFileBody {get; set; }
        public string csvAsString {get; set; }
        public String[] csvFileLines {get; set; }
        public String[] strHeaderRow {get; set; }
        public Boolean isVisible {get; set; }
        public Boolean isPageVisible {get; set; }
        public Boolean isDeleterMessage {get; set; }
        public Boolean isFileVisible {get; set; }
        public Boolean isFileUploaded {get; set; }
        public List<childSobjectEditWrapper> lstChildWrp {get; set; }
        public Map<Integer, childSobjectEditWrapper> lstChildWrpMap {get; set; }
        public Settings__c objSetting {get; set; }
        public static Settings__c objSettingForDelete;
        public Map<String,String> strChildId;
        public string objChildConId {get; set; }

        public List<sObject> sObjectChildList;
        public List<String> sObjectfieldList;
        public String strParentId;
        public String strFieldsetObjectAssociationId;
        public String strReturnURL;
        public String strSobjectId;
        public Set<Id> setInsertedchildId;
        public Integer rowNumber;
        public Integer rowIndex {get; set; }
        // assignedRowNumber is gives the row number when clicked on any particular row
        public Integer assignedRowNumber {get; set; } 
        private sObject objChildSobject;
        private sObject objChildSobjectTemp;
        public List <childSobjectEditWrapper> childDataList {get; set; }
    
        public Map<String,String> mapChildFieldApi_HelpText{get;set;}       
        public Map<String,String> mapParentFieldApi_HelpText{get;set;}
        
        
        //Constructor
        public Addmultiplechildrecordscontroller (){
            strChildId = Apexpages.currentPage().getParameters();
            childDataList = new List<childSobjectEditWrapper>();
            
            mapChildFieldApi_HelpText = new Map<String,String>();
            mapParentFieldApi_HelpText = new Map<String, String>();
            
            init();
        }

        /**
         * A method that call the methods that are to be needed when the page is Loaded.
         **/
        public void init() {
            isPageVisible = true;
            isFileVisible = true;
            //Display an error message if invalid input parameters are provided to the page
            if(String.isBlank(ApexPages.currentPage().getParameters().get(PARAM_APP_SETTING_ID))||
               String.isBlank(ApexPages.currentPage().getParameters().get(PARAM_RETURNURL)) ||
               String.isBlank(ApexPages.currentPage().getParameters().get(PARAM_PARENT_ID))) {
                    isPageVisible = false;
                    showError(Label.ErrorMessage);

            } else {
                //Initialize the variables only if the appropriate input parameters are provided to the page
                strFieldsetObjectAssociationId = ApexPages.currentPage().getParameters().get(PARAM_APP_SETTING_ID);
                strReturnURL = ApexPages.currentPage().getParameters().get(PARAM_RETURNURL);
                strSobjectId = ApexPages.currentPage().getParameters().get(PARAM_PARENT_ID);
                isVisible = false;
                isDeleterMessage = false;
                isFileUploaded = false;
                rowNumber = 0;
                strAddNoRecords = '';
                objSetting = new Settings__c();
                createNewSobjectList = new List<childSobjectWrapper>();
                sObjectList = new List<sObject>();
                sObjectfieldList = new List<String>();
                sObjectChildfieldList = new List<String>();
                sobjectExistingChildList = new List<Sobject>();
                sobjectInsertedChildList = new List<Sobject>();
                listparentFieldSetMember= new  List<Schema.FieldSetMember>();
                lstChildWrp = new List<childSobjectEditWrapper> ();
                sObjectList = new List<sobject>();
                sObjectChildList = new List<sObject>();
                //createNewSobjectList= new List<childSobjectWrapper>();
                listChildFieldSetMember = new List<Schema.FieldSetMember>();
                retrieveFieldSetObjectRec();
                retrieveParentObjectRecord();
                retrieveChildFieldset(NULL);

                if(Schema.getGlobalDescribe().get(objSetting.Child_Sobject_Name__c ) !=null) {
                        objChildSobject = Schema.getGlobalDescribe().get(objSetting.Child_Sobject_Name__c ).getDescribe().sobjectType.newSObject(null,false);
                }

                createNewChildRecord();
                childDataList = getChildData ();
            }
            
           
           }
        
        

        /**
         *  A method to display the error messages that are passed down to the method as parameters
         *  Parameters:
         *  pErrorMessage : The String variable i.e Error Message which to be be displayed in the error message.
         **/
        public void showError(String pErrorMessage) {
            isVisible = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, pErrorMessage);
            ApexPages.addMessage(myMsg);
        }

        /**
         *  A method to generate the query string that can be used to run the dynamic query based
         *  on the parameters passed
         *  The parameters passed are as follows
         *  @pObjectName        = Api Name of the Parent Sobject whose record are to be fetched.
         *  @pFieldValue        = Comma separated api Name of fields to be queried
         *  @pWhereClauseField  = Api Name of field to be used in the Where clause.
         *  @pQuerySearchId     = Record Id of a specific Sobject record
         **/
        public static String generateQueryString(String pObjectName,
                                                 String pFieldValue,
                                                 String pWhereClauseField,
                                                 String pQuerySearchId){
            return STR_SELECT
                   + WHITESPACE + pFieldValue
                   + WHITESPACE + STR_FROM
                   + WHITESPACE + pObjectName +
                   +WHITESPACE + STR_WHERE
                   + WHITESPACE + pWhereClauseField + WHITESPACE + '= \'' + pQuerySearchId + '\'';
        }

        /**
         * A method which fetches the vlaue form the fielset and displays the values along with  the
         * fields value on the Parent headerSection in the Vf page. The String variable is paased as
         * a parameter to the page
         * Parameters:
         * pStrObjectId = Id of the parent object provided to the page as an input parameter.
         **/
        public void retrieveParentObjectRecord(){

            listparentFieldSetMember= new List<Schema.FieldSetMember>();
            String strFieldValue = '';
            String strQuery = '';

            Schema.FieldSet fieldSetObj =
                    retrieveFieldSetObj(objSetting.Parent_Sobject_Name__c,objSetting.Parent_Fieldset_Name__c);
            
            if(fieldSetObj != null && fieldSetObj.getFields() != null && !fieldSetObj.getFields().IsEmpty()) {

                listparentFieldSetMember = fieldSetObj.getFields();
                
                for(Schema.FieldSetMember objFields : fieldSetObj.getFields()) {

                        strFieldValue = String.isBlank(strFieldValue) ?
                                        objFields.getFieldPath() : strFieldValue + ' , ' + objFields.getFieldPath();
                        sObjectfieldList.add(objFields.getFieldPath());
                } //for
                
                if(!sObjectfieldList.isEmpty()){
                    // Call createChildMapFieldwithHelpText method to print map on page
                    mapParentFieldApi_HelpText = createChildMapFieldwithHelpText(objSetting.Parent_Sobject_Name__c, sObjectfieldList);
                }
                    
                strQuery =
                        generateQueryString(objSetting.Parent_Sobject_Name__c,
                                            strFieldValue.removeEnd(','),
                                            ' id ',
                                            strSobjectId);

                try {
                        sObjectList = Database.query(strQuery);
                } catch(Exception ex) {
                        showError(ex.getMessage());
                }
            } //if
        }
        /**
         *  A method to form a map of API names of fields and HelpText available in fieldSet
         *  Parameters: Object and List of API names of fields
         *  strObjectName : Object
         *  lstSobjectfieldApi : List of API names of fields
         **/
        public Map<String,String> createChildMapFieldwithHelpText(string strObjectName,List<string> lstSobjectfieldApi) {
            
            // Schema call to get Object information
            Schema.DescribeSObjectResult obj = Schema.getGlobalDescribe().get(strObjectName).getDescribe();
            
            // Map to store API names as Key and HelpText as Value
            Map<String,String> mapFieldApi_HelpText = new Map<String,String>();
            
            // Iterate on API names of fields
            for(String strFieldApi : lstSobjectfieldApi) {
                
                //Schema call to get information of each field
                Schema.DescribeFieldResult fieldResult = obj.Fields.getMap().get(strFieldApi).getDescribe();
                
                if(fieldResult.getInlinehelpText() != null) {
                    // Put HelpText for respective field in Map
                    mapFieldApi_HelpText.put(strFieldApi,fieldResult.getInlinehelpText());
                }
                else {
                    mapFieldApi_HelpText.put(strFieldApi,'');
                }
             
            }   
        
        return mapFieldApi_HelpText;
       }
        /**
         *  A method to add the new Instance of the child record to the  Table of inserting records on the page.
         *  on initialization of the vf page .
         **/
        public void createNewChildRecord() {
            isFileVisible = false;
            strAddNoRecords =  Apexpages.currentpage().getparameters().get(PARAM_ROW_NUMBER);
            if(String.isEmpty(strAddNoRecords)) {
                    strAddNoRecords = '1';
            }

            if(objSetting.Child_Sobject_Name__c != null && objSetting.Child_Sobject_Name__c != '') {

                    SObjectType sobjectType = Schema.getGlobalDescribe().get(objSetting.Child_Sobject_Name__c);
                    
                    if(sobjectType != null ) {
                        Map<String,Schema.SObjectField> mfields = sobjectType.getDescribe().fields.getMap();
                        if(mfields.containsKey(objSetting.Related_Field_API_Name__c)) {

                            for(Integer i = 0; i < Integer.valueOf(strAddNoRecords); i++) {
                                    objChildSobjectTemp = Schema.getGlobalDescribe().get(objSetting.Child_Sobject_Name__c ).getDescribe().sobjectType.newSObject(null,false);
                                    
                                for(integer j=0; j<listChildFieldSetMember.size(); j++) {
                                        Schema.DisplayType fieldType = listChildFieldSetMember[j].getType();
                                        
                                        //checks if the data type of the field in the URL parameter is Date, Datetime, Currency, Double, Integer
                                        if(strChildId.containsKey(listChildFieldSetMember[j].FieldPath))
                                        {
                                            if(fieldType == Schema.Displaytype.Date) {
                                                    objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath,date.parse(strChildId.get(listChildFieldSetMember[j].FieldPath)));
                                                    
                                            }
                                            else if (fieldType == Schema.Displaytype.Datetime) {
                                                    objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath,Datetime.parse(strChildId.get(listChildFieldSetMember[j].FieldPath)));
                                            }
                                            else if (fieldType == Schema.Displaytype.Integer) {
                                                    objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath,integer.valueOf(strChildId.get(listChildFieldSetMember[j].FieldPath)));
                                            }
                                            else if (fieldType == Schema.Displaytype.Currency) {
                                                    objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath,Decimal.valueOf(strChildId.get(listChildFieldSetMember[j].FieldPath)));
                                            }
                                            else if (fieldType == Schema.Displaytype.Double) {
                                                    objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath,Double.valueOf(strChildId.get(listChildFieldSetMember[j].FieldPath)));
                                            }
                                            else {
                                                    objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath,strChildId.get(listChildFieldSetMember[j].FieldPath));
                                            }
                                        }
                                        else {
                                                objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath, objChildSobject.get(listChildFieldSetMember[j].FieldPath));
                                        }
                                }
                                createNewSobjectList.add(new childSobjectWrapper(++rowNumber,objChildSobjectTemp));
                            }
                        }else{
                                isPageVisible = false;
                                showError(Label.Setting_object_Field_Values);
                        }
                    }
            } //if
            isFileVisible = true;
        }
        
        /*
        * Description: This method creates a new cloned row with the same data when clicked on any row
        * Input: 
        * Output: Creates a new duplicate row
         */
        public PageReference addCloneChildRecord() {
            if(objSetting.Child_Sobject_Name__c != null && objSetting.Child_Sobject_Name__c != '') {

                SObjectType sobjectType = Schema.getGlobalDescribe().get(objSetting.Child_Sobject_Name__c);
                if(sobjectType != null ) {

                    Map<String,Schema.SObjectField> mfields = sobjectType.getDescribe().fields.getMap();
                    if(mfields.containsKey(objSetting.Related_Field_API_Name__c)) {
                        if(assignedRowNumber != null){
                        
                            objChildSobjectTemp = Schema.getGlobalDescribe().get(objSetting.Child_Sobject_Name__c ).getDescribe().sobjectType.newSObject(null,false);
                            for(integer j=0; j<listChildFieldSetMember.size(); j++) {
                                Schema.DisplayType fieldType = listChildFieldSetMember[j].getType();
                                objChildSobjectTemp.put(listChildFieldSetMember[j].FieldPath,createNewSobjectList[assignedRowNumber-1].objCreateSobject.get(listChildFieldSetMember[j].FieldPath));
                                
                            }
                            createNewSobjectList.add(new childSobjectWrapper(++rowNumber, objChildSobjectTemp));
                            
                        }
                    }
                }
            } //if
            return null;
        }

        /**
         *  A method retrieve the Setting object Record which values can be used to display the
         *  table on the page and the Id of the setting object is passed to method as a parameter
         *  Parameters:
         *  pSId : The String variable i.e pSId is the Id of the setting which is to be used in
         *         the query.
         **/
        public void retrieveFieldSetObjectRec(){

            List<Settings__c> settingsList =
            [Select Id,
             Parent_Fieldset_Name__c,
             Parent_Sobject_Name__c,
             Parent_Section_Title__c,
             Child_Fieldset_Name__c,
             Child_Sobject_Name__c,
             Related_Field_API_Name__c,
             Child_Section_Title__c,
             Existing_Child_Records_Title__c,
             Child_Display_Name__c,
             Is_Include_Csv__c
             From Settings__c
             Where Id = : strFieldsetObjectAssociationId];

            objSetting = new Settings__c();
            objSettingForDelete = new Settings__c();
            if(settingsList <> null && !settingsList.isEmpty()) {
                    objSetting = settingsList.get(0);
                    objSettingForDelete = settingsList.get(0);
            } //if
        }

        
        
        
        /**
         *  Fetch the Fields or list of the Fields from the child object that are related to the Parent object.
         **/

        public void retrieveChildFieldset(set<Id> setChildIds) {

            String strFieldValue = '';
            String strQuery = '';
            isDeleterMessage = false;
            sobjectExistingChildList = new List<Sobject>();
            sobjectInsertedChildList = new List<Sobject>();
            sObjectChildfieldList = new List<String>();
            listChildFieldSetMember = new List<Schema.FieldSetMember>();
            
            Schema.FieldSet fieldSetObj = retrieveFieldSetObj(objSetting.Child_Sobject_Name__c,objSetting.Child_Fieldset_Name__c);
            try {
                if(fieldSetObj != null && fieldSetObj.getFields() != null && !fieldSetObj.getFields().IsEmpty()) {
                    listChildFieldSetMember = fieldSetObj.getFields();
                    for(Schema.FieldSetMember objFields : fieldSetObj.getFields()) {

                        strFieldValue = String.isBlank(strFieldValue) ?
                                        objFields.getFieldPath() :
                                        strFieldValue + COMMA + objFields.getFieldPath();

                        sObjectChildfieldList.add(objFields.getFieldPath());
                        

                    } //for
                    
                    
                    if(!sObjectChildfieldList.isEmpty()){
                        // Call createChildMapFieldwithHelpText method to print map on page
                        mapChildFieldApi_HelpText = createChildMapFieldwithHelpText(objSetting.Child_Sobject_Name__c, sObjectChildfieldList);
                    }
                    
                    strQuery = generateQueryString(objSetting.Child_Sobject_Name__c,
                                                   strFieldValue.removeEnd(','),
                                                   objSetting.Related_Field_API_Name__c,
                                                   strSobjectId);
                    if(setChildIds != NULL && setChildIds.size() > 0) {

                        strQuery += WHITESPACE + STR_AND;
                        strQuery += WHITESPACE + STR_ID;
                        strQuery += WHITESPACE + STR_IN;
                        strQuery += WHITESPACE + STR_COLON;
                        strQuery += WHITESPACE + 'setChildIds';
                        sobjectInsertedChildList = Database.query(strQuery);

                    }
                    else {
                        fillWrapperList (strQuery); // sobjectExistingChildList = Database.query(strQuery);
                    }
                }
            }
            catch(System.QueryException queryException) {
                    showError(queryException.getMessage());
            }
        }

        public void fillWrapperList (String queryStr) {
            lstChildWrpMap = new Map<Integer, childSobjectEditWrapper> ();
            Integer i = 0;
            for (sObject obj : Database.query(queryStr)) {
                childSobjectEditWrapper childWrp = new childSobjectEditWrapper ();
                childWrp.editRecord = false;
                childWrp.objChildSobject = obj;
                childWrp.rowIndexNo = i;
                lstChildWrpMap.put (i, childWrp);
                lstChildWrp.add (childWrp);
                i++;
            }
        }

        public List<childSobjectEditWrapper> getChildData () {
            if (lstChildWrpMap == null) {return null; }
            return lstChildWrpMap.values();
        }
        /*
           *This method will is used to edit the child object that are related to the Parent object.
         */
        public void editChildFieldset()
        {
            if (rowIndex != null && lstChildWrpMap.containsKey(rowIndex)) {
                if (!lstChildWrpMap.get(rowIndex).editRecord) {
                	lstChildWrpMap.get(rowIndex).editRecord = true;
                }
            }
            getChildData();
        }


        /*
         * Save the Fields or list of the Fields from the child object that are related to the Parent object.
         *
         */

        public void saveChildFieldset() {
            if (rowIndex != null && lstChildWrpMap.containsKey(rowIndex))  {
                lstChildWrpMap.get (rowIndex).editRecord = false;
                update lstChildWrpMap.get(rowIndex).objChildSobject;
            }
        }
        public void cancelChildContact(Integer rowIndex) {
           
            if(rowIndex != null && rowIndex >= 0){
                String strFieldValue = '';
                String strQuery = '';
                sObjectChildfieldList = new List<String>();
                listChildFieldSetMember = new List<Schema.FieldSetMember>();
                Schema.FieldSet fieldSetObj = retrieveFieldSetObj(objSetting.Child_Sobject_Name__c,objSetting.Child_Fieldset_Name__c);
                try {
                    if(fieldSetObj != null && fieldSetObj.getFields() != null && !fieldSetObj.getFields().IsEmpty()) {
                        listChildFieldSetMember = fieldSetObj.getFields();
                        for(Schema.FieldSetMember objFields : fieldSetObj.getFields()) {

                            strFieldValue = String.isBlank(strFieldValue) ?
                                            objFields.getFieldPath() :
                                            strFieldValue + COMMA + objFields.getFieldPath();

                            sObjectChildfieldList.add(objFields.getFieldPath());
                            

                        } //for
                        strQuery = generateQueryString(objSetting.Child_Sobject_Name__c,
                                                       strFieldValue.removeEnd(','),
                                                       objSetting.Related_Field_API_Name__c,
                                                       strSobjectId);
                        
                        strQuery += ' AND ID =\''+ childDataList[rowIndex].objChildSobject.Id + '\'';
                        Sobject cancelObj = Database.Query(strQuery);
                        childDataList[rowIndex].editRecord = false;
                        childDataList[rowIndex].objChildSobject = cancelObj;
                                                  
                    }
                }   
                catch(System.QueryException queryException) {
                        showError(queryException.getMessage());
                } 
            }
            
        }
        public void cancelChildFieldset() {
            if (rowIndex != null && lstChildWrpMap.containsKey(rowIndex))  {
                lstChildWrpMap.get(rowIndex).editRecord = false;
                cancelChildContact(rowIndex);
                
            }
        }
        /**
         * It returns the fielset object based on the object and FieldSetName as a parameter
         * to the method
         * @pstrObjectName: It is the name of the object in which the fieldset is present
         * @pstrFieldSetName: It is the name of the Fieldset that is present for the org
         **/
        public Schema.FieldSet retrieveFieldSetObj(String pstrObjectName,String pstrFieldSetName){

            if(!Schema.getGlobalDescribe().containsKey(pstrObjectName)) {
                isPageVisible = false;
                showError(Label.Setting_object_Field_Values);
                return null;
            } //if

            Schema.DescribeSObjectResult sobjectDescribeResult =
                Schema.getGlobalDescribe().get(pstrObjectName).getDescribe();

            if(!sobjectDescribeResult.FieldSets.getMap().containsKey(pstrFieldSetName)) {
                isPageVisible = false;
                showError(Label.Setting_object_Field_Values);
                return null;
            } //if

            return sobjectDescribeResult.FieldSets.getMap().get(pstrFieldSetName);
        }
        /**
         *  A method to save the record for inserting the child records
         **/
        public PageReference saveChildObject(){
            PageReference objPageReference;
            setInsertedchildId = new Set<Id>();
            List<Sobject> sObjectToInsert = new List<Sobject>();

            if(createNewSobjectList != null && !createNewSobjectList.IsEmpty()) {
                for(childSobjectWrapper objcreateNewSObject : createNewSobjectList) {
                    objcreateNewSObject.objCreateSobject.put(objSetting.Related_Field_API_Name__c, strSobjectId);
                    sObjectToInsert.add(objcreateNewSObject.objCreateSobject);
                }

            } //if
            
            if(sObjectToInsert == null || sObjectToInsert.IsEmpty()) {
                showError(Label.SaveError_Message);
                return null;
            } //if
            try {
                Database.Saveresult[] saveResult = Database.insert(sObjectToInsert);
                    

                if(saveResult[0].isSuccess()) {
                        for(sObject sObj : sObjectToInsert) {
                                setInsertedchildId.add(String.valueOf(sObj.get('Id')));
                        }
                        objPageReference = new pageReference('/' +strSobjectId);
                        objPageReference.setRedirect(true);
                } //if
            } Catch(DMLException ex){
                    ShowError(ex.getMessage());
            }

            return objPageReference;
        }
        
        /**
         *  A method that save the records that are present in the savelist as the child
         *  of the parent object
         **/
        public PageReference showInsertedChildRecords(){
            quickSaveRecords();
            retrieveChildFieldset(setInsertedchildId);
            return null;
        }

        public void quickSaveRecords() {

            sobjectExistingChildList = new List<Sobject>();
            sobjectInsertedChildList = new List<Sobject>();
            sObjectChildfieldList = new List<String>();
            saveChildObject();
            rowNumber = 0;
            createNewSobjectList = new List<childSobjectWrapper>();
            createNewChildRecord();
            isVisible = false;
            isDeleterMessage = false;
        }

        public PageReference quickSaveChildRecords(){
            quickSaveRecords();
            retrieveChildFieldset(NULL);
            return null;
        }


        /**
         * A remoteMethod that deletes the record whose Id is passed down to the method
         * Parameters:
         * @pStrDelObjId : The id of the record that is to be deleted.
         * @pStrChildObjName : Not required.
         **/
        @RemoteAction
        public static String deleteChildRecord(String pStrDelObjId,String pStrchildObjName){
            String strQuery =
                    generateQueryString(pStrchildObjName,
                                        'Id',
                                        'Id',
                                        pStrDelObjId);

            List<Sobject> ListDeletingRec = Database.query(strQuery);

            if(ListDeletingRec != null && !ListDeletingRec.isEmpty()) {

                try {
                    delete ListDeletingRec;
                    return 'true';
                }
                catch(System.DmlException dmlException){
                    return dmlException.getMessage();
                }
            } //if

        return 'true';
        }

        /**
         * Removes the Item records from the list of records which is to be inserted only when the
         * remove link is clicked on the page
         **/
        public Pagereference removeItem(){

            Map<Integer,Integer> mapRemoveRecord = new Map<Integer,Integer>();

            if (this.createNewSobjectList == null || this.createNewSobjectList.isEmpty()) return null;

            Integer cnt = 0;
            for(childSobjectWrapper objCreatenewObject : createNewSobjectList) {
                mapRemoveRecord.put(objCreatenewObject.iRecNo, cnt);
                cnt++;
            } //for

            createNewSobjectList.remove(
                    mapRemoveRecord.get(Integer.valueOf(apexpages.currentpage().getparameters().get(PARAM_INDEX))));
            Integer startIndex = Integer.valueOf(apexpages.currentpage().getparameters().get(PARAM_INDEX));

            for(Integer i = 0; i < createNewSobjectList.Size(); i++) {
            
                createNewSobjectList[i].iRecNo = i+1;
                
            }
            //isDeleterMessage = true;
            isFileUploaded = false;
            rowNumber--;

            return null;
        }
        /**
         * A method that is called when clicked on the Cancel button present on the
         * page Which redirects the user to the previous page from which the page was called.
         **/
        public PageReference cancelItem(){

            String redirectUrl = (strReturnUrl == null ||strReturnUrl == '') ?
                                 ((strSobjectId == null || strSobjectId == '') ? '' : strSobjectId)
                                 : strReturnUrl;
            PageReference objPageReference = new pageReference( '/' + redirectUrl);
            objPageReference.setRedirect(true);
            return objPageReference;
        }

        /**
         *  A method to display the status of the Deletion of record from the page
         **/
        public void displayDeletionMessage(){

            String errorMessage = Apexpages.currentPage().getParameters().get(PARAM_DELETEDERRORMSG);
            ApexPages.Message myMsg = errorMessage.equals(Label.Record_Delete_Confirmation) ?
                                      new ApexPages.Message(ApexPages.Severity.INFO, errorMessage) :
                                              new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
            ApexPages.addMessage(myMsg);
            isDeleterMessage = true;
        }

        /**
         *  A method to display a refereshed list for the childRecords along-with the message on the vf
         *  page after deleting the a child record
         **/
        public void displayDeleteChildMessage(){

            retrieveChildFieldset(NULL);
            isDeleterMessage = true;
        }

        public void displayDeleteChildMessage_QuickSave(){

            retrieveChildFieldset(setInsertedchildId);
            isDeleterMessage = true;
        }

        /**
         *  A method to download .csv file which contains all the fields specified in child filedSet.
         **/

        public PageReference exportDetailReport(){
            strHeaderRowValue = NULL;
            for(String strRowHeader : sObjectChildfieldList) {
                if(strHeaderRowValue != NULL) {
                        strHeaderRowValue += ','+ strRowHeader;
                }
                else {
                        strHeaderRowValue = strRowHeader;
                }
            }
            PageReference nextpage = new PageReference('/apex/ExportChildFieldSetCsv');
            render = 'application/vnd.ms-excel#Insert Child Records.xls';
            return nextpage;
        }

        public Pagereference importCSVFile() {
            //createNewSobjectList= new List<childSobjectWrapper>();
            try {
                if(csvFileBody != NULL) {
                        csvAsString = csvFileBody.toString();
                        csvFileLines = csvAsString.split('\n');
                        //listAccountToInsert = new List<sObject>();
                        strHeaderRow = csvFileLines[0].split(',');

                        for (Integer i = 1; i < csvFileLines.size(); i++) {

                                String[] inputvalues = new String[] {};
                                inputvalues = csvFileLines[i].split(',');

                                sObject sObjectToInsert = Schema.getGlobalDescribe().get(objSetting.Child_Sobject_Name__c).newSObject();

                                for(Integer iField = 0; iField < listChildFieldSetMember.size(); iField++) {
                                        if(strHeaderRow[iField].trim().equalsIgnoreCase(listChildFieldSetMember[iField].getFieldPath())) {

                                                if(listChildFieldSetMember[iField].getType() == Schema.Displaytype.Double) {
                                                        sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), Double.valueOf(inputvalues[iField].trim()));
                                                }
                                                else if(listChildFieldSetMember[iField].getType() == Schema.Displaytype.Integer) {
                                                        sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), Integer.valueOf(inputvalues[iField].trim()));
                                                }
                                                else if(listChildFieldSetMember[iField].getType() == Schema.Displaytype.Currency) {
                                                        sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), Decimal.valueOf(inputvalues[iField].trim()));
                                                }
                                                else if(listChildFieldSetMember[iField].getType() == Schema.Displaytype.Date) {
                                                        try {
                                                                sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), date.parse(inputvalues[iField].trim()));
                                                        }
                                                        catch(Exception e) {
                                                            isVisible = true;
                                                            isDeleterMessage = false;
                                                            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'The column format must be <b> mm/dd/yyyy </b>for the Date field <b>'+listChildFieldSetMember[iField].getFieldPath()+ '</b> in uploaded csv file.');
                                                            ApexPages.addMessage(errorMessage);
                                                        }

                                                }
                                                else if(listChildFieldSetMember[iField].getType() == Schema.Displaytype.Datetime) {
                                                        try {
                                                                sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), Datetime.parse(inputvalues[iField].trim()));
                                                        }
                                                        catch(Exception e) {
                                                            isVisible = true;
                                                            isDeleterMessage = false;
                                                            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'The column format must be <b> mm/dd/yyyy hh:mm AM/PM </b>for the DateTime field <b>'+listChildFieldSetMember[iField].getFieldPath()+ '</b> in uploaded csv file.');
                                                            ApexPages.addMessage(errorMessage);
                                                        }
                                                }
                                                else if(listChildFieldSetMember[iField].getType() == Schema.Displaytype.Boolean) {
                                                        try {
                                                                if(inputvalues[iField].trim().equalsIgnoreCase('Yes')) {
                                                                    sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), Boolean.valueOf('true'));
                                                                }
                                                                else if(inputvalues[iField].trim().equalsIgnoreCase('No')) {
                                                                    sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), Boolean.valueOf('false'));
                                                                }
                                                                else {
                                                                    sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), Boolean.valueOf(inputvalues[iField].trim()));
                                                                }
                                                        }
                                                        catch(Exception e) {
                                                            isVisible = true;
                                                            isDeleterMessage = false;
                                                            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
                                                            ApexPages.addMessage(errorMessage);
                                                        }

                                                }
                                                else {
                                                        try {
                                                            sObjectToInsert.put(listChildFieldSetMember[iField].getFieldPath(), inputvalues[iField].trim());
                                                        }
                                                        catch(Exception e){
                                                            isVisible = true;
                                                            isDeleterMessage = false;
                                                            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
                                                            ApexPages.addMessage(errorMessage);
                                                        }

                                                }
                                        }
                                }
                                isFileUploaded = true;
                                //listAccountToInsert.add(sObjectToInsert);
                                if(createNewSobjectList != NULL && createNewSobjectList.size() > 0) {
                                    if(rowNumber == 1) {
                                            createNewSobjectList.remove(0);
                                    }
                                    createNewSobjectList.add(new childSobjectWrapper(++rowNumber, sObjectToInsert));
                                }
                                else {
                                    createNewSobjectList= new List<childSobjectWrapper>();
                                    createNewSobjectList.add(new childSobjectWrapper(++rowNumber, sObjectToInsert));
                                }
                        }

                        if(rowNumber == 1) {
                            createNewSobjectList.remove(0);
                        }
                        if(createNewSobjectList.size() < 1) {
                            isVisible = true;
                            isDeleterMessage = false;
                            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Empty file found.');
                            ApexPages.addMessage(errorMessage);
                        }
                        csvFileBody = NULL;
                }
                    else {
                            isVisible = true;
                            isDeleterMessage = false;
                            if(!(createNewSobjectList != NULL && createNewSobjectList.size() > 0)) {
                                    createNewChildRecord();
                            }
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'No file selected for uploading bulk records!');
                            ApexPages.addMessage(errormsg);
                    }
            }
            catch (Exception e) {
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
                    ApexPages.addMessage(errormsg);
            }
            return null;
        }


        /**
         * A wrapper class which consist of two variables one for the sobject whose record needs to be
         * inserted and one for providing the proper number to the records.
         **/
        public class childSobjectWrapper {

            public Integer iRecNo {get; set; }
            public sObject objCreateSobject {get; set; }

            public childSobjectWrapper(Integer pRecNo, sObject pobjCreateSobject){
                iRecNo = pRecNo;
                objCreateSobject = pobjCreateSobject;
            }
        } //childSobjectWrapper ends

        /**
         * A wrapper class which consist of two variables one for the sobject whose record needs to be
         * edited and saved.
         **/
        public class childSobjectEditWrapper {

            public Boolean editRecord {get; set; }
            public Integer rowIndexNo {get; set; }
            public sObject objChildSobject {get; set; }

        } //childSobjectEditWrapper ends
}