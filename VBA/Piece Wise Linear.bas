Public Function pwlinear(x As Double, xValues As Range, yValues As Range) As Variant
'Piece Wise Linear Function
'Author - Pushkar Gondane
'Date - 9th June 2014
Dim i As Integer
'Same number of data points check
If xValues.Rows.Count <> yValues.Rows.Count Then
    pwlinear = "X & Y Values need to have same number of data points"
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
        pwlinear = "Function cannot extrapolate"
        Exit Function
    End If
    pwlinear = yValues(i, 1)
    Exit Function
End If
'Return piecewise interpolated value
pwlinear = yValues(i, 1) + ((yValues(i + 1, 1) - yValues(i, 1)) / (xValues(i + 1, 1) - xValues(i, 1))) * (x - xValues(i, 1))
End Function
