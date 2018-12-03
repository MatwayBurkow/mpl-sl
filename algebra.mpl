"algebra" module
"control" useModule

PI: [3.14159265358979323r32] func;
Vector: [array] func;
Matrix: [rowCount:; Vector rowCount Vector] func;


{arg: Real32;} Real32 {} "acosf" importFunction
{arg: Real64;} Real64 {} "acos" importFunction
acos: [Real32 same] [acosf] pfunc;

{arg: Real32;} Real32 {} "tanf" importFunction
{arg: Real64;} Real64 {} "tan" importFunction
tan: [Real32 same] [tanf] pfunc;

vector?: [v:; FALSE] func;
vector?: [v:; v 0 fieldName textSize 0nx =] [v:; TRUE] pfunc;

matrix?: [m:; FALSE] func;
matrix?: [
  m:;
  colCount: 0 @m @ fieldCount;
  @m vector?
  @m fieldCount [
    v: i @m @;
    @v vector?
    @v fieldCount colCount = and and
  ] times
] [m:; TRUE] pfunc;

getColCount: [matrix?] [m:; 0 m @ fieldCount] pfunc;

getRowCount: [matrix?] [fieldCount] pfunc;

-: [
  v1:v2:;;
  v1 vector?
  v2 vector? and
  v1 fieldCount v2 fieldCount = and
] [
  v1:v2:;;
  (v1 fieldCount [i v1 @ i v2 @ -] times)
] pfunc;

+: [
  v1:v2:;;
  v1 vector?
  v2 vector? and
  v1 fieldCount v2 fieldCount = and
] [
  v1:v2:;;
  (v1 fieldCount [i v1 @ i v2 @ +] times)
] pfunc;

=: [
  v1:v2:;;
  v1 vector?
  v2 vector? and
  v1 fieldCount v2 fieldCount = and
] [
  v1:v2:;;
  result: TRUE;
  v1 fieldCount [
    i v1 @ i v2 @ = result and !result
  ] times

  result
] pfunc;

=: [
  v1:m2:;;
  v1 vector?
  v1 matrix? not and
  m2 matrix? and
  v1 fieldCount m2 getColCount = and
  m2 getRowCount 1 = and
] [
  v1:m2:;;
  result: TRUE;
  v1 fieldCount [
    i v1 @ i 0 m2 @ @ = result and !result
  ] times
] pfunc;

/: [
  vector:value:;;
  vector vector?
] [
  vector:value:;;
  (vector fieldCount [i vector @ value /] times)
] pfunc;

*: [
  vector:value:;;
  vector vector?
] [
  vector:value:;;
  (vector fieldCount [i vector @ value *] times)
] pfunc;

*: [
  value:vector:;;
  vector vector?
] [
  value:vector:;;
  (vector fieldCount [i vector @ value *] times)
] pfunc;

*: [
  m1:m2:;;
  m1 matrix? m2 matrix? and
  m1 getColCount m2 getRowCount = and
] [
  m1:m2:;;
  result: 0 0 m1 @ @ m2 getColCount m1 getRowCount Matrix;
  m1 getRowCount [ row0: i;
    m2 getColCount [ col1: i;
      0 row0 m1 @ @
      col1 0 m2 @ @ *
      col1 row0 @result @ @ set
      m1 getColCount 1 - [ col0: i 1 +;
        col0 row0 m1 @ @
        col1 col0 m2 @ @ *
        col1 row0 result @ @ +
        col1 row0 @result @ @ set
      ] times
    ] times
  ] times

  result
] pfunc;

*: [
  v1:m2:;;
  v1 vector?
  v1 matrix? not and
  m2 matrix? and
  v1 fieldCount m2 getRowCount = and
] [
  v:m:;;
  result: v copy;
  v fieldCount [ col1: i;
    0 v @
    col1 0 m @ @ *
    col1 @result @ set
    m getColCount 1 - [ col0: i 1 +;
      col0 v @
      col1 col0 m @ @ *
      col1 result @ +
      col1 @result @ set
    ] times
  ] times

  result
] pfunc;

|: [
  m1:m2:;;
  m1 matrix?
  m2 matrix? and
  m1 getColCount m2 getColCount = and
] [
  m1:m2:;;
  (
    m1 getRowCount [i m1 @ copy] times
    m2 getRowCount [i m2 @ copy] times
  )
] pfunc;

|: [
  m:v:;;
  m matrix?
  v vector? and
  m getColCount v fieldCount = and
] [
  m:v:;;
  (
    m getRowCount [i m @ copy] times
    v copy
  )
] pfunc;

&: [
  v1:v2:;;
  v1 vector?
  v2 vector? and
] [
  v1:v2:;;
  (v1 fieldCount [i v1 @ copy] times v2 fieldCount [i v2 @ copy] times)
] pfunc;

&: [
  m1:m2:;;
  m1 matrix?
  m2 matrix? and
  m1 getRowCount m2 getRowCount = and
] [
  m1:m2:;;
  (
    m1 getRowCount [ row: i;
      (
        m1 getColCount [i row m1 @ @ copy] times
        m2 getColCount [i row m2 @ @ copy] times
      )
    ] times
  )
] pfunc;

toColumn: [vector?] [v:;(v fieldCount [(i v @ copy)] times)] pfunc;

multiply: [v1:v2:;; v1 vector? v2 vector? and] [v1:v2:;; (v1 fieldCount [i v1 @ i v2 @ *] times)] pfunc;

divide: [v1:v2:;; v1 vector? v2 vector? and] [v1:v2:;; (v1 fieldCount [i v1 @ i v2 @ /] times)] pfunc;

dot: [
  v0:v1:;;
  v0 vector?
  v1 vector? and
  v0 fieldCount v1 fieldCount = and
] [
  v0:v1:;;
  sum: 0 v0 @ 0 v1 @ *;
  v0 fieldCount 1 - [i1: i 1 +; i1 v0 @ i1 v1 @ * sum + !sum] times
  sum
] pfunc;

cross: [
  v0:v1:;;
  v0 fieldCount 3 =
  v1 fieldCount 3 = and
] [
  v0:v1:;;
  (
    1 v0 @ 2 v1 @ * 2 v0 @ 1 v1 @ * -
    2 v0 @ 0 v1 @ * 0 v0 @ 2 v1 @ * -
    0 v0 @ 1 v1 @ * 1 v0 @ 0 v1 @ * -
  )
] pfunc;

length: [vector?] [
  v:; v v dot sqrt
] pfunc;

unit: [vector?] [
  v:;
  one: 1 0 v @ cast;
  v one v length / *
] pfunc;

neg: [vector?] [v:; (v fieldCount [i v @ neg] times)] pfunc;

cast: [v0:v1:;; v0 vector? v1 vector? and] [v0:v1:;; (v1 fieldCount [i v0 @ i v1 @ cast] times)] pfunc;

trans: [
  v:;
  v vector?
  v matrix? not and
] [
  v:;
  (v fieldCount [(i v @)] times)
] pfunc;

trans: [matrix?] [
  m:;
  result: 0 0 m @ @ m getRowCount m getColCount Matrix;
  m getRowCount [ row: i;
    m getColCount [ col: i;
      col row m @ @
      row col @result @ @ set
    ] times
  ] times

  result
] pfunc;

lerp: [
  f: copy;
  v1:;
  v0:;
  v0 1 f cast f - *
  v1 f *
  +
] func;

det: [
  m:;
  m matrix?
  m getColCount 1 = and
  m getRowCount 1 = and
] [m:; 0 0 m @ copy] pfunc;

det: [
  m:;
  m matrix?
  m getColCount 2 = and
  m getRowCount 2 = and
] [
  m:;
  0 0 m @ @
  1 1 m @ @ *
  1 0 m @ @
  0 1 m @ @ * -
] pfunc;

det: [
  m:;
  m matrix?
  m getColCount 3 = and
  m getRowCount 3 = and
] [
  m:;
  1 0 m @ @
  2 1 m @ @ *
  2 0 m @ @
  1 1 m @ @ * -
  0 2 m @ @ *

  2 0 m @ @
  0 1 m @ @ *
  0 0 m @ @
  2 1 m @ @ * -
  1 2 m @ @ * +

  0 0 m @ @
  1 1 m @ @ *
  1 0 m @ @
  0 1 m @ @ * -
  2 2 m @ @ * +
] pfunc;

det: [
  m:;
  m matrix?
  m getColCount 4 = and
  m getRowCount 4 = and
] [
  m:;
  m00_11: 0 0 m @ @ 1 1 m @ @ *;
  m00_12: 0 0 m @ @ 2 1 m @ @ *;
  m00_13: 0 0 m @ @ 3 1 m @ @ *;
  m01_10: 1 0 m @ @ 0 1 m @ @ *;
  m01_12: 1 0 m @ @ 2 1 m @ @ *;
  m01_13: 1 0 m @ @ 3 1 m @ @ *;
  m02_10: 2 0 m @ @ 0 1 m @ @ *;
  m02_11: 2 0 m @ @ 1 1 m @ @ *;
  m02_13: 2 0 m @ @ 3 1 m @ @ *;
  m03_10: 3 0 m @ @ 0 1 m @ @ *;
  m03_11: 3 0 m @ @ 1 1 m @ @ *;
  m03_12: 3 0 m @ @ 2 1 m @ @ *;

  m03_12 m02_13 - 1 2 m @ @ * m01_13 m03_11 - 2 2 m @ @ * + m02_11 m01_12 - 3 2 m @ @ * + 0 3 m @ @ *
  m03_10 m00_13 - 2 2 m @ @ * m00_12 m02_10 - 3 2 m @ @ * + m02_13 m03_12 - 0 2 m @ @ * + 1 3 m @ @ * +
  m01_10 m00_11 - 3 2 m @ @ * m03_11 m01_13 - 0 2 m @ @ * + m00_13 m03_10 - 1 2 m @ @ * + 2 3 m @ @ * +
  m01_12 m02_11 - 0 2 m @ @ * m02_10 m00_12 - 1 2 m @ @ * + m00_11 m01_10 - 2 2 m @ @ * + 3 3 m @ @ * +
] pfunc;

adj: [
  m:;
  m matrix?
  m getColCount 1 = and
  m getRowCount 1 = and
] [
  ((0 0 m @ @ 0 0 m @ @ /))
] pfunc;

adj: [
  m:;
  m matrix?
  m getColCount 2 = and
  m getRowCount 2 = and
] [
  m:;
  (
    (1 1 m @ @     1 0 m @ @ neg)
    (0 1 m @ @ neg 0 0 m @ @)
  )
] pfunc;

adj: [
  m:;
  m matrix?
  m getColCount 3 = and
  m getRowCount 3 = and
] [
  m:;
  (
    (
      1 1 m @ @ 2 2 m @ @ * 2 1 m @ @ 1 2 m @ @ * -
      1 2 m @ @ 2 0 m @ @ * 2 2 m @ @ 1 0 m @ @ * -
      1 0 m @ @ 2 1 m @ @ * 2 0 m @ @ 1 1 m @ @ * -
    )
    (
      2 1 m @ @ 0 2 m @ @ * 0 1 m @ @ 2 2 m @ @ * -
      2 2 m @ @ 0 0 m @ @ * 0 2 m @ @ 2 0 m @ @ * -
      2 0 m @ @ 0 1 m @ @ * 0 0 m @ @ 2 1 m @ @ * -
    )
    (
      0 1 m @ @ 1 2 m @ @ * 1 1 m @ @ 0 2 m @ @ * -
      0 2 m @ @ 1 0 m @ @ * 1 2 m @ @ 0 0 m @ @ * -
      0 0 m @ @ 1 1 m @ @ * 1 0 m @ @ 0 1 m @ @ * -
    )
  )
] pfunc;

adj: [
  m:;
  m matrix?
  m getColCount 4 = and
  m getRowCount 4 = and
] [
  m:;
  m00_11: 0 0 m @ @ 1 1 m @ @ *;
  m00_12: 0 0 m @ @ 2 1 m @ @ *;
  m00_13: 0 0 m @ @ 3 1 m @ @ *;
  m00_21: 0 0 m @ @ 1 2 m @ @ *;
  m00_22: 0 0 m @ @ 2 2 m @ @ *;
  m00_23: 0 0 m @ @ 3 2 m @ @ *;
  m01_10: 1 0 m @ @ 0 1 m @ @ *;
  m01_12: 1 0 m @ @ 2 1 m @ @ *;
  m01_13: 1 0 m @ @ 3 1 m @ @ *;
  m01_20: 1 0 m @ @ 0 2 m @ @ *;
  m01_22: 1 0 m @ @ 2 2 m @ @ *;
  m01_23: 1 0 m @ @ 3 2 m @ @ *;
  m02_10: 2 0 m @ @ 0 1 m @ @ *;
  m02_11: 2 0 m @ @ 1 1 m @ @ *;
  m02_13: 2 0 m @ @ 3 1 m @ @ *;
  m02_20: 2 0 m @ @ 0 2 m @ @ *;
  m02_21: 2 0 m @ @ 1 2 m @ @ *;
  m02_23: 2 0 m @ @ 3 2 m @ @ *;
  m03_10: 3 0 m @ @ 0 1 m @ @ *;
  m03_11: 3 0 m @ @ 1 1 m @ @ *;
  m03_12: 3 0 m @ @ 2 1 m @ @ *;
  m03_20: 3 0 m @ @ 0 2 m @ @ *;
  m03_21: 3 0 m @ @ 1 2 m @ @ *;
  m03_22: 3 0 m @ @ 2 2 m @ @ *;
  m10_21: 0 1 m @ @ 1 2 m @ @ *;
  m10_22: 0 1 m @ @ 2 2 m @ @ *;
  m10_23: 0 1 m @ @ 3 2 m @ @ *;
  m11_20: 1 1 m @ @ 0 2 m @ @ *;
  m11_22: 1 1 m @ @ 2 2 m @ @ *;
  m11_23: 1 1 m @ @ 3 2 m @ @ *;
  m12_20: 2 1 m @ @ 0 2 m @ @ *;
  m12_21: 2 1 m @ @ 1 2 m @ @ *;
  m12_23: 2 1 m @ @ 3 2 m @ @ *;
  m13_20: 3 1 m @ @ 0 2 m @ @ *;
  m13_21: 3 1 m @ @ 1 2 m @ @ *;
  m13_22: 3 1 m @ @ 2 2 m @ @ *;
  (
    (
      m12_23 m13_22 - 1 3 m @ @ * m13_21 m11_23 - 2 3 m @ @ * m11_22 m12_21 - 3 3 m @ @ * + +
      m03_22 m02_23 - 1 3 m @ @ * m01_23 m03_21 - 2 3 m @ @ * m02_21 m01_22 - 3 3 m @ @ * + +
      m02_13 m03_12 - 1 3 m @ @ * m03_11 m01_13 - 2 3 m @ @ * m01_12 m02_11 - 3 3 m @ @ * + +
      m03_12 m02_13 - 1 2 m @ @ * m01_13 m03_11 - 2 2 m @ @ * m02_11 m01_12 - 3 2 m @ @ * + +
    )
    (
      m13_22 m12_23 - 0 3 m @ @ * m10_23 m13_20 - 2 3 m @ @ * m12_20 m10_22 - 3 3 m @ @ * + +
      m02_23 m03_22 - 0 3 m @ @ * m03_20 m00_23 - 2 3 m @ @ * m00_22 m02_20 - 3 3 m @ @ * + +
      m03_12 m02_13 - 0 3 m @ @ * m00_13 m03_10 - 2 3 m @ @ * m02_10 m00_12 - 3 3 m @ @ * + +
      m02_13 m03_12 - 0 2 m @ @ * m03_10 m00_13 - 2 2 m @ @ * m00_12 m02_10 - 3 2 m @ @ * + +
    )
    (
      m11_23 m13_21 - 0 3 m @ @ * m13_20 m10_23 - 1 3 m @ @ * m10_21 m11_20 - 3 3 m @ @ * + +
      m03_21 m01_23 - 0 3 m @ @ * m00_23 m03_20 - 1 3 m @ @ * m01_20 m00_21 - 3 3 m @ @ * + +
      m01_13 m03_11 - 0 3 m @ @ * m03_10 m00_13 - 1 3 m @ @ * m00_11 m01_10 - 3 3 m @ @ * + +
      m03_11 m01_13 - 0 2 m @ @ * m00_13 m03_10 - 1 2 m @ @ * m01_10 m00_11 - 3 2 m @ @ * + +
    )
    (
      m12_21 m11_22 - 0 3 m @ @ * m10_22 m12_20 - 1 3 m @ @ * m11_20 m10_21 - 2 3 m @ @ * + +
      m01_22 m02_21 - 0 3 m @ @ * m02_20 m00_22 - 1 3 m @ @ * m00_21 m01_20 - 2 3 m @ @ * + +
      m02_11 m01_12 - 0 3 m @ @ * m00_12 m02_10 - 1 3 m @ @ * m01_10 m00_11 - 2 3 m @ @ * + +
      m01_12 m02_11 - 0 2 m @ @ * m02_10 m00_12 - 1 2 m @ @ * m00_11 m01_10 - 2 2 m @ @ * + +
    )
  )
] pfunc;

inv: [
  m:;
  m matrix?
  m getColCount m getRowCount = and
] [
  m:;
  m adj m det /
] pfunc;