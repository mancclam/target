#/bin/python

#file = open('/shell/output.txt','w')
count=0
for i in range(129,255):
  for j in range(1,255):
    fault = "172.20."+str(i)+"."+str(j)+"\n"
    print(fault)
    #file.write(fault)
    count = count + 1
if count >= 3230:
  break
#file.close()
