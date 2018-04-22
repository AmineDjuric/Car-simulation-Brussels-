



import glob
import matplotlib.pyplot as plt

def average():

	dictMeans = {}  # This dictionary contains in key the number of the iteration and in value the average of the results

	for filename in glob.glob('*.csv'):
		# Allows to aprse all the files .csv in the current directory
		
		iterationNb = int(filename.split('.')[0])

		with open(filename,'r') as file:

			values = []
			for line in file:
				if line[0] != ',':
					line = line.split(';')
					values.append(float(line[0]))
			
			mean = sum(values) / float(len(values))

			dictMeans[iterationNb] = mean

	return dictMeans

def findMinValue(dictionnary):

	key = min(dictionnary,key=dictionnary.get)
	print("Min value",dictionnary[key],"iteration number:",key)

def display():

	iterationsNumbers = []
	means = []

	for elem in dictMeans:
		iterationsNumbers.append(elem)
		means.append(dictMeans[elem])

	findMinValue(dictMeans)

	plt.scatter(iterationsNumbers,means,s=50)	
	plt.xlabel("Number of cars generated")
	plt.ylabel("Average speed of all detectors")
	plt.title("\nVariation of gap between the number of cars\n and the average speed of all detectors\n")
	plt.show()


dictMeans = average()
display()



