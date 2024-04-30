Class ImageSearchVideo.Util.VideoToImg
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS;

ClassMethod VideoToImage(videopath, vedioname, dstfolder, index, FREQUENCY) As %String [ Language = python ]
{
    import os
    import cv2
    import shutil
    import time
    video = cv2.VideoCapture(videopath)
    frame_count = 0
    EXTRACT_FREQUENCY =FREQUENCY
    resultjson="["
    # 循环遍历视频中的所有帧
    while True:
        # 逐帧读取
        _, frame = video.read()
        
        if frame is None:
            break
        milliseconds = video.get(cv2.CAP_PROP_POS_MSEC)
        seconds = milliseconds//1000
        milliseconds = milliseconds%1000
        minutes = 0
        hours = 0
        if seconds >= 60:
          minutes = seconds//60
          seconds = seconds % 60

        if minutes >= 60:
          hours = minutes//60
          minutes = minutes % 60
        TimeString=str(int(hours))+"-"+str(int(minutes))+"-"+str(int(seconds))+"-"+str(int(milliseconds))
        
        
        #print("Time:",int(hours), int(minutes), int(seconds), int(milliseconds))
        # 按照设置的频率保存图片
        if frame_count % EXTRACT_FREQUENCY == 0:
            # 设置保存文件名
            save_path = "{}/{}{}.jpg".format(dstfolder, vedioname,index)
            resultjson=resultjson+'"'+TimeString+'",'
            # 保存图片
            cv2.imwrite(save_path, frame)
            index += 1  # 保存图片数＋1
        frame_count += 1  # 读取视频帧数＋1

    # 视频总帧数
    #print(f'the number of frames: {frame_count}')
    # 打印出所提取图片的总数
    
    #print("Totally save {:d} imgs".format(index - 1))
    
    # 计算FPS 方法一 get()
    (major_ver, minor_ver, subminor_ver) = (cv2.__version__).split('.')  # Find OpenCV version
    # (major_ver, minor_ver, subminor_ver) = (4, 5, 4)
    if int(major_ver) < 3:
        fps = video.get(cv2.cv.CV_CAP_PROP_FPS)  # 获取当前版本opencv的FPS
        #print("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
    else:
        fps = video.get(cv2.CAP_PROP_FPS)  # 获取当前版本opencv的FPS
        #print("Frames per second using video.get(cv2.CAP_PROP_FPS) : {0}".format(fps))
    resultjson=resultjson+'""]'    
    return str(index-1)+":"+str(frame_count)+":"+str(fps)+":"+resultjson
}

ClassMethod ImageToVector(imagename) As %String [ Language = python, SqlProc ]
{
  from PIL import Image
  from numpy import average, dot, linalg
  from skimage import feature
  image = Image.open(imagename)
  image = image.resize((290, 220), Image.Resampling.LANCZOS)
  greyscale=True
  vector = []
  if greyscale:
        # 将图片转换为L模式，其为灰度图，其每个像素用8个bit表示
     image = image.convert('L')
     
     for pixel_tuple in image.getdata():
            vector.append(average(pixel_tuple))
            #print(vector)
     #print(len(vector))
  return str(vector)
}

ClassMethod VectorInsert(Time, videoname, image) As %Status
{
	
	     
	
	    set Query="Insert into ImageSearchVideo.VectorMSG(TimeS,VideoName,ImageName,ImageVector) Values(?,?,?, TO_VECTOR(ImageSearchVideo_Util.VideoToImg_ImageToVector(?),double))"
        set sc=$$$OK
        set tStatement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(tStatement.%Prepare(Query))
        set rset = tStatement.%Execute(Time,videoname,image,image)
        if (rset.%SQLCODE < 0) {  
                throw ##class(%Exception.SQL).CreateFromSQLCODE(rset.%SQLCODE,rset.%Message)
        }
}

ClassMethod SelectVideoName(image) As %String
{
	set queryStr="select top 1 * from (select id,VideoName,TimeS,VECTOR_COSINE(TO_VECTOR(demo.ImageVector,double), (TO_VECTOR(ImageSearchVideo_Util.VideoToImg_ImageToVector(?),double))) as sim from ImageSearchVideo.VectorMSG as demo )t order by sim desc"
	Set statement1 = ##class(%SQL.Statement).%New()
	
	
	Set qStatus = statement1.%Prepare(queryStr)

	Set rset1 = statement1.%Execute(image)
	set resultname=""
	if rset1.%Next(){
		
		set resultname= rset1.%Get("VideoName")_":"_rset1.%Get("TimeS")_":"_rset1.%Get("sim")
	}
	
	Quit resultname
}
ClassMethod zpminitialization() As %Status
{
	///
	new $namespace
    set $namespace = "%sys"
	Set Application=##Class(Security.Applications).%OpenId("/csp/user")
	set Application.ServeFiles=2
	Set tsc= Application.%Save()

	Quit tsc
}
}

