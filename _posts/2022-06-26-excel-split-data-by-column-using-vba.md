---
layout:     post
title:      如何在 Excel 中按列分割数据到多个工作表
date:       '2022-06-26T11:13'
subtitle:   How to split data into multiple worksheets by column in excel
categories: Excel
author:     招文桃
catalog:    true
tags:
    - Excel
    - VBA
    - 数据分割
---

假设你有个 Excel 表格有很多行数据，比如有 ”年份“，”项目部“ 和 ”金额“ 这三个列（见下图 1）。然后你想将数据按照 ”项目部“ 分割成独立工作表，即工作表 “一部” 仅包含一部的数据。可能你还想将已分割的工作表分别保存到各个独立的 Excel 文件中，下文就说明如何使用 Excel VBA 脚本完成这些操作。

首先看看表格的结构，和想要分割的效果。
![分割数据](/img/excel-split-data.png)
<p align="center">图 1</p>

接下来是 VBA 脚本代码和注释：

```vba
    Sub Splitdatabycol()
    'comment by zwt
    Dim lr As Long
    Dim ws As Worksheet
    Dim vcol, i As Integer
    Dim icol As Long
    Dim myarr As Variant
    Dim title As String
    Dim titlerow As Integer
    Dim xTRg As Range
    Dim xVRg As Range
    Dim xWSTRg As Worksheet
    Dim wb As Workbook

    On Error Resume Next
    Set xTRg = Application.InputBox("请选择标题行：", "演示按列分割数据", "", Type:=8)
    If TypeName(xTRg) = "Nothing" Then Exit Sub
    Set xVRg = Application.InputBox("请选择要拆分的列：", "演示按列分割数据", "", Type:=8)
    If TypeName(xVRg) = "Nothing" Then Exit Sub
    vcol = xVRg.Column
    Set ws = xTRg.Worksheet
    lr = ws.Cells(ws.Rows.Count, vcol).End(xlUp).Row
    title = xTRg.AddressLocal
    titlerow = xTRg.Cells(1).Row
    icol = ws.Columns.Count
    ws.Cells(1, icol) = "Unique"
    Application.DisplayAlerts = False
    If Not Evaluate("=ISREF('xTRgWs_Sheet!A1')") Then
    Sheets.Add(after:=Worksheets(Worksheets.Count)).Name = "xTRgWs_Sheet"
    Else
    Sheets("xTRgWs_Sheet").Delete
    Sheets.Add(after:=Worksheets(Worksheets.Count)).Name = "xTRgWs_Sheet"
    End If
    Set xWSTRg = Sheets("xTRgWs_Sheet")
    xTRg.Copy
    xWSTRg.Paste Destination:=xWSTRg.Range("A1")
    ws.Activate
    For i = (titlerow + xTRg.Rows.Count) To lr
    On Error Resume Next
    If ws.Cells(i, vcol) <> "" And Application.WorksheetFunction.Match(ws.Cells(i, vcol), ws.Columns(icol), 0) = 0 Then
    ws.Cells(ws.Rows.Count, icol).End(xlUp).Offset(1) = ws.Cells(i, vcol)
    End If
    Next
    myarr = Application.WorksheetFunction.Transpose(ws.Columns(icol).SpecialCells(xlCellTypeConstants))
    ws.Columns(icol).Clear
    For i = 2 To UBound(myarr)
    ws.Range(title).AutoFilter field:=vcol, Criteria1:=myarr(i) & ""
    If Not Evaluate("=ISREF('" & myarr(i) & "'!A1)") Then
    Sheets.Add(after:=Worksheets(Worksheets.Count)).Name = myarr(i) & ""
    Else
    Sheets(myarr(i) & "").Move after:=Worksheets(Worksheets.Count)
    End If
    xWSTRg.Range(title).Copy
    Sheets(myarr(i) & "").Paste Destination:=Sheets(myarr(i) & "").Range("A1")
    ws.Range("A" & (titlerow + xTRg.Rows.Count) & ":A" & lr).EntireRow.Copy Sheets(myarr(i) & "").Range("A" & (titlerow + xTRg.Rows.Count))
    Sheets(myarr(i) & "").Columns.AutoFit


    Set wb = Workbooks.Add
    ThisWorkbook.Worksheets(myarr(i) & "").Copy before:=wb.Worksheets(1)
    wb.SaveAs ThisWorkbook.Path & "\" & Sheets(myarr(i) & "").Name & ".xlsx"

    wb.Close savechanges = True

    Next
    xWSTRg.Delete
    ws.AutoFilterMode = False
    ws.Activate
    Application.DisplayAlerts = True
    MsgBox("数据已经切分完成。")
    End Sub

```

以上是 VBA 脚本代码。
