/**
 *  This class used to export csv file
 *
 @author Minghao Li
 @created 2014-09-23
 @version 1.0
 @since 30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-09-23 Minghao Li <minghao.li@itbconsult.com>
 * - Created
 */
public with sharing class CtrlCSDExportCSVFile {
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public transient String jsons{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CtrlCSDExportCSVFile(){
		this.jsons='';
		String fileName = 'sample_'+(system.today().year()+'-'+system.today().month()+'-'+system.today().day()) + '.csv';
		
		if(Apexpages.currentPage().getParameters().get('exp') != null || Apexpages.currentPage().getParameters().get('exp') != ''){
			this.jsons = Apexpages.currentPage().getParameters().get('exp')+'';
		}

	//	Apexpages.currentPage().getHeaders().put('Pragma', 'No-cache');
	//	Apexpages.currentPage().getHeaders().put('Cache-Control', 'No-cache');
		Apexpages.currentPage().getHeaders().put('Pragma', 'public');
		Apexpages.currentPage().getHeaders().put('Expires', '0');
		Apexpages.currentPage().getHeaders().put('Cache-Control', 'must-revalidate, post-check=0, pre-check=0');
		Apexpages.currentPage().getHeaders().put('Cache-Control', 'private');
		Apexpages.currentPage().getHeaders().put('Content-Disposition', 'attachment; filename=\"'+fileName+'\";');
		Apexpages.currentPage().getHeaders().put('Content-Transfer-Encoding', 'binary'); 
		Apexpages.currentPage().getHeaders().put('Content-Length', this.jsons.length()+'');
		
	//	.getParameters().put('Content-Disposition','attachment;filename=exportcsvfile.csv');
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- /////////////////////////////////////
}