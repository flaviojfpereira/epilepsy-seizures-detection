def convert():
	f=open("linhas.txt", "w")
	r=open("linhas?fim.txt", "r")
	lines=f.readlines()
	result=[]
	for x in lines:
		result.append(int((int(x)-31656837)/60/60/24/7))

	for x in result:
		r.write(str(x+1)+"\n")



convert()