import sys
import pickle
import xml.etree.ElementTree as ET


def loadDict(file):
	# Get back the dictionary containing the real data stored in a file txt thanks to the pickle library
	with open(file, "rb") as f1:
		realDataDict = pickle.load(f1)

	return realDataDict

def getDetectorName(NameOfFile):
	# Get back the name of the detector from the file
	# This name of the detector is the key of the dictionary containing real data
	
	detectorName = XMLfile.split('/')
	detectorName = detectorName[-1]
	detectorName = detectorName[:-11]
	
	return detectorName


def compute(realSpeed,virtualSpeed):

	return ((float(virtualSpeed) - float(realSpeed))**2 ) / 2


def parseXML(file):
	# Parsing of the outputs files of the inductions loops
	# For more details, see: 
	# http://sumo.dlr.de/wiki/Simulation/Output/Induction_Loops_Detectors_(E1)#Generated_Output

	tree = ET.parse(file)
	root = tree.getroot()
	child = root.getchildren()

	return child[0].attrib # return un dictionnaire avec les attributs du fichier xml.
	# return a dictionnary with the attributes of the xml file



XMLfile = sys.argv[1]
folderNb = sys.argv[2]
subFolderNb = sys.argv[3]

detectorName = getDetectorName(XMLfile)

realDataDict = loadDict("formattedDict.txt")

data = parseXML(XMLfile)

virtualSpeed = data['speed']
#virtualNbOfVeh = data['nVehContrib']

realSpeed = realDataDict[detectorName][0]
#realNbOfVeh =  realDataDict[detectorName][1]


if float(virtualSpeed) < 0:
	virtualSpeed = 13.8 # quand on a pas de valeur pour la virtual speed (car détecteur à -1, on le met à 50km/h -> 13.8 m/s)

result = compute(realSpeed,virtualSpeed)


with open("Results1/"+ folderNb + '__' + subFolderNb +".csv",'a') as f2:
	string = str(result) + ';' + detectorName + '\n'
	f2.write(string)

with open("Results2/"+ folderNb + '__' + subFolderNb +".csv",'a') as f3:
	string = str(virtualSpeed) + ';' + detectorName + '\n'
	f3.write(string)