#!/usr/bin/env scala

/*
* This script implements the union-find algorithm
* and use a grid created with 'generateGrid.sh' to
* answer questions about when a node "has a connection" to another.
*
* A node has a connection to another node if they belong to 
* the same node set.
*
* This algorithm tries to answer question like:
*
* Given a grid of hosts, which can be connected to other hosts
* or not, how can we say if two nodes can communicate with each other?
*
* https://www.cs.princeton.edu/~rs/AlgsDS07/01UnionFind.pdf
* 
* Call this script as: ./unionFind.sh <grid_file>
* 
* You can generate <grid_file> with "generateGrid.sh"
*/

class UnionFind(numberOfNodes:Int) {
    val nodeTrees = new Array[Int](numberOfNodes)
    val ranks = new Array[Int](numberOfNodes)

    // Initialize nodeTrees and ranks arrays
    // Each node points to itself
    // Each node has a default rank of 1
    for (i <- 0 until numberOfNodes) {
        nodeTrees(i) = i
        ranks(i) = 1
    }

    def isConnected(node1:Int, node2:Int) = root(node1) == root(node2)
  
    def connect(node1:Int, node2:Int) {
        val root1 = root(node1)
        val root2 = root(node2)

        if (ranks(root1) < ranks(root2)) {
            nodeTrees(root1) = root2
            ranks(root1) += ranks(root2)            
        } else {
            nodeTrees(root2) = root1
            ranks(root2) += ranks(root1)    
        }
    }

    private def root(node: Int):Int = {
        if (node == nodeTrees(node)) return node

        nodeTrees(node) = nodeTrees(nodeTrees(node))
        root(nodeTrees(node))
    }

    // For debug only!
    override def toString = {
        val mapOfNodes = collection.mutable.Map[Int, collection.mutable.MutableList[Int]]()
        
        for (i <- 0 until numberOfNodes) {
            val node = root(i)
            if (!mapOfNodes.contains(node)) mapOfNodes(node) = collection.mutable.MutableList[Int]()
            
            mapOfNodes(node) += i
        }

        val buffer = new StringBuffer()
        (0 until numberOfNodes).filter { mapOfNodes.contains(_) }.foreach { node => 
            buffer.append(s"$node -> ").append(mapOfNodes(node).sorted.mkString(", ")).append("\n")        
        }

        buffer.toString
    }
}

// Main loop
val gridInput = args(0)

// Parse the grid file
// First line contains the number of nodes in the grid
// Subsequent lines contain the relationship between nodes
import scala.io.Source
val fileLines = Source.fromFile(gridInput).getLines

// Extract number of nodes
val numberOfNodes = fileLines.next.toInt

// Create and initalize an instance of UnionFind
val unionFind = new UnionFind(numberOfNodes)

// Proccess the rest of the input
fileLines.map { _.split(" - ") }
         .filter { _.length > 1 }
         .foreach { pair => unionFind.connect(pair(0).toInt, pair(1).toInt) }

println("##### Grid loaded #####")
println()

// Just for debugging
//println(unionFind.toString)

import scala.io.StdIn._
// Interactive session
while(true) {
    print(s"First node to check - (from 0 to ${numberOfNodes-1}): ")
    val node1 = readLine().toInt

    print(s"Second node to check - (from 0 to ${numberOfNodes-1}): ")
    val node2 = readLine().toInt

    println(s"$node1 is connected to $node2 ? ${unionFind.isConnected(node1, node2)}")
    println
    println("Control-C to finish or Enter to continue")
    readLine()
}
