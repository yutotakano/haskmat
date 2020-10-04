data Matrix a = Matrix [[a]] | Scalar a deriving Show

mCheck :: Num a => Matrix a -> Bool
mCheck (Matrix a) = and [length row == length top_row | row <- rows]
  where
    top_row = head a
    rows = tail a

mSize :: Num a => Matrix a -> (Int, Int)
mSize (Scalar a) = error "Invalid call to mSize on a Scalar."
mSize (Matrix a) = if mCheck (Matrix a) then calculation else error "Invalid Shape."
  where
    calculation = (1 + (length rows), length top_row)
    top_row = head a
    rows = tail a

mZeros :: (Num a) => (Int, Int) -> Matrix a
mZeros (m, n) = Matrix $ replicate m (replicate n 0)

mOnes :: (Num a) => (Int, Int) -> Matrix a
mOnes (m, n) = Matrix $ replicate m (replicate n 1)

mSet :: (Num a) => Matrix a -> (Int, Int) -> a -> Matrix a
mSet (Scalar a) (_,_) _ = error "Invalid call to mSet on a Scalar."
mSet (Matrix a) (n_i, n_j) val = Matrix $ [
    [
      (if i == n_i && j == n_j then val else item) | (j, item) <- zip [1..] row
    ] | (i, row) <- zip [1..] a
  ]    

mGet :: (Num a) => Matrix a -> (Int, Int) -> a
mGet (Scalar a) (_,_) = error "Invalid call to mGet on a Scalar."
mGet (Matrix a) (i, j) = desired_item
  where
    get_item n x = head (take 1 $ drop (n - 1) x)
    desired_row = get_item i a
    desired_item = get_item j desired_row

mAdd :: (Num a) => Matrix a -> Matrix a -> Matrix a
mAdd (Scalar a) (Scalar b) = Scalar (a + b)
mAdd (Scalar a) (Matrix b) = error "Invalid call to mAdd on a Scalar and Matrix."
mAdd (Matrix a) (Scalar b) = error "Invalid call to mAdd on a Scalar and Matrix."
mAdd (Matrix a) (Matrix b) = if mSize (Matrix a) == mSize (Matrix b) then calculation else error "Different Shapes cannot be added."
  where
    calculation = Matrix $ [
        [
          a_item + (head $ drop j ( head $ drop i b)) | (j, a_item) <- zip [0..] row
        ] | (i, row) <- zip [0..] a
      ]
    -- this honestly took a while to come up with my sleepy brain
    -- loop through each row (with index using zip), then loop through each item (with another index), drop items from b and add them

mSub :: (Num a) => Matrix a -> Matrix a -> Matrix a
mSub (Scalar a) (Scalar b) = Scalar (a - b)
mSub (Matrix a) (Scalar b) = error "Invalid call to mSub on a Scalar and Matrix."
mSub (Scalar a) (Matrix b) = error "Invalid call to mSub on a Scalar and Matrix."
mSub (Matrix a) (Matrix b) = if mSize (Matrix a) == mSize (Matrix b) then calculation else error "Different Shapes cannot be subtracted."
  where
    calculation = Matrix $ [
        [
          a_item - (head $ drop j ( head $ drop i b)) | (j, a_item) <- zip [0..] row
        ] | (i, row) <- zip [0..] a
      ]

mTranspose :: (Num a) => Matrix a -> Matrix a
mTranspose (Scalar a) = error "Invalid call to mTranspose on a Scalar."
mTranspose (Matrix a) = if mCheck (Matrix a) then calculation else error "Invalid Shape."
  where
    calculation = foldr mAdd z (
        concat [
          [
            mSet z (j, i) a_item | (j, a_item) <- zip [1..] row
          ] | (i, row) <- zip [1..] a
        ]
      )
    z = mZeros (snd s, fst s)
    s = (mSize $ Matrix a)

mMul :: (Num a) => Matrix a -> Matrix a -> Matrix a
mMul (Scalar a) (Scalar b) = Scalar (a*b)
mMul (Matrix a) (Scalar b) = Matrix $ [[item*b | item <- row] | row <- a]
mMul (Scalar a) (Matrix b) = Matrix $ [[item*a | item <- row] | row <- b]
mMul (Matrix a) (Matrix b) = if snd (mSize $ Matrix a) == fst (mSize $ Matrix b) then calculation else error "Shape does not permit multiplication."
  where
    calculation = foldr mAdd z (
      concat [
          concat [
            [
              mSet z (k, i) ((mGet (Matrix a) (k, j)) * item) | k <- [1..(fst $ mSize $ Matrix a)]
            ] | (j, item) <- zip [1..] column
          ] | (i, column) <- zip [1..] t
        ]
      )
    z = mZeros (fst (mSize $ Matrix a), snd (mSize $ Matrix b))
    (Matrix t) = mTranspose (Matrix b)