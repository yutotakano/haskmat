type Matrix = [[Int]]

mCheck :: Matrix -> Bool
mCheck (top_row:rows) = and [length row == length top_row  | row <- rows]

mSize :: Matrix -> (Int, Int)
mSize (a:rows) = if mCheck (a:rows) then calculation else error "Invalid Shape."
  where
    calculation = (1 + (length rows), length a)

mZeros :: (Int, Int) -> Matrix
mZeros (m, n) = replicate m (replicate n 0)

mOnes :: (Int, Int) -> Matrix
mOnes (m, n) = replicate m (replicate n 1)

mSet :: Matrix -> (Int, Int) -> Int -> Matrix
mSet a (n_i, n_j) val = [[(if i == n_i && j == n_j then val else item) | (j, item) <- zip [1..] row] | (i, row) <- zip [1..] a]

mGet :: Matrix -> (Int, Int) -> Int
mGet a (i, j) = head (take 1 $ drop (j - 1) (head (take 1 $ drop (i - 1) a)))

mAdd :: Matrix -> Matrix -> Matrix
mAdd a b = if mSize a == mSize b then calculation else error "Different Shapes cannot be added."
  where
    calculation = [[a_item + (head $ drop j ( head $ drop i b)) | (j, a_item) <- zip [0..] row] | (i, row) <- zip [0..] a]
    -- this honestly took a while to come up with my sleepy brain
    -- loop through each row (with index using zip), then loop through each item (with another index), drop items from b and add them

mSub :: Matrix -> Matrix -> Matrix
mSub a b = if mSize a == mSize b then calculation else error "Different Shapes cannot be subtracted."
  where
    calculation = [[a_item - (head $ drop j ( head $ drop i b)) | (j, a_item) <- zip [0..] row] | (i, row) <- zip [0..] a]

mTranspose :: Matrix -> Matrix
mTranspose a = if mCheck a then calculation else error "Invalid Shape."
  where
    calculation = foldr mAdd z (concat [[mSet z (j, i) a_item | (j, a_item) <- zip [1..] row] | (i, row) <- zip [1..] a])
    z = mZeros (mSize a)

mMul :: Matrix -> Matrix -> Matrix
mMul a b = if snd (mSize a) == fst (mSize b) then calculation else error "Shape does not permit multiplication."
  where
    calculation = foldr mAdd z
      (concat
        [
          (concat 
            [
              [mSet z (k, i) ((mGet a (k, j)) * item)
              | k <- [1..(fst $ mSize a)]]
            | (j, item) <- zip [1..] column])
        | (i, column) <- zip [1..] (mTranspose b)])
    z = mZeros (fst (mSize a), snd (mSize b))