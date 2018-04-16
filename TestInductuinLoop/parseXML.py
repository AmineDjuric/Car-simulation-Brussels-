import sys
import pickle
import xml.etree.ElementTree as ET

# Ce fichier va parser un fichier xml et comparer les données récupérées 
# avec les données réelles. Le résultat de cette comparaison sera stocker dans un fichier


def loadDict(file):
# Récupère le dictionnaire stocker dans un fichier txt grâce à la bibliothèque pickle
	with open(file, "rb") as f1:
		realDataDict = pickle.load(f1)

	return realDataDict

def getDetectorName(NameOfFile):
	# Récupère le nom du detecteur à partir du fichier
	# Ce nom de détecteur est la clé du dictionnaire contenant les
	# données réelles
	
	detectorName = XMLfile.split('/')
	detectorName = detectorName[-1]
	detectorName = detectorName[:-11]
	
	return detectorName


def compute(realSpeed,virtualSpeed):
	return ((float(virtualSpeed) - float(realSpeed))**2 ) / 2


# contient le nom du fichier d'output de l'induction loop sur lequel 
# nous somme en train de travailler
XMLfile = sys.argv[1]
iterationNb = int(sys.argv[2]) # on récupère le n° de l'itération

detectorName = getDetectorName(XMLfile)

# 1 ere chose à faire, récupérer le dictionnaire stocké 
# dans formattedDict.txt et en faire une variable

realDataDict = loadDict("formattedDict.txt")


tree = ET.parse(XMLfile)
root = tree.getroot()
child = root.getchildren()

data = child[0].attrib # return un dictionnaire avec les attributs du fichier xml.

virtualSpeed = data['speed']
virtualNbOfVeh = data['nVehContrib']

realSpeed = realDataDict[detectorName][0]
realNbOfVeh =  realDataDict[detectorName][1] # on récupère le nombre de voiture qui sont passé durant l'interval (ici 14h -> 50400 sec)

# print("Vistesse reelle",realSpeed,"Vitesse simulee",virtualSpeed)

result = compute(realSpeed,virtualSpeed)

with open("results.txt",'a') as f2:
	string = "Result: " + str(result) + ' ; ' + "iterationNb: " + str(iterationNb) + '\n'
	f2.write(string)


