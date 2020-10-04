<div align="center">

  # haskmat

  **Matrix Operations in Haskell**
</div>

## Usage

Creation of a Matrix:

```hs
ghci> george = Matrix [[1,2],[3,4]]
ghci> fred = Matrix [[1,2,3],[4,5,6]]
ghci> ron = Scalar 5
```

Basic get/set operations:

```hs
ghci> mSize george
(2,2)

ghci> mGet george (1,2)
2

ghci> mSet george (1,2) 100
Matrix [[1,100],[3,4]]
```

Generating certain matrices:

```hs
ghci> mZeros (4,2)
Matrix [[0,0],[0,0],[0,0],[0,0]]

ghci> mOnes (1,3)
Matrix [[1,1,1]]
```

Matrix operations:

```hs
ghci> mAdd george george
Matrix [[2,4],[6,8]]

ghci> mSub fred fred
Matrix [[0,0,0],[0,0,0]]

ghci> mTranspose fred
Matrix [[1,4],[2,5],[3,6]]

ghci> mMul george fred
Matrix [[9,12,15],[19,26,33]]

ghci> mMul george ron
Matrix [[5,10],[15,20]]
```

More complicated examples:

```hs
ghci> (⊗) = mMul
ghci> (⌛) = mAdd
ghci> ((george ⊗ fred) ⊗ (Scalar 150)) ⌛ (mOnes (fst $ mSize george, snd $ mSize fred))
Matrix [[1351,1801,2251],[2851,3901,4951]]
```
