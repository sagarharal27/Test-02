public with sharing class SOQL_freeTimeWrapper {
    public List<WrapperClassClient> lstWrapperClient{get; set;}
    
    public Map<Id, dreamMap__Client__c> mapOfClient;
    public Map<Id, List<dreamMap__Project_Details__c>> mapOfClientToProject;
    public Map<Id, List<dreamMap__Work__c>> mapOfProjectToWork;
    
    public SOQL_freeTimeWrapper() {
        mapOfClient = new Map<Id, dreamMap__Client__c>();
        mapOfClientToProject = new Map<Id, List<dreamMap__Project_Details__c>>();
        mapOfProjectToWork = new Map<Id, List<dreamMap__Work__c>>();
        getAllRecords();
        
    }
    
    public void getAllRecords() {
        mapOfClient = new Map<Id, dreamMap__Client__c>([select Id, Name from dreamMap__Client__c]);
        System.debug('mapOfClient======'+mapOfClient);
        
        List<dreamMap__Project_Details__c> lstProjects = [select Id, Name, dreamMap__Client__c
                                                          from dreamMap__Project_Details__c
                                                          where dreamMap__Client__c 
                                                          IN :mapOfClient.keySet()];
       
       
       for(dreamMap__Project_Details__c projects : lstProjects) {
           if(mapOfClientToProject.containsKey(projects.dreamMap__Client__c)) {
               mapOfClientToProject.get(projects.dreamMap__Client__c).add(projects);
           }
           else{
               mapOfClientToProject.put(projects.dreamMap__Client__c, new List<dreamMap__Project_Details__c>{projects});
           }
        }
        System.debug('mapOfClientToProject======'+mapOfClientToProject);
        
        List<dreamMap__Work__c> lstWorks = [select Id, Name,dreamMap__Project__c
                                            from dreamMap__Work__c
                                            where dreamMap__Project__c
                                            IN :lstProjects];
        for(dreamMap__Work__c works : lstWorks){
            if(mapOfProjectToWork.containsKey(works.dreamMap__Project__c)) {
                mapOfProjectToWork.get(works.dreamMap__Project__c).add(works);
            }
            else{
                mapOfProjectToWork.put(works.dreamMap__Project__c, new List<dreamMap__Work__c>{works});
            }
        }
        System.debug('mapOfProjectToWork======'+mapOfProjectToWork);
        fillWrapper();
    }
    
    public void fillWrapper() {
        
        lstWrapperClient = new List<WrapperClassClient>();
        List<WrapperClassProject> lstWrapperProject = new List<WrapperClassProject>();
        
        for(dreamMap__Client__c clientObj : mapOfClient.values()) {
            WrapperClassClient wrapperClientInstance = new WrapperClassClient();
            wrapperClientInstance.clientInstance = clientObj;
            
            if(mapOfClientToProject.containsKey(clientObj.Id)){
                
	            for(dreamMap__Project_Details__c projectObj : mapOfClientToProject.get(clientObj.Id)) {
	               
	                WrapperClassProject wrapperProjectInstance = new WrapperClassProject();
	                wrapperProjectInstance.projectInstance = projectObj;
	                
	                if(mapOfProjectToWork.containsKey(projectObj.Id)){
	                    wrapperProjectInstance.lstWorkWrapper.addAll(mapOfProjectToWork.get(projectObj.Id));
	                } // close this if here as it should display Projects though its not having works
	                
	                lstWrapperProject.add(wrapperProjectInstance);
	  
	            }
	            wrapperClientInstance.lstProjectWrapper.addAll(lstWrapperProject);
            } // close this if here as it should display clients though its not having projects
	        
	        lstWrapperProject = new List<WrapperClassProject>();
	        lstWrapperClient.add(wrapperClientInstance);
        }
        System.debug('lstWrapperClient========'+lstWrapperClient);
    }
    
    public class WrapperClassClient{
        public dreamMap__Client__c clientInstance {get; set;}
        public List<WrapperClassProject> lstProjectWrapper {get; set;}
        
        public WrapperClassClient(){
            lstProjectWrapper = new List<WrapperClassProject>();
        }
    }
    
    public class WrapperClassProject {
        public dreamMap__Project_Details__c projectInstance {get; set;}
        public List<dreamMap__Work__c> lstWorkWrapper {get; set;} 
        
        public WrapperClassProject() {
            lstWorkWrapper = new List<dreamMap__Work__c> ();
        }
    }
}