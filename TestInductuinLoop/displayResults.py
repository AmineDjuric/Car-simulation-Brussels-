
import glob
import matplotlib.pyplot as plt
import os
import sys


def average():

	dictMeans = {}  # This dictionary contains in key the number of the iteration and in value the average of the results

	for filename in glob.glob('*.csv'):
		# Allows to parse all the files .csv in the current directory
		# on parcours chaque tous les détecteurs pour une itération et un n précis.
		# on calcule la moyenne et on la place dans un dico
		# dictMeans = {n_1__i_1 : 50.3, n_1__i_2 : 50.3,....}

		iterationsNumber = filename.split('.')[0]

		with open(filename,'r') as file:

			values = []
			for line in file:
				if line[0] != ',':
					line = line.split(';')
					values.append(float(line[0]))

			
			mean = sum(values) / float(len(values))
			dictMeans[iterationsNumber] = mean

	"""
	for elem in dictMeans:
		print(elem,':',dictMeans[elem])
	"""

	return dictMeans

def findMinValue(dictionnary,N,K):
	# This method will find the n value such as the average on multiple iteration is minimal.

	average = {}
	# en clé : le n
	# en valeur : la moyenne des itérations pour ce n

	for n in range(1,N+1):
		tmp = []
		for i in range(1,K+1):
			tmp.append(dictionnary["n" + "_" + str(n) + "__" + "i" + "_" +  str(i)])

		average[n] = sum(tmp) / float(len(tmp))

	print("average dico")
	for elem in average:
		print(elem,average[elem])

	print()
	minN = min(average, key=average.get)
	print("n t.q la moyenne sur toutes ses iterations est minimale:","n =",minN)
	print("la valeur minimale est:",average[minN])


def display():
	# displays the variation of gap between the number of cars and the squared deviations from the mean speed of all detectors

	dictMeans = average()
	print("Result1")
	for elem in dictMeans:
		print(elem,dictMeans[elem])


	os.chdir("../Results2/")
	dictMeans2 = average()
	print("Results2")
	for elem in dictMeans2:
		print(elem,dictMeans2[elem])

	iterationsNumbers1 = []
	means1 = []

	for elem in dictMeans:
		#print(elem,elem.split('_')[1])
		iterationsNumbers1.append(elem.split('_')[1])
		means1.append(dictMeans[elem])

	iterationsNumbers2 = []
	means2 = []
	
	for elem in dictMeans2:
		#print(elem,elem.split('_')[1])
		iterationsNumbers2.append(elem.split('_')[1])
		means2.append(dictMeans2[elem])


	nmax = int(sys.argv[1])
	k = int(sys.argv[2])

	findMinValue(dictMeans,nmax,k)

	f1 = plt.figure()
	f2 = plt.figure()

	ax1 = f1.add_subplot(111)
	ax1.scatter(iterationsNumbers1,means1,s=50)	
	ax1.set_xlabel("Number of cars generated")
	ax1.set_ylabel("Squared deviations from the average speed of all detectors")
	ax1.set_title("\nVariation of n cars\n and the squared deviations from the mean speed of all detectors\n")
	
	ax2 = f2.add_subplot(111)
	ax2.scatter(iterationsNumbers2,means2,s=50)

	ax2.set_xlabel("Number of cars generated")
	ax2.set_ylabel("Average speed of all detectors")
	
	plt.show()



display()

