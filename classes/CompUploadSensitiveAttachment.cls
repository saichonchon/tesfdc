/**
 *  Component controller for Component:CompUploadSensitiveAttachment
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

public with sharing class CompUploadSensitiveAttachment {

	/**
	 * variable that point to class ExtUploadSensitiveAttachment
	 */		
	public ExtUploadSensitiveAttachment extUploadSensitiveAttachment;

	/**
	 * This method is a get Method for Object ExtUploadSensitiveAttachment
	 *
	 @author Yinfeng Guo
	 @created 2012-02-14
	 @version 1.0
	 @since 23.0
  	 *
	 @return         ExtUploadSensitiveAttachment object	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */		
	public ExtUploadSensitiveAttachment getExtUploadSensitiveAttachment() {
		return extUploadSensitiveAttachment; 
	}

	/**
	 * This method is a set Method for Object ExtUploadSensitiveAttachment
	 *
	 @author Yinfeng Guo
	 @created 2012-02-14
	 @version 1.0
	 @since 23.0
  	 *
  	 @param extUploadSensitiveAttachment			ExtUploadSensitiveAttachment object
	 @return         							void	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	
	public void setExtUploadSensitiveAttachment(ExtUploadSensitiveAttachment extUploadSensitiveAttachment) {
		this.extUploadSensitiveAttachment = extUploadSensitiveAttachment;
	}
	
}