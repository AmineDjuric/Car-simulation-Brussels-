import glob
import xml.etree.ElementTree as ET


with open("tmp.txt",'a') as f1:
	f1.write(",VirtualSpeed;DetectorName;"+'\n')	
 
	for filename in glob.glob('*.xml'):

		data = {}

		tree = ET.parse(filename)
		root = tree.getroot()
		child = root.getchildren()

		data = child[0].attrib
		virtualSpeed = data['speed']
		detectorName = data['id']

		print(virtualSpeed,detectorName)
		#f1.write(str(virtualSpeed) + str(detectorName) + '\n')



