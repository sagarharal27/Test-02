/************************************************************************
 Class Name: active_user_map
 Created Date:14/7/2015
 Description: performs map on account findind active user
*************************************************************************/ 
public with sharing class activeUserMap {
    //selecting active users
	public void displayingActiveUser(){
		list<user> listuser= [select Id,Username from user where IsActive=TRUE];
        //null check of list
        if(listuser!=null && listuser.size()>0){
			map<Id,User> mapActiveUser=new map<Id,User>();
            for(User userobj:listuser){
				mapActiveUser.put(userobj.Id,userobj);
            }
			system.debug(mapActiveUser+'Active users');
        }
        else{
            system.debug('Records not found');
        }
	}
}