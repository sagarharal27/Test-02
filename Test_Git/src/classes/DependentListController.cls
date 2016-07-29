/***************************************************************************************************
 Class Name: DependentListController
 Created Date:2/8/2015
 Description: This controller is used to display Cities of respective countries in VF page
***************************************************************************************************/  

public with sharing class DependentListController {
    
    public String City{ get; set; }
    public String country{ get; set;}
    Map<String, CustomCity__c> mapOfCity;
    
    public DependentListController() {
        //Map of String(Country) and respective cities 
        mapOfCity = CustomCity__c.getall();
    }
    
    //Method to get list of city 
    public List<selectoption> getCityList() {
        //List of collection of selected items
        List<selectOption> selectList = new List<selectOption> ();
        selectList.add(new selectoption('','---None---'));
        //Null check for country 
        if(country==null){
            country='';
        }
        else
            if(mapOfCity != null) {
                //Checking for country in map,if country is present
                if(mapOfCity.containskey(country)) {
                    //clear the selectList
                    selectList.clear();
                    //Get all the cities related to that country
                    string strCityOfCountry = mapOfCity.get(country).City__c;
                    //Getting the list of cities separated by , 
                    for(string strCity : strCityOfCountry.split(','))
                        //Add those cities to the list
                        selectList.add(new selectoption(strCity,strCity));
                    }
            }
            return selectList;
    }
    // Method to get country
    public List<SelectOption> getCountrylist() {
        //List of collection of selected items
        List<SelectOption> countryList = new List<SelectOption>();
        countryList.add(new selectoption('','---None---'));
        
        // Creating List of country name 
        List<string> countryname= new List<string>(); 
        //adding all cities to the country 
        countryname.addall(mapOfCity.keyset());
        
        //Iterate to list of country for country
        for(string strCountry : countryname){
            //Adding that country to the list
            countryList.add(new selectoption(strCountry,strCountry));
        }
        return countryList;
    }
}