{-
HW2.hs
Author: Nils Streedain (streedan@oregonstate.edu)
Date: 04/23/2023

This file contains Haskell code that defines functions for trees and graphs.

Trees:
- `sizeTree`: calculates the number of nodes in a tree
- `height`: calculates the height of a tree
- `treeSum`: calculates the sum of values of all nodes in a tree
- `mergeTrees`: merges two binary trees without duplicates
- `isBST`: checks if a given tree is a binary search tree
- `convertBST`: converts a given binary tree to a binary search tree

Graphs:
- `numVE`: calculates the number of vertices and edges in a graph
- `removeLoops`: removes loops from a graph
- `removeVertex`: removes a given vertex from a graph
-}

module HW2 where
import HW2types
import Data.List (nub)

-- Problem 1: Trees
-- This section defines functions that operate on binary trees.
-- sizeTree function
-- Given a binary tree, returns the number of nodes in the tree by recursively
-- traversing the tree and summing the nodes.
sizeTree :: Tree -> Int
sizeTree Leaf = 0
sizeTree (Node _ l r) = 1 + sizeTree l + sizeTree r

-- height function
-- Given a binary tree, returns the height of the tree by recursively traversing
-- the tree and finding the maximum depth.
height :: Tree -> Int
height Leaf = -1
height (Node _ l r) = 1 + max (height l) (height r)

-- treeSum function
-- Given a binary tree, returns the sum of the values of all nodes in the tree
-- by recursively traversing the tree and summing node values.
treeSum :: Tree -> Int
treeSum Leaf = 0
treeSum (Node v l r) = v + treeSum l + treeSum r

-- Overloading the equivalence (==) operator for Tree
instance Eq Tree where
  Leaf == Leaf = True
  (Node v1 l1 r1) == (Node v2 l2 r2) = v1 == v2 && l1 == l2 && r1 == r2
  _ == _ = False

-- mergeTree function
-- Merges two binary trees without duplicates by recursively comparing node
-- values and adding nodes to the resulting tree
mergeTrees :: Tree -> Tree -> Tree
mergeTrees Leaf t2 = t2
mergeTrees t1 Leaf = t1
mergeTrees t1@(Node v1 l1 r1) t2@(Node v2 l2 r2)
    | v1 > v2   = Node v2 l2 (mergeTrees t1 r2)
    | v1 < v2   = Node v1 l1 (mergeTrees r1 t2)
    | otherwise = Node v1 r1 l2

-- isBST function
-- Checks if a given tree is a binary search tree by recursively traversing the
-- tree and comparing node values to ensure they satisfy BST properties.
isBST :: Tree -> Bool
isBST t = isBST' t (minBound :: Int) (maxBound :: Int)
  where
    isBST' :: Tree -> Int -> Int -> Bool
    isBST' Leaf _ _ = True
    isBST' (Node v left right) minVal maxVal =
      v > minVal && v < maxVal &&
      isBST' left minVal v &&
      isBST' right v maxVal

-- convertBST function
-- Converts a given binary tree to a binary search tree by first flattening the
-- tree into a list and then constructing a new BST from the list.
convertBST :: Tree -> Tree
convertBST t = toBST (flatten t)
  where
    toBST [] = Leaf
    toBST (x:xs) = Node x (toBST (filter (<x) xs)) (toBST (filter (>x) xs))
    
    -- helper function to flatten a binary tree into a list
    flatten Leaf = []
    flatten (Node v l r) = flatten l ++ [v] ++ flatten r

-- Problem 2: Graphs

-- Calculates the number of vertices and edges in a graph by counting the
-- distinct vertices and the total number of edges in the graph.
numVE :: Graph -> (Int, Int)
numVE graph =
  (length (nub (concatMap (\(u, v) -> [u, v]) graph)), length graph)

-- removeLoops function
-- Removes loops from a graph by filtering out edges with identical endpoints.
removeLoops :: Graph -> Graph
removeLoops = filter (\(u, v) -> u /= v)

-- removeVertex function
-- Removes a given vertex from a graph by filtering out edges containing the
-- vertex.
removeVertex :: Vertex -> Graph -> Graph
removeVertex v = filter (\(u, v') -> u /= v && v' /= v)
