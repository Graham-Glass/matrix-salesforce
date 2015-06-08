public class MatrixTabController {

    public user currentuser{get;set;}
    public String iframe_src{get;set;}
    
    public MatrixTabController() {
        currentuser = new User();
        currentuser = [Select Id, Name, Email, matrixlms__Matrix_Password__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Username__c, matrixlms__Portal_URL__c from User where Id=:userinfo.getuserId()];
        
        List<matrixlms__Matrix_Setting__c> check_portal = [Select matrixlms__Value__c from matrixlms__Matrix_Setting__c where Name = 'portalUrl' AND matrixlms__Value__c != ''];
        List<User> check_password = [Select matrixlms__Matrix_Password__c from User where Id=:userinfo.getuserId() AND matrixlms__Matrix_Password__c != ''];
        
        iframe_src = 'https://www.matrixlms.com/app/launch?salesforce=true&salesforce_userid='+currentuser.Id;
        if(!check_portal.isEmpty()){
            if(!check_password.isEmpty()){
                iframe_src = check_portal.get(0).Value__c.replace('?salesforce=true', 'log_in/submit?userid='+currentuser.Matrix_Username__c+'&password='+currentuser.Matrix_Password__c+'&salesforce=true&salesforce_userid='+currentuser.Id);
            }else{
                iframe_src = check_portal.get(0).Value__c+'&salesforce_userid='+currentuser.Id;
            }
        }
    }

}