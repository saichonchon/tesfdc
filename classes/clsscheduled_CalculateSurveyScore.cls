/**
*  This class used for scheduling batch class clsBatch_CalculateSurveyScore.
*
@author Pankaj Raijade
@created 4/2/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/2/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
*/
global class clsscheduled_CalculateSurveyScore implements Schedulable 
{
    Batch_size_setting__c oBatchsize = Batch_size_setting__c.getInstance('clsBatch_CalculateSurveyScore');
    
    global void execute(SchedulableContext sc) 
    {
        if(oBatchsize != null && oBatchsize.Batch_size__c != null && oBatchsize.Batch_size__c > 0)
        {
            clsBatch_CalculateSurveyScore oclsBatch_CalculateSurveyScore = new clsBatch_CalculateSurveyScore();
            database.executeBatch(oclsBatch_CalculateSurveyScore, (Integer)oBatchsize.Batch_size__c);
        }
        else
        {
            clsBatch_CalculateSurveyScore oclsBatch_CalculateSurveyScore = new clsBatch_CalculateSurveyScore();
            database.executeBatch(oclsBatch_CalculateSurveyScore, 100);
        }
    }
}