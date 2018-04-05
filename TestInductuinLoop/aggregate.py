
# Djuric Amine
# Aggrégation du nombre de camions et leur vitesse moyenne par rue.



def convert(speed):
	# Converti une vitesse (km/h) en (m/s)
	speed /= 3.6

	return speed

def getAddress(line):

	address = line[-1]
	address = address.split("Reverse ")
	address = address[1]
	address = address[1:-3]
	
	return address


def groupByAddress(matrix,dico):

	with open("grouped.txt",'w') as f3:

		for streetName in dico:
			val = 0.0
			count = 0.0

			for elem in matrix:
				if elem[0] == streetName:
					val += elem[1]
					count += 1.0

			tmp = val / count
			print(streetName,tmp)
			average = convert(tmp)
			print(streetName,average)
			print()

			string = "Street name: " + streetName + '\n' + "Average speed: " + str(average) + " m/s" + '\n' + "Number of vehicle(s): " + str(dico[streetName]) + '\n' + '\n'
			f3.write(string)
		

with open("1hour_data_port_area.csv",'r') as f1:

	matrix = [] # contient dans chaque sous liste une addr et la vitesse du camion à cet endroit
	dico = {} # contient les adresses avec le nb de fois qu'une voiture est passée par cette rue
	

	for line in f1:
		if line[0] != ',':
			line = line.split(',')
			address = getAddress(line)
			avg_vel = float(line[5])

			if address not in dico:
				dico[address] = 1
			
			else:
				dico[address] += 1

			tmp_list = []
			tmp_list.append(address)
			tmp_list.append(avg_vel)

			matrix.append(tmp_list)


	groupByAddress(matrix,dico)


