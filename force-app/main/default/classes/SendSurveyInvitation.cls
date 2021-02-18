public class SendSurveyInvitation {
    
    @AuraEnabled
    public static void sendSurvey(String conId){
        SurveyInvitation inv;
        List<reference__c> refs = new List<reference__c>([SELECT Id, Name, Reference_Name__c, Employer__c, Contact_Number__c, Title__c, Email__c, Relationship_with_Candidate__c, Other_Information__c, Employee__c, Survey_Send_Status__c FROM reference__c where employee__c=:conId]);
        if(!refs.isEmpty()){
            reference__c rc = refs[0];
            inv = new surveyInvitation();
            inv.name = 'Referral Survey';
            inv.SurveyId = '0Kd4W000003BVZbSAO';
            inv.CommunityId='0DB4W0000016KE0WAM';
            inv.Reference_Check__c = rc.id;
            inv.OptionsAllowGuestUserResponse = true;
            insert inv;
            
            String invlink = [select InvitationLink from surveyInvitation where id=:inv.id limit 1].InvitationLink;
            
            contact con = [select id,firstname,lastname from contact where id=:conId];
            con.Send_survey_Status__c = 'Sent';
            update con;
            
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            mail.setToAddresses(new string[]{rc.Email__c});
            mail.setSubject('Referral feedback survey');
            mail.setSenderDisplayName('GovTech');
            String body = 'Dear ' + rc.Reference_Name__c + ', <br/><br/><br/>';
            body += con.FirstName + con.lastName + ' would like to seek your reference for a job application. Please fill the following survey. <br/> <br/>';
            body += invlink + '<br/><br/>';
            body +='Thanks<br/>';
            body +='GovTech';
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        }  
    }
}