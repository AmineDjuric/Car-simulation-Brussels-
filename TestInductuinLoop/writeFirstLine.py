

# Ce code va uniquement ouvrir tous les fichiers de résultats ( un fichier de résultat par itération )
# et va écrire en premiere ligne de ce fichier : ,Result,DetectorName
# faire ceci est obligatoire et ne peut être fait dans le fichier parsexML.py

import sys


iterationNb = sys.argv[1]
with open("Results/"+iterationNb+".csv",'w',encoding='utf-8') as f:
	# print("Dans writeFirstLine.py:","Results/"+iterationNb+".csv")
	f.write(",Result;DetectorName;" + '\n')
