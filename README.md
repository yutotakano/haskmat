<div align="center">

  # haskmat

  **Matrix Operations in Haskell**
</div>

## Usage

Basic get/set operations:

```hs
ghci> mSize [[1,2,3],[4,5,6]]
(2,3)

ghci> mGet [[1,2],[3,4]] (1,2)
2

ghci> mSet [[1,2],[3,4]] (1,2) 100
[[1,100],[3,4]]
```

Generating certain matrices:

```hs
ghci> mZeros (4,2)
[[0,0],[0,0],[0,0],[0,0]]

ghci> mOnes (1,3)
[[1,1,1]]
```

Matrix operations:

```hs
ghci> mAdd [[1,2],[3,4]] [[5,6],[7,8]]
[[6,8],[10,12]]

ghci> mSub [[1,2],[3,4]] [[5,6],[7,8]]
[[-4,-4],[-4,-4]]

ghci> mTranspose [[1,2,3],[4,5,6]]
[[1,4],[2,5],[3,6]]

ghci> mMul [[1,2],[3,4],[5,6]] [[1,2,3],[4,5,6]]
[[9,12,15],[19,26,33],[29,40,51]]

ghci> mScale [[1,2,3]] 100
[[100,200,300]]
```
