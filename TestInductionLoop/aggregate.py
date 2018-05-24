
# Aggregation of the number of trucks and their average speed by street.


def convert(speed):
	# Convert speed in km/h to m/s
	speed /= 3.6
	return speed 

def getAddress(line):

	address = line[-1]
	address = address.split("Reverse ")
	address = address[1]
	address = address[1:-3]
	address = address.split(" - ")
	address = address[1]  
	
	address = address.replace(" ", "")
	
	return address


def groupByAddress(matrix,dico):

	with open("formatted.txt",'w', encoding='utf-8') as f4:

		f4.write(",StreetName;Speed;NbVehicles;"+'\n')

		for streetName in dico:
			val = 0.0
			count = 0.0

			for elem in matrix:
				if elem[0] == streetName:
					val += elem[1]
					count += 1.0

			tmp = val / count
			average = convert(tmp)

			f4.write(streetName + "Detector" + ';' + str(average) + ';' + str(dico[streetName]) + ';' + '\n')

with open("1hour_data_port_area.csv",'r',encoding='utf-8') as f1:

	matrix = [] # Contains in every sub list an addresse and the speed of the truck in this place
	dico = {} 	# Contains the addresses with the number of times when a car passed by this street
	
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



