#!/usr/bin/env scala

/*
* This script will generate a grid file that can be used as input to 'unionFind' script.
* The output is a file discribing the relationship between nodes. This relationship is 
* defined randomly.
* An example of the output is:
*
* 7
* 1 - 5
* 3
* 7 - 4
* 2 - 4
* 6
*
* That output reprents the grid with 7 nodes, where node 1 is liked with node 5,
* node 7 is linked with node 4, node 2 is linked with node 4 and nodes 3 and 6 
* are not linked to any other node.
*
* Call this script as ./generateGrid <numberOfNodes>
* Example:
* ./generateGrid 100000
*/

// numberOfNodes represents the number of nodes in the system
val numberOfNodes = args(0).toInt

// Everytime this script is run, a new output file is generated
val outputFile = s"grid_${numberOfNodes}_${System.currentTimeMillis}"

// Relationship is a map from Int to Int that describes node relationships
// The relationships are generated randomly.
val relationships:collection.mutable.Map[Int, collection.mutable.MutableList[Int]] = collection.mutable.Map()

// Random genetator
val randGen = scala.util.Random

for (i <- 0 until numberOfNodes) {
    val from = randGen.nextInt(numberOfNodes) 
    val to = randGen.nextInt(numberOfNodes)
    if (from != to) {
        if (!relationships.contains(from)) { 
            relationships(from) = collection.mutable.MutableList[Int]()
        }
        
        relationships(from) += to
    }
}

// Now generate the output
import java.io._
val writer = new PrintWriter(new File(outputFile))

try {
    writer.println(numberOfNodes)
    for (i <- 0 until numberOfNodes) {
        relationships.get(i) match {
            case Some(ns) => ns.foreach {n => writer.println(s"$i - $n")}
            // Only write single node if it's not related to any other
            case None => writer.println(i)        
        }
    }
} finally {
    writer.close()
}


