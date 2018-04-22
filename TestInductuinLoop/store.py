

# This python script will create a dictionnary containing : { DetectorName : (speed,NbOfVehicles), ... }
# And save this dictionnry in a .txt file -> formattedDict.txt (see pickle library for more details)

import pickle


def initRealDataDico(file):

	with open(file,'r',encoding='utf-8') as f1:

		realDataDictionnary = {}

		for line in f1:
			if line[0] != ',':
				line = line.split(';')
				detector = line[0]
				speed = line[1]
				nbOfVeh = line[2] 
				
				realDataDictionnary[detector] = (float(speed),int(nbOfVeh))

	return realDataDictionnary


dico = initRealDataDico("formatted.txt")

with open("formattedDict.txt","wb") as f2:
	pickle.dump(dico,f2)