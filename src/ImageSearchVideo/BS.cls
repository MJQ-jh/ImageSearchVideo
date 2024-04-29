Class ImageSearchVideo.BS Extends Ens.BusinessService
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS;

Method OnProcessInput(request As ImageSearchVideo.request, Output response As Ens.StringResponse) As %Status
{
	    
	    Set tSC=..SendRequestAsync("ImageSearchVideo.BussinessProcess",request,.response)
	    Quit $$$OK
}

// 获取到txt文本内容后存储到指定文件夹

// 逐段存入数据库

}

