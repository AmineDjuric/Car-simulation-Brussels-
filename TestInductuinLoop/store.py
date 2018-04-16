
# Ce code va prendre le fichier "formatted.txt", le transformer en dictionnaire et
# Ensuite stocker ce dictionnaire dans un fichier pour éviter qu'il soit recalculer à chaque parsing
# de fichier XML

import pickle


def initRealDataDico(file):
	""" Cette méthode va parcourir le fichier contenant les données
		réelles mesurées et va les stocker dans un dictionnaire de type:
		{ DetectorName : (speed,NbOfVehicles), ... } """

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
	pickle.dump(dico,f2) # on stocker le dictionnaire dans ce fichier txt