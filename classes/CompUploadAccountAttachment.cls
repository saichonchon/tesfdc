/**
 *  Component controller for Component:CompUploadAccountAttachment
 *  
 * @author Yinfeng Guo
 * @created 2012-02-14
 * @version 1.0
 * @since 23.0
 * 
 *
 * @changelog
 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */


public with sharing class CompUploadAccountAttachment {

	/**
	 * variable that point to class ExtUploadAccountAttachment
	 */	
	public ExtUploadAccountAttachment extUploadAccountAttachment;

	/**
	 * This method is a get Method for Object ExtUploadAccountAttachment
	 *
	 @author Yinfeng Guo
	 @created 2012-02-14
	 @version 1.0
	 @since 23.0
  	 *
	 @return         ExtUploadAccountAttachment object	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */		
	public ExtUploadAccountAttachment getExtUploadAccountAttachment() {
		return extUploadAccountAttachment; 
	}

	/**
	 * This method is a set Method for Object ExtUploadAccountAttachment
	 *
	 @author Yinfeng Guo
	 @created 2012-02-14
	 @version 1.0
	 @since 23.0
  	 *
  	 @param extUploadAccountAttachment			ExtUploadAccountAttachment object
	 @return         							void	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */		
	public void setExtUploadAccountAttachment(ExtUploadAccountAttachment extUploadAccountAttachment) {
		this.extUploadAccountAttachment = extUploadAccountAttachment;
	}
	
}