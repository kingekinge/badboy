require("Utils")


function tap(x,y)
touchDown(1, x, y)
mSleep(50)
touchUp(1, x, y)
end


init("0", 0); --	屏幕方向，0 - 竖屏， 1 - Home键在右边， 2 - Home键在左边
setUIOrientation(0)


ret,results = showUI("ui.json")

if(ret== 1) then 
  sysLog("下一步")
	showUI("ui2.json")
else
  sysLog("取消")
	end


--0 - 取消；1 - 确定
sysLog(ret)


for k, v in pairs(results) do
  
  sysLog(k.."---"..v)
  if(k=="select_function") 
  then
       local arr=Utils.split(v,"@")
     for k,v in pairs(arr)
     do 
		    sysLog("用户选择")
        sysLog(k.."---"..v)
    end
     
  end
	
   
end


x, y = findColorInRegionFuzzy(0x1d7af3, 100, 217, 222, 256, 267)
if x > -1 then
	tap(x,p)
end
 dialog("没有",0)









