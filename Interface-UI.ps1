using assembly System.Windows.Forms;
$form = [System.Windows.Forms.Form]::new()
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = [System.Drawing.Color]::WhiteSmoke
$form.Text = "Create Document"
$form.Width = 640
$form.Height = 360
$form.MaximizeBox = $false

#Document Number Field Attributes
$document_number = [System.Windows.Forms.ComboBox]::new()
$document_number.Width = 0.2 * $form.Width
$document_number.Height = 0.2 * $form.Height
$document_number.AutoSize = $false
$document_number.Text = "3469"
$document_number.Font = [System.Drawing.Font]::new("Verdana", 14)
$document_number.Enabled = $false
$document_number.AutoSize = $true
#Document Text Field Attributes
$documenttext = [System.Windows.Forms.TextBox]::new()
$document_number.Dock = [System.Windows.Forms.DockStyle]::None
$document_number.Anchor = [System.Windows.Forms.AnchorStyles]::None
$documenttext.Width = 0.5 * $form.Width
$documenttext.Height = 0.2 * $form.Height
$documenttext.Font = [System.Drawing.Font]::new("Verdana", 14)
$documenttext.AutoSize = $true
#Document Type Field Attributes
$doctype = [System.Windows.Forms.ComboBox]::new()
$doctype.Width = 0.2 * $form.Width
$doctype.Height = 0.2 * $form.Height
$doctype.AutoSize = $false
$doctype.Text = "Quotation"
$doctype.Font = [System.Drawing.Font]::new("Verdana", 14)
$doctype.AutoSize = $true
#Document Number Label Attributes
$docnumberlabel = [System.Windows.Forms.Label]::new()
$docnumberlabel.Font = [System.Drawing.Font]::new("Verdana", 14)
$docnumberlabel.Text = "Document Number"
$docnumberlabel.AutoSize = $true
$docnumberlabel.Top = ($form.Height) / 12;
#Document Name Label Attributes
$documentnamelabel = [System.Windows.Forms.Label]::new()
$documentnamelabel.Font = [System.Drawing.Font]::new("Verdana", 14)
$documentnamelabel.Text = "Document Name"
$documentnamelabel.AutoSize = $true

$documentnamelabel.Top = ($form.Height) / 12;
#Document Number Label Attributes
$doctypelabel = [System.Windows.Forms.Label]::new()
$doctypelabel.Font = [System.Drawing.Font]::new("Verdana", 14)
$doctypelabel.Text = "Document Type"
$doctypelabel.AutoSize = $true
$doctypelabel.Top = ($form.Height) / 12;
$layoutcontrol = [System.Windows.Forms.TableLayoutPanel]::new()
$layoutcontrol.RowCount = 4
$layoutcontrol.ColumnCount = 3
$layoutcontrol.MinimumSize = [System.Drawing.Size]::new(30,30)
$layoutcontrol.AutoSize = $true
$layoutcontrol.AutoSizeMode = "GrowOnly"
$layoutcontrol.CellBorderStyle = "Inset"
#Generate button attributes
$generatebutton = [System.Windows.Forms.Button]::new()
$generatebutton.Font = [System.Drawing.Font]::new("Verdana", 14)
$generatebutton.Text = "Generate"
$generatebutton.AutoSize = $true
$generatebutton.AutoSizeMode = "GrowOnly"
#Add control($Control,column_index,row_index)
$layoutcontrol.Controls.Add($docnumberlabel,0,0)
$docnumberlabel.Anchor = "None"
$layoutcontrol.Controls.Add($document_number,1,0)
$document_number.Anchor = "None"
$layoutcontrol.Controls.Add($documentnamelabel,0,1)
$documentnamelabel.Anchor = "None"
$layoutcontrol.Controls.Add($documenttext,1,1)
$documenttext.Anchor = "None"
$layoutcontrol.Controls.Add($doctypelabel,0,2)
$doctypelabel.Anchor = "None"
$layoutcontrol.Controls.Add($doctype,1,2)
$doctype.Anchor = "None"
$layoutcontrol.Controls.Add($generatebutton,1,3)
$generatebutton.Anchor = "None"
#$form.Controls.Add($documenttextlabel)
#$form.Controls.Add($document_number)
#>
$layoutcontrol.Anchor = "None"
$form.Controls.Add($layoutcontrol)

$form.AutoSize = $true
$form.AutoSizeMode = "GrowOnly"
$document_number.Left = ($document_number.Width) / 12;
$document_number.Top = ($form.Height) / 12;
 
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.ShowDialog() | Out-Null
$form.close() 