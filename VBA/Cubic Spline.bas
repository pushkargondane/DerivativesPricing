Public Function cuspline(x As Double, xValues As Range, yValues As Range) As Variant
'Cubic Spline Function
'Author - Pushkar Gondane
'Date - 9th June 2014
Dim i, j As Integer
Dim k As Double
'Same number of data points check
If xValues.Rows.Count <> yValues.Rows.Count Then
    cuspline = "X & Y Values need to have same number of data points"
    Exit Function
End If
'Single column array check
'If (xValues.Column.Count <> 1 Or yValues.Column.Count <> 1) Then
'    pwlinear = "Range should have only one column"
'    Exit Function
'End If
i = Application.Match(x, xValues)
'Last item searched, no interpolation, extrapolation check added
If (i = xValues.Rows.Count) Then
    If (xValues(i, 1) < x) Then
        cuspline = "Function cannot extrapolate"
        Exit Function
    End If
    cuspline = yValues(i, 1)
    Exit Function
End If

'Round trip pricing / bypassing splines in case of exact points
If (x = xValues(i, 1)) Then
    cuspline = yValues(i, 1)
    Exit Function
End If

'Convert x Range input into array and trasform it by subtracting with x
Dim PointSelector() As Double
ReDim PointSelector(xValues.Rows.Count, 2)
j = 1
While j < xValues.Rows.Count + 1
    PointSelector(j, 1) = Abs(xValues(j, 1) - x)
    PointSelector(j, 2) = j
    j = j + 1
Wend

'Sort Range to pick closest points - Bubble sort used here. Poor speed
i = 1
j = 1

While i < xValues.Rows.Count + 1

    While j < xValues.Rows.Count + 1 - i

        If PointSelector(j, 1) > PointSelector(j + 1, 1) Then
            k = PointSelector(j, 1)
            PointSelector(j, 1) = PointSelector(j + 1, 1)
            PointSelector(j + 1, 1) = k
            k = PointSelector(j, 2)
            PointSelector(j, 2) = PointSelector(j + 1, 2)
            PointSelector(j + 1, 2) = k
        End If


        j = j + 1
    Wend
    j = 1
    i = i + 1
Wend

Dim xTerms(3, 3), yTerms(3, 0) As Double
Dim Coeff As Variant

' Initialize xTerms
xTerms(0, 0) = 1
xTerms(1, 0) = 1
xTerms(2, 0) = 1
xTerms(3, 0) = 1

xTerms(0, 1) = xValues(PointSelector(1, 2), 1)
xTerms(1, 1) = xValues(PointSelector(2, 2), 1)
xTerms(2, 1) = xValues(PointSelector(3, 2), 1)
xTerms(3, 1) = xValues(PointSelector(4, 2), 1)

xTerms(0, 2) = xValues(PointSelector(1, 2), 1) ^ 2
xTerms(1, 2) = xValues(PointSelector(2, 2), 1) ^ 2
xTerms(2, 2) = xValues(PointSelector(3, 2), 1) ^ 2
xTerms(3, 2) = xValues(PointSelector(4, 2), 1) ^ 2

xTerms(0, 3) = xValues(PointSelector(1, 2), 1) ^ 3
xTerms(1, 3) = xValues(PointSelector(2, 2), 1) ^ 3
xTerms(2, 3) = xValues(PointSelector(3, 2), 1) ^ 3
xTerms(3, 3) = xValues(PointSelector(4, 2), 1) ^ 3


'Initialize yTerms
yTerms(0, 0) = yValues(PointSelector(1, 2), 1)
yTerms(1, 0) = yValues(PointSelector(2, 2), 1)
yTerms(2, 0) = yValues(PointSelector(3, 2), 1)
yTerms(3, 0) = yValues(PointSelector(4, 2), 1)

'Coeffecients = inverse of xTerms x yTerms

Coeff = Application.MMult(Application.MInverse(xTerms), yTerms)

cuspline = Coeff(1, 1) + Coeff(2, 1) * x + Coeff(3, 1) * x ^ 2 + Coeff(4, 1) * x ^ 3

End Function
