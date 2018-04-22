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
iterationNb = int(sys.argv[2]) # on récupère le n° de l'itération

detectorName = getDetectorName(XMLfile)

realDataDict = loadDict("formattedDict.txt")

data = parseXML(XMLfile)

virtualSpeed = data['speed']
virtualNbOfVeh = data['nVehContrib']

realSpeed = realDataDict[detectorName][0]
realNbOfVeh =  realDataDict[detectorName][1]

result = compute(realSpeed,virtualSpeed)

with open("Results/"+str(iterationNb)+".csv",'a') as f2:
	string = str(result) + ';' + detectorName + '\n'
	f2.write(string)
