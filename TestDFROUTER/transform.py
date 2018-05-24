# Author: Djuric Amine
# Date: 05/04/2018

def getAddress(line):
	# Récupère l'addresse en francais

	address = line[-1]
	address = address.split("Reverse ")
	address = address[1]
	address = address[1:-3]
	address = address.split(" - ")
	address = address[0]
	return address

def convertTime(string):
	# Converti une heure en minutes 
	# exemple d'input -> 2017-10-17 03:00:00

	string = string.split() # on ne prend pas la date
	string = string[1]      # on prend l'heure
	tmp_list= string.split(':')

	hour = int(tmp_list[0])
	minutes = int(tmp_list[1])
	result = (hour * 60) + minutes 

	return result


def initDico(dico,matrix):
	# Permet d'avoir un détecteur par adresse 

	i = 1
	for elem in matrix:
		if elem[0] not in dico:
			# si l'adresse n'est deja pas dans le dico
			dico[elem[0]] = "det" + str(i)
			i += 1

	print(len(dico))

def createCSV(dico,matrix):
	# Créer un fichier CSV que DFROUTER peut lire

	with open('dataTEST.csv','w') as f2:
		f2.write("Detector;Time;qPKW;vpkw;" + '\n')
		for elem in matrix:
			f2.write(dico[elem[0]]+';'+str(elem[1])+';'+'1'+';'+str(elem[2])+'\n')
			

def convertGiovanniFileInCSV(file):

	with open(file,'r') as f1:

		matrix = [] # cette matrice contient ->  [address,time,speed]
		dico = {}  # ce dico(K,V) Key -> address, Value -> det n° i

		for line in f1:
			if line[0] != ',':
				line = line.split(',')

				tmp_list = []
				address = getAddress(line)
				avg_speed = float(line[5])

				if avg_speed == 0.0:
					avg_speed += 5

				time = convertTime(line[1])

				tmp_list.append(address)
				tmp_list.append(time)
				tmp_list.append(avg_speed)
				matrix.append(tmp_list)

		initDico(dico,matrix)
		createCSV(dico,matrix)
	

convertGiovanniFileInCSV("1hour_data_port_area.csv")
