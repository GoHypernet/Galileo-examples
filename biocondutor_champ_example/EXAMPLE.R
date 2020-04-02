library(ChAMP)
testDir=system.file("extdata",package="ChAMPdata")
myLoad <- champ.load(testDir,arraytype="450K")
jpeg("densityplot.jpeg")
densityPlot(myLoad$beta)

