-- HW2.hs
-- Author: Nils Streedain (streedan@oregonstate.edu)
-- Date: 04/23/2023

module HW2 where
import HW2types
import Data.List (nub)

-- Problem 1: Trees
-- sizeTree function
sizeTree :: Tree -> Int
sizeTree Leaf = 0
sizeTree (Node _ l r) = 1 + sizeTree l + sizeTree r
