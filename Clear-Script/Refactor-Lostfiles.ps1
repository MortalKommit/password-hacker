$unsortedFiles = "J:\KdocReferences\Backup_201812_week05_doc\"
$Excel = New-Object -ComObject Excel.Application
$word = New-Object -ComObject Word.Application
gci $unsortedFiles | %{ 


if($File.Extension -match '.xls|.xlsx'){

$SearchText = "Purchase Order"
$Workbook = $Excel.Workbooks.Open($File)
If($Workbook.Sheets.Item(1).Range("A:Z").Find($SearchText)){
"Purchase Order Document"

}
$Workbook.Close()

}
elseif($File.Extension -match '.doc|.docx'){
if ($word.Documents.Open($doc.FullName).Content.Find.Execute('Purchase Order'))
    {
        $word.Application.ActiveDocument.Close()
        Move-Item -Path $doc.FullName -Destination $destination -Verbose
    }
}