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
-- sizeTree function
sizeTree :: Tree -> Int
sizeTree Leaf = 0
sizeTree (Node _ l r) = 1 + sizeTree l + sizeTree r

-- height function
height :: Tree -> Int
height Leaf = -1
height (Node _ l r) = 1 + max (height l) (height r)

-- treeSum function
treeSum :: Tree -> Int
treeSum Leaf = 0
treeSum (Node v l r) = v + treeSum l + treeSum r

-- Overloading the equivalence (==) operator for Tree
instance Eq Tree where
  Leaf == Leaf = True
  (Node v1 l1 r1) == (Node v2 l2 r2) = v1 == v2 && l1 == l2 && r1 == r2
  _ == _ = False
  
-- Merge two binary trees without duplicates
mergeTrees :: Tree -> Tree -> Tree
mergeTrees Leaf t2 = t2
mergeTrees t1 Leaf = t1
mergeTrees t1@(Node v1 l1 r1) t2@(Node v2 l2 r2)
    | v1 > v2   = Node v2 l2 (mergeTrees t1 r2)
    | v1 < v2   = Node v1 l1 (mergeTrees r1 t2)
    | otherwise = Node v1 r1 l2
