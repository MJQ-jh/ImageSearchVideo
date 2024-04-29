Class ImageSearchVideo.BO Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS;

Method OnMessage(request As ImageSearchVideo.request, Output response As Ens.StringResponse) As %Status
{
	
	SET dstfolder="/usr/irissys/mgr/user/images"
    set re=##class(ImageSearchVideo.Util.VideoToImg).VideoToImage(request.fullurl,$p(request.filename,".",1),dstfolder,1,30)
    set num=$p(re,":",1)
    set time=$p(re,":",2)/$p(re,":",3)
    
    set timeArr=[].%FromJSON($p(re,":",4))
    //$$$LOGINFO(num)
    for i=1:1:num
	{
		//set time=
		Do ##class(ImageSearchVideo.Util.VideoToImg).VectorInsert(timeArr.%Get((i-1)),request.fullurl,dstfolder_"/"_$p(request.filename,".",1)_i_".jpg")
		do ##class(%File).Delete(dstfolder_"/"_$p(request.filename,".",1)_i_".jpg",.a)
	}
    set response=##class(Ens.StringResponse).%New()
    set response.StringValue=num_" pieces of data have been added successfully"
	Quit $$$OK
}

}

