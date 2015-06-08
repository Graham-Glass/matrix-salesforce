public class UserDashboardController {
    public user currentuser{get;set;}
    public String content{get;set;}

    public UserDashboardController() {
        currentuser = new User();
        currentuser = [Select Id, Name, Email, matrixlms__Matrix_Password__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Username__c, matrixlms__Portal_URL__c from User where Id=:userinfo.getuserId()];

        List<User> check_matrix_userid = [Select matrixlms__Matrix_Userid__c from User where Id=:currentuser.Id AND matrixlms__Matrix_Userid__c != ''];
        List<matrixlms__Matrix_Setting__c> check_api_key = [Select matrixlms__Value__c from matrixlms__Matrix_Setting__c where Name = 'apiKey'];
        
        String error_message = 'Please contact your administrator to set up a MATRIX account for you.';
        
        if(!check_api_key.isEmpty()){
            matrixlms__Matrix_Setting__c api_key = check_api_key.get(0);
            if(api_key.matrixlms__Value__c != null && api_key.matrixlms__Value__c.length() > 0){
                matrixlms__Matrix_Setting__c school_id = [Select matrixlms__Value__c from matrixlms__Matrix_Setting__c where Name = 'schoolId'];
                if(!check_matrix_userid.isEmpty()){
                    User matrix_userid = check_matrix_userid.get(0);
                    content = '<iframe id="matrixDetailsFrame" frameborder="0" width="100%" height="300" src="https://www.matrixlms.com/salesforce/user_details?userid='+matrix_userid.matrixlms__Matrix_Userid__c+'&api_key='+api_key.matrixlms__Value__c+'&school_id='+school_id.matrixlms__Value__c+'"></iframe>';
                }else{
                    content = error_message;
                }
            }else{
                content = error_message;
            }
        }else{
            content = error_message;
        }
    }
    
}