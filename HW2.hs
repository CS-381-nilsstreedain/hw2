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

-- flatten function
-- Flattens a binary tree into a list of node values.
flatten :: Tree -> [Int]
flatten Leaf = [] -- base case: empty tree returns empty list
flatten (Node v l r) = flatten l ++ [v] ++ flatten r -- infix traversal

-- listSort function
-- Sorts a list using a custom implementation of insertion sort.
listSort :: (Ord a) => [a] -> [a]
listSort = foldr insert [] -- iteratively inserts each element into sorted list
  where
    insert x [] = [x] -- base case: insert x into an empty list
    insert x (y:ys)
      | x <= y    = x : y : ys -- if x is less or equal to y, insert x before y
      | otherwise = y : insert x ys -- otherwise, keep y and insert x into list

-- Overloading the equivalence (==) operator for Tree
-- Checks that both trees contain the same values
instance Eq Tree where
  t1 == t2 = (listSort . nub $ flatten t1) == (listSort . nub $ flatten t2)

-- mergeTree function
-- Merges two binary trees without duplicates by recursively comparing node
-- values and adding nodes to the resulting tree
mergeTrees :: Tree -> Tree -> Tree
mergeTrees Leaf t2 = t2 -- base case: return second tree if first is empty
mergeTrees t1 Leaf = t1 -- base case: return first tree if second is empty
mergeTrees t1@(Node v1 l1 r1) t2@(Node v2 l2 r2)
    | v1 > v2   = Node v2 (mergeTrees t1 l2) r2 -- Keep small node, merge left
    | v1 < v2   = Node v1 l1 (mergeTrees r1 t2) -- Keep small node, merge right
    | otherwise = Node v1 (mergeTrees l1 l2) (mergeTrees r1 r2) -- Merge when ==

-- isBST function
-- Checks if a given tree is a binary search tree by recursively traversing the
-- tree and comparing node values to ensure they satisfy BST properties.
isBST :: Tree -> Bool
isBST t = isBST' t (minBound :: Int) (maxBound :: Int)
  where
    -- isBST' function
    -- Recursively checks if a subtree is a BST by comparing node values and
    -- their position with respect to the given min and max values.
    isBST' :: Tree -> Int -> Int -> Bool -- If the subtree is empty, it's valid
    isBST' Leaf _ _ = True -- base case: empty tree is always a BST
    isBST' (Node v left right) minVal maxVal =
      v > minVal && v < maxVal && -- ensure current node value is within bounds
      isBST' left minVal v &&     -- check left subtree
      isBST' right v maxVal       -- check right subtree

-- convertBST function
-- Converts a given binary tree to a binary search tree by first flattening the
-- tree into a list and then constructing a new BST from the list.
convertBST :: Tree -> Tree
convertBST t = toBST (flatten t) -- call to toBST with flattened tree list
  where
    -- toBST function
    -- Builds a BST recursively by selecting values from the flattened tree list
    toBST [] = Leaf -- base case: empty list returns empty tree
    toBST (x:xs) = Node x (toBST (filter (<x) xs)) (toBST (filter (>x) xs))

-- Problem 2: Graphs
-- This section defines functions that operate on graphs.

-- Calculates the number of vertices and edges in a graph by counting the
-- distinct vertices and the total number of edges in the graph.
numVE :: Graph -> (Int, Int)
numVE graph = (length (nub (concatMap (\(u, v) -> [u, v]) graph)), length graph)

-- removeLoops function
-- Removes loops from a graph by filtering out edges with identical endpoints.
removeLoops :: Graph -> Graph
removeLoops = filter (\(u, v) -> u /= v)

-- removeVertex function
-- Removes a given vertex from a graph by filtering out edges containing the
-- vertex.
removeVertex :: Vertex -> Graph -> Graph
removeVertex v = filter (\(u, v') -> u /= v && v' /= v)
